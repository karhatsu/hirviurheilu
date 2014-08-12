require 'spec_helper'

describe Series do
  describe "create" do
    it "should create series with valid attrs" do
      FactoryGirl.create(:series)
    end
  end

  describe "associations" do
    it { should belong_to(:race) }
    it { should have_many(:age_groups) }
    it { should have_many(:competitors) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    #it { should validate_presence_of(:race) }
    it { should allow_value(nil).for(:start_time) }

    describe "start_day" do
      it { should validate_numericality_of(:start_day) }
      it { should_not allow_value(0).for(:start_day) }
      it { should allow_value(1).for(:start_day) }
      it { should_not allow_value(1.1).for(:start_day) }

      before do
        race = FactoryGirl.build(:race)
        race.stub(:days_count).and_return(2)
        @series = FactoryGirl.build(:series, :race => race, :start_day => 3)
      end

      it "should not be bigger than race days count" do
        @series.should have(1).errors_on(:start_day)
      end
    end

    describe "first_number" do
      it { should validate_numericality_of(:first_number) }
      it { should allow_value(nil).for(:first_number) }
      it { should_not allow_value(23.5).for(:first_number) }
      it { should_not allow_value(0).for(:first_number) }
      it { should allow_value(1).for(:first_number) }
    end

    describe "estimates" do
      it { should_not allow_value(nil).for(:estimates) }
      it { should_not allow_value(0).for(:estimates) }
      it { should_not allow_value(1).for(:estimates) }
      it { should allow_value(2).for(:estimates) }
      it { should_not allow_value(3).for(:estimates) }
      it { should allow_value(4).for(:estimates) }
      it { should_not allow_value(5).for(:estimates) }
      it { should_not allow_value(2.1).for(:estimates) }
    end

    describe "national_record" do
      it { should validate_numericality_of(:national_record) }
      it { should allow_value(nil).for(:national_record) }
      it { should_not allow_value(23.5).for(:national_record) }
      it { should_not allow_value(0).for(:national_record) }
      it { should allow_value(1).for(:national_record) }
      it { should_not allow_value(-51).for(:national_record) }
    end

    describe "time_points_type" do
      it { should allow_value(Series::TIME_POINTS_TYPE_NORMAL).for(:time_points_type) }
      it { should allow_value(Series::TIME_POINTS_TYPE_NONE).for(:time_points_type) }
      it { should allow_value(Series::TIME_POINTS_TYPE_ALL_300).for(:time_points_type) }
      it { should_not allow_value(3).for(:time_points_type) }

      it "should convert nil to default value" do
        series = FactoryGirl.create(:series, :time_points_type => nil)
        series.time_points_type.should == Series::TIME_POINTS_TYPE_NORMAL
      end
    end
  end
  
  describe "has_start_list" do
    context "when race start order is by series" do
      before do
        @race = FactoryGirl.create(:race, :start_order => Race::START_ORDER_BY_SERIES)
      end
      
      it "should become false on create" do
        series = FactoryGirl.create(:series, :race => @race)
        series.should_not have_start_list
      end
      
      it "should stay true if already is true" do
        series = FactoryGirl.create(:series, :race => @race, :has_start_list => true)
        series.should have_start_list
      end
    end
    
    context "when race start order is mixed" do
      before do
        @race = FactoryGirl.create(:race, :start_order => Race::START_ORDER_MIXED)
        @series = FactoryGirl.create(:series, :race => @race)
      end
      
      it "should become true on create" do
        @series.should have_start_list
      end
    end
  end

  describe "#best_time_in_seconds" do
    describe "for whole series" do
      before do
        @series = FactoryGirl.create(:series)
        @series.competitors << FactoryGirl.build(:competitor, :series => @series)
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '12:00:00')
        # below the time is 60 secs but the competitors are not valid
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNS")
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNF")
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
           :start_time => '12:00:00', :arrival_time => '12:01:00',
           :no_result_reason => "DQ")
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '12:00:00',
          :arrival_time => '12:01:00', :unofficial => true)
      end
  
      it "should return nil if no competitors" do
        series = FactoryGirl.create(:series)
        series.send(:best_time_in_seconds, [nil], false).should be_nil
      end
  
      it "should return nil if no official, finished competitors with time" do
        @series.send(:best_time_in_seconds, [nil], false).should be_nil
      end
  
      describe "finished competitors found" do
        before do
          @series.competitors << FactoryGirl.build(:competitor, :series => @series,
            :start_time => '12:00:00', :arrival_time => '12:01:02') # 62 s
          @series.competitors << FactoryGirl.build(:competitor, :series => @series,
            :start_time => '12:00:01', :arrival_time => '12:01:03') # 62 s
          @series.competitors << FactoryGirl.build(:competitor, :series => @series,
            :start_time => '12:00:03', :arrival_time => '12:01:04') # 61 s
        end
  
        it "should return the fastest time for official, finished competitors" do
          @series.send(:best_time_in_seconds, [nil], false).should == 61
        end
  
        it "should return the fastest time of all finished competitors when unofficials included" do
          @series.send(:best_time_in_seconds, [nil], true).should == 60
        end
      end
  
      it "should use postgres syntax when postgres database" do
        expect_postgres_query_for_minimum_time({:unofficial => false, :no_result_reason => nil, age_group_id: [nil]}, 123)
        @series.send(:best_time_in_seconds, [nil], false).should == 123
      end
    end
    
    describe "for given age groups" do
      before do
        @series = FactoryGirl.create(:series)
        @age_group_M75 = FactoryGirl.build(:age_group, :series => @series)
        @age_group_M80 = FactoryGirl.build(:age_group, :series => @series)
        @age_group_other = FactoryGirl.build(:age_group, :series => @series)
        @series.age_groups << @age_group_M75
        @series.age_groups << @age_group_M80
        @series.age_groups << @age_group_other
        @series.competitors << FactoryGirl.build(:competitor, :series => @series, :age_group => @age_group_M75)
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '12:00:00', :age_group => @age_group_M75)
        # below the time is 60 secs but the competitors are not valid
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNS", :age_group => @age_group_M80)
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNF", :age_group => @age_group_M75)
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DQ", :age_group => @age_group_M75)
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '12:00:00',
          :arrival_time => '12:01:00', :unofficial => true, :age_group => @age_group_M80)
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00', :age_group => @age_group_other)
        @age_groups = [@age_group_M75, @age_group_M80, nil]
        @age_group_ids = [@age_group_M75.id, @age_group_M80.id, nil]
      end
  
      it "should return nil if no competitors" do
        series = FactoryGirl.create(:series)
        series.send(:best_time_in_seconds, @age_groups, false).should be_nil
      end
  
      it "should return nil if no official, finished competitors with time" do
        @series.send(:best_time_in_seconds, @age_groups, false).should be_nil
      end
  
      describe "finished competitors found" do
        before do
          @series.competitors << FactoryGirl.build(:competitor, :series => @series,
            :start_time => '12:00:00', :arrival_time => '12:01:02', :age_group => @age_group_M75) # 62 s
          @series.competitors << FactoryGirl.build(:competitor, :series => @series,
            :start_time => '12:00:01', :arrival_time => '12:01:03', :age_group => @age_group_M80) # 62 s
          @series.competitors << FactoryGirl.build(:competitor, :series => @series,
            :start_time => '12:00:03', :arrival_time => '12:01:04', :age_group => @age_group_M75) # 61 s
        end
  
        it "should return the fastest time for official, finished competitors" do
          @series.send(:best_time_in_seconds, @age_groups, false).should == 61
        end
  
        it "should return the fastest time of all finished competitors when unofficials included" do
          @series.send(:best_time_in_seconds, @age_groups, true).should == 60
        end
      end
  
      it "should use postgres syntax when postgres database" do
        expect_postgres_query_for_minimum_time({:unofficial => false, :no_result_reason => nil, :age_group_id => @age_group_ids}, 123)
        @series.send(:best_time_in_seconds, @age_groups, false).should == 123
      end
    end
    
    describe "cache" do
      before do
        @series = FactoryGirl.build(:series)
        @competitors = [mock_model(Competitor)]
        @series.should_receive(:competitors).once.and_return(@competitors)
        @age_groups = [double(AgeGroup, id: 1), double(AgeGroup, id: 2)]
      end
      
      context "when first method call returns non-nil" do
        it "should return correct value without db query" do
          result = "1234"
          limited_competitors = double(Array)
          @competitors.should_receive(:where).once.and_return(limited_competitors)
          limited_competitors.should_receive(:minimum).once.and_return(result)
          @series.send(:best_time_in_seconds, @age_groups, true).should == result.to_i
          @series.send(:best_time_in_seconds, @age_groups, true).should == result.to_i
        end
      end
      
      context "when first method call returns nil" do
        it "should return nil without db query" do
          limited_competitors = double(Array)
          @competitors.should_receive(:where).once.and_return(limited_competitors)
          limited_competitors.should_receive(:minimum).once.and_return(nil)
          @series.send(:best_time_in_seconds, @age_groups, true).should == nil
          @series.send(:best_time_in_seconds, @age_groups, true).should == nil
        end
      end
    end
  end
  
  describe "#comparison_time_in_seconds" do
    before do
      @series = FactoryGirl.build(:series)
      @all_competitors = true
    end
    
    it "should get age group comparison groups and call best_time_in_seconds with that" do
      age_group = mock_model(AgeGroup)
      hash = double(Hash)
      age_group_array = double(Array)
      expect(@series).to receive(:age_groups_for_comparison_time).with(@all_competitors).and_return(hash)
      expect(hash).to receive(:[]).with(age_group).and_return(age_group_array)
      @series.should_receive(:best_time_in_seconds).with(age_group_array, @all_competitors).and_return(9998)
      @series.comparison_time_in_seconds(age_group, @all_competitors).should == 9998
    end
  end
  
  describe "#age_groups_for_comparison_time" do
    before do
      @series = FactoryGirl.build(:series, :name => 'M70')
      @all_competitors = true
    end
    
    context "when no age groups" do
      it "should return an empty hash" do
        groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
        groups.should == {}
      end
    end
    
    context "when age groups that start with same letters" do
      before do
        @age_group_M75 = mock_model(AgeGroup, :name => 'M75', :min_competitors => 3)
        @age_group_M80 = mock_model(AgeGroup, :name => 'M80', :min_competitors => 3)
        @age_group_M85 = mock_model(AgeGroup, :name => 'M85', :min_competitors => 3)
        @age_groups = [@age_group_M75, @age_group_M80, @age_group_M85]
        @series.stub(:age_groups).and_return(@age_groups)
        @age_groups.stub(:order).with('name desc').and_return(@age_groups.reverse)
      end
      
      context "and all age groups have enough competitors" do
        before do
          @age_group_M75.stub(:competitors_count).with(@all_competitors).and_return(3)
          @age_group_M80.stub(:competitors_count).with(@all_competitors).and_return(4)
          @age_group_M85.stub(:competitors_count).with(@all_competitors).and_return(3)
        end
        
        it "should return all age groups as keys and self with older age groups as values" do
          groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
          groups.length.should == 3+1 # see the next test
          groups[@age_group_M75].should == [@age_group_M85, @age_group_M80, @age_group_M75]
          groups[@age_group_M80].should == [@age_group_M85, @age_group_M80]
          groups[@age_group_M85].should == [@age_group_M85]
        end

        it "should have nil referring to main series in the hash with all groups + nil (self) as values" do
          groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
          groups[nil].should == [@age_group_M85, @age_group_M80, @age_group_M75, nil]
        end
      end
      
      context "and the first+second youngest age groups have together enough competitors" do
        before do
          @age_group_M75.stub(:competitors_count).with(@all_competitors).and_return(1)
          @age_group_M80.stub(:competitors_count).with(@all_competitors).and_return(2)
          @age_group_M85.stub(:competitors_count).with(@all_competitors).and_return(3)
        end
        
        it "should return a hash where the youngest age groups have all age groups" do
          groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
          groups.length.should == 4
          groups[@age_group_M75].should == [@age_group_M85, @age_group_M80, @age_group_M75]
          groups[@age_group_M80].should == [@age_group_M85, @age_group_M80, @age_group_M75]
          groups[@age_group_M85].should == [@age_group_M85]
        end

        it "should have nil referring to main series in the hash with all groups + nil (self) as values" do
          groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
          groups[nil].should == [@age_group_M85, @age_group_M80, @age_group_M75, nil]
        end
      end
      
      context "and age groups form two combined groups plus one without enough competitors" do
        before do
          @age_group_M86 = mock_model(AgeGroup, :id => @age_group_M86, :name => 'M86', :min_competitors => 3)
          @age_group_M87 = mock_model(AgeGroup, :id => @age_group_M87, :name => 'M87', :min_competitors => 3)
          @age_group_M88 = mock_model(AgeGroup, :id => @age_group_M88, :name => 'M88', :min_competitors => 3)
          @age_group_M89 = mock_model(AgeGroup, :id => @age_group_M89, :name => 'M89', :min_competitors => 3)
          @age_groups = [@age_group_M75, @age_group_M80, @age_group_M85, @age_group_M86, @age_group_M87, @age_group_M88, @age_group_M89]
          @age_groups.each do |age_group|
            age_group.stub(:competitors_count).with(@all_competitors).and_return(1)
            age_group.stub(:shorter_trip).and_return(false)
          end
          @series.stub(:age_groups).and_return(@age_groups)
          @age_groups.stub(:order).with('name desc').and_return(@age_groups.reverse)
        end
        
        it "should return correct hash" do
          groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
          groups.length.should == 8
          all_age_groups = @age_groups.reverse
          groups[@age_group_M75].should == all_age_groups
          groups[@age_group_M80].should == [@age_group_M89, @age_group_M88, @age_group_M87, @age_group_M86, @age_group_M85, @age_group_M80]
          groups[@age_group_M85].should == [@age_group_M89, @age_group_M88, @age_group_M87, @age_group_M86, @age_group_M85, @age_group_M80]
          groups[@age_group_M86].should == [@age_group_M89, @age_group_M88, @age_group_M87, @age_group_M86, @age_group_M85, @age_group_M80]
          groups[@age_group_M87].should == [@age_group_M89, @age_group_M88, @age_group_M87]
          groups[@age_group_M88].should == [@age_group_M89, @age_group_M88, @age_group_M87]
          groups[@age_group_M89].should == [@age_group_M89, @age_group_M88, @age_group_M87]
          groups[nil].should == (all_age_groups << nil)
        end

        context "and oldest groups have shorter trip to run" do
          before do
            @age_group_M88.stub(:shorter_trip).and_return(true)
            @age_group_M89.stub(:shorter_trip).and_return(true)
          end

          it "should not mix those age groups with the other ones having a longer trip" do
            groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
            groups.length.should == 8
            all_groups_with_longer_trip = [@age_group_M87, @age_group_M86, @age_group_M85, @age_group_M80, @age_group_M75]
            groups[@age_group_M75].should == all_groups_with_longer_trip
            groups[@age_group_M80].should == all_groups_with_longer_trip
            groups[@age_group_M85].should == [@age_group_M87, @age_group_M86, @age_group_M85]
            groups[@age_group_M86].should == [@age_group_M87, @age_group_M86, @age_group_M85]
            groups[@age_group_M87].should == [@age_group_M87, @age_group_M86, @age_group_M85]
            groups[@age_group_M88].should == [@age_group_M89, @age_group_M88]
            groups[@age_group_M89].should == [@age_group_M89, @age_group_M88]
            groups[nil].should == (all_groups_with_longer_trip << nil)
          end
        end
      end
    end
      
    context "when age groups that start with different letters" do
      before do
        @age_group_T16 = mock_model(AgeGroup, :name => 'T16', :min_competitors => 1)
        @age_group_P16 = mock_model(AgeGroup, :name => 'P16', :min_competitors => 1)
        @age_groups = [@age_group_T16, @age_group_P16]
        @series.stub(:age_groups).and_return(@age_groups)
        @age_groups.stub(:order).with('name desc').and_return(@age_groups.reverse)
      end
      
      it "should return hash with each age group referring only to itself" do
        groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
        groups.length.should == 2
        groups[@age_group_T16].should == @age_group_T16
        groups[@age_group_P16].should == @age_group_P16
      end
    end
  end

  describe "#ordered_competitors" do
    it "should call Competitor.sort_competitors with all competitors in the series" do
      all_competitors = false
      series = FactoryGirl.build(:series)
      competitors, included = ['a', 'b', 'c'], ['d', 'e']
      series.stub(:competitors).and_return(competitors)
      competitors.should_receive(:includes).with([:shots, :club, :age_group, :series]).
        and_return(included)
      Competitor.should_receive(:sort_competitors).with(included, all_competitors, Competitor::SORT_BY_POINTS).and_return([1, 2, 3])
      series.ordered_competitors(all_competitors).should == [1, 2, 3]
    end
    
    context "when sort parameter given" do
      it "should call Competitor.sort_competitors with given sort parameter" do
        all_competitors = false
        series = FactoryGirl.build(:series)
        competitors, included = ['a', 'b', 'c'], ['d', 'e']
        series.stub(:competitors).and_return(competitors)
        competitors.should_receive(:includes).with([:shots, :club, :age_group, :series]).
          and_return(included)
        Competitor.should_receive(:sort_competitors).with(included, all_competitors, Competitor::SORT_BY_TIME).and_return([1, 2, 3])
        series.ordered_competitors(all_competitors, Competitor::SORT_BY_TIME).should == [1, 2, 3]
      end
    end
  end

  describe "#start_list" do
    it "should return empty array when no competitors" do
      FactoryGirl.build(:series).start_list.should == []
    end

    it "should return competitors with start time ordered by start time, then by start number" do
      series = FactoryGirl.create(:series)
      c1 = FactoryGirl.build(:competitor, :series => series, :start_time => '15:15')
      c2 = FactoryGirl.build(:competitor, :series => series, :start_time => '9:00:00')
      c3 = FactoryGirl.build(:competitor, :series => series, :start_time => '9:00:01', :number => 6)
      c4 = FactoryGirl.build(:competitor, :series => series, :start_time => '9:00:01', :number => 5)
      c5 = FactoryGirl.build(:competitor, :series => series, :start_time => nil)
      series.competitors << c1
      series.competitors << c2
      series.competitors << c3
      series.competitors << c4
      series.competitors << c5
      series.start_list.should == [c2, c4, c3, c1]
    end
  end
  
  describe "#next_start_number" do
    it "should return the value from race" do
      race = mock_model(Race, :next_start_number => 123)
      series = FactoryGirl.build(:series, :race => race)
      series.next_start_number.should == 123
    end
  end
  
  describe "#next_start_time" do
    it "should return the value from race" do
      race = mock_model(Race, :next_start_time => 456)
      series = FactoryGirl.build(:series, :race => race)
      series.next_start_time.should == 456
    end
  end

  describe "#some_competitor_has_arrival_time?" do
    before do
      @series = FactoryGirl.build(:series)
      @c1 = FactoryGirl.build(:competitor, :series => @series)
      @c2 = FactoryGirl.build(:competitor, :series => @series)
    end

    it "should return false when no competitors" do
      @series.some_competitor_has_arrival_time?.should be_false
    end

    it "should return false when none of the competitors have an arrival time" do
      @series.stub(:competitors).and_return([@c1, @c2])
      @series.some_competitor_has_arrival_time?.should be_false
    end

    it "should return true when any of the competitors have an arrival time" do
      @c2.start_time = '11:34:45'
      @c2.arrival_time = '12:34:45'
      @series.stub(:competitors).and_return([@c1, @c2])
      @series.some_competitor_has_arrival_time?.should be_true
    end
  end

  describe "#generate_numbers" do
    before do
      @race = FactoryGirl.create(:race)
      @series = FactoryGirl.create(:series, :race => @race, :first_number => 5)
      @old1, @old2, @old3 = nil, 9, 6
      @c1 = FactoryGirl.create(:competitor, :series => @series, :number => @old1)
      @c2 = FactoryGirl.create(:competitor, :series => @series, :number => @old2)
      @c3 = FactoryGirl.create(:competitor, :series => @series, :number => @old3)
    end
    
    describe "generation fails" do
      context "some competitor already has arrival time" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = FactoryGirl.create(:competitor, :series => @series,
            :start_time => '14:00', :arrival_time => '14:30', :number => 5)
          @series.reload
          @series.generate_numbers(Series::START_LIST_ADDING_ORDER).should be_false
          @series.should have(1).errors
          check_no_changes_in_competitors
        end
      end

      context "series has no first number" do
        before do
          @series.first_number = nil
          @series.save!
        end

        it "should do nothing for competitors, add error and return false" do
          @series.reload
          @series.generate_numbers(Series::START_LIST_ADDING_ORDER).should be_false
          @series.should have(1).errors
          check_no_changes_in_competitors
        end
      end

      context "there is no space for numbers in the race" do
        before do
          series = FactoryGirl.create(:series, :race => @race, :first_number => 7)
          FactoryGirl.create(:competitor, :series => series, :number => 7)
          @race.reload
        end

        it "should do nothing for competitors, add error and return false" do
          @series.reload
          @series.generate_numbers(Series::START_LIST_ADDING_ORDER).should be_false
          @series.should have(1).errors
          check_no_changes_in_competitors
        end
      end
      
      def check_no_changes_in_competitors
        reload_competitors
        @c1.number.should == @old1
        @c2.number.should == @old2
        @c3.number.should == @old3
      end
    end

    describe "generation succeeds" do
      describe "adding order" do
        it "should generate numbers based on series first number and return true" do
          @series.generate_numbers(Series::START_LIST_ADDING_ORDER).should be_true
          @series.should be_valid
          reload_competitors
          @c1.number.should == 5
          @c2.number.should == 6
          @c3.number.should == 7
        end
      end

      describe "random order" do
        it "should generate numbers based on series first number and return true" do
          @series.generate_numbers(Series::START_LIST_RANDOM).should be_true
          @series.should be_valid
          reload_competitors
          [5,6,7].should include(@c1.number)
          [5,6,7].should include(@c2.number)
          [5,6,7].should include(@c3.number)
          i = 0
          while @c1.number == 5 and @c2.number == 6 and @c3.number == 7 do
            @series.generate_numbers(Series::START_LIST_RANDOM)
            reload_competitors
            i += 1
            if i > 10
              fail "Random order not working"
            end
          end
        end
      end

      it "should set correct estimates for competitors" do
        @race.should_receive(:set_correct_estimates_for_competitors)
        @series.generate_numbers(Series::START_LIST_ADDING_ORDER).should be_true
      end
    end

    def reload_competitors
      @c1.reload
      @c2.reload
      @c3.reload
    end
  end

  describe "#generate_numbers!" do
    before do
      @series = FactoryGirl.build(:series)
    end

    it "should return true when generation succeeds" do
      @series.should_receive(:generate_numbers).with(0).and_return(true)
      @series.generate_numbers!(0).should be_true
    end

    it "raise exception if generation fails" do
      @series.should_receive(:generate_numbers).with(0).and_return(false)
      lambda { @series.generate_numbers!(0) }.should raise_error
    end
  end

  describe "#generate_start_times" do
    before do
      @race = FactoryGirl.create(:race, :start_date => '2010-08-15',
        :start_interval_seconds => 30)
      @series = FactoryGirl.create(:series, :race => @race,
        :first_number => 9, :start_time => '2010-08-15 10:00:15')
      @c1 = FactoryGirl.create(:competitor, :series => @series, :number => 9)
      @c2 = FactoryGirl.create(:competitor, :series => @series, :number => 11)
      @c3 = FactoryGirl.create(:competitor, :series => @series, :number => 13)
    end

    describe "generation fails" do
      context "competitors are missing numbers" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = FactoryGirl.create(:competitor, :series => @series, :number => nil)
          @series.reload
          @series.generate_start_times.should be_false
          @series.should have(1).errors
          check_competitors_no_changes([@c1, @c2, @c3, @c4])
        end
      end

      context "some competitor already has arrival time" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = FactoryGirl.create(:competitor, :series => @series,
            :start_time => '14:00', :arrival_time => '14:30', :number => 5)
          @series.reload
          @series.generate_start_times.should be_false
          @series.should have(1).errors
          check_competitors_no_changes([@c1, @c2, @c3])
        end
      end
  
      context "series has no first number" do
        before do
          @series.first_number = nil
          @series.save!
        end

        it "should do nothing for competitors, add error and return false" do
          @series.reload
          @series.generate_start_times.should be_false
          @series.should have(1).errors
          check_competitors_no_changes([@c1, @c2, @c3])
        end
      end
  
      context "series has no start time" do
        before do
          @series.start_time = nil
          @series.save!
        end
  
        it "should do nothing for competitors, add error and return false" do
          @series.reload
          @series.generate_start_times.should be_false
          @series.should have(1).errors
          check_competitors_no_changes([@c1, @c2, @c3])
        end
      end
  
      def check_competitors_no_changes(competitors)
        competitors.each do |c|
          c.reload
          c.start_time.should be_nil
        end
      end
    end

    describe "generation succeeds" do
      context "without batches" do
        it "should generate start times based on time interval and numbers and return true" do
          @series.generate_start_times.should be_true
          @series.should be_valid
          @c1.reload
          @c2.reload
          @c3.reload
          @c1.start_time.strftime('%H:%M:%S').should == '10:00:15'
          @c2.start_time.strftime('%H:%M:%S').should == '10:01:15'
          @c3.start_time.strftime('%H:%M:%S').should == '10:02:15'
        end
      end

      context "with batches" do
        before do
          @race = FactoryGirl.create(:race, :start_date => '2010-08-15',
            :start_interval_seconds => 30, :batch_interval_seconds => 180,
            :batch_size => 3)
          @series = FactoryGirl.create(:series, :race => @race,
            :first_number => 1, :start_time => '2010-08-15 10:00:15')
          @c1 = FactoryGirl.create(:competitor, :series => @series, :number => 1)
          @c2 = FactoryGirl.create(:competitor, :series => @series, :number => 2)
          @c3 = FactoryGirl.create(:competitor, :series => @series, :number => 3)
          @c4 = FactoryGirl.create(:competitor, :series => @series, :number => 4)
          @c5 = FactoryGirl.create(:competitor, :series => @series, :number => 5)
          @c6 = FactoryGirl.create(:competitor, :series => @series, :number => 6)
          @c7 = FactoryGirl.create(:competitor, :series => @series, :number => 7)
          @c8 = FactoryGirl.create(:competitor, :series => @series, :number => 8)
        end
  
        describe "when batch generation succeeds" do
          it "should generate start times based on batch size, batch interval and time interval and numbers and return true" do
            @series.generate_start_times.should be_true
            @series.should be_valid
            @c1.reload
            @c2.reload
            @c3.reload
            @c4.reload
            @c5.reload
            @c6.reload
            @c1.start_time.strftime('%H:%M:%S').should == '10:00:15'
            @c2.start_time.strftime('%H:%M:%S').should == '10:00:45'
            @c3.start_time.strftime('%H:%M:%S').should == '10:01:15'
            @c4.start_time.strftime('%H:%M:%S').should == '10:04:15'
            @c5.start_time.strftime('%H:%M:%S').should == '10:04:45'
            @c6.start_time.strftime('%H:%M:%S').should == '10:05:15'
          end
        end
        context "when last batch is short" do
          describe "when last batch tail attachment succeeds" do
            it "should generate start times based on batch size, batch interval and time interval and numbers and return true" do
              @series.generate_start_times.should be_true
              @series.should be_valid
              @c7.reload
              @c8.reload
              @c7.start_time.strftime('%H:%M:%S').should == '10:05:45'
              @c8.start_time.strftime('%H:%M:%S').should == '10:06:15'
            end
          end
        end
        context "when there's only one short batch" do
          describe "when last batch tail attachment succeeds" do
            before do
              @c3.destroy
              @c4.destroy
              @c5.destroy
              @c6.destroy
              @c7.destroy
              @c8.destroy
              @series.generate_start_times.should be_true
              @series.should be_valid
            end
            it "should generate start times based on batch size, batch interval and time interval and numbers and return true" do
              @series.generate_start_times.should be_true
              @series.should be_valid
              @c1.reload
              @c2.reload
              @c1.start_time.strftime('%H:%M:%S').should == '10:00:15'
              @c2.start_time.strftime('%H:%M:%S').should == '10:00:45'
              @c3.start_time.should be_nil
            end
          end
        end
      end
    end
  end

  describe "#generate_start_times!" do
    before do
      @series = FactoryGirl.build(:series)
    end
    
    it "should return true when generation succeeds" do
      @series.should_receive(:generate_start_times).and_return(true)
      @series.generate_start_times!.should be_true
    end
    
    it "raise exception if generation fails" do
      @series.should_receive(:generate_start_times).and_return(false)
      lambda { @series.generate_start_times! }.should raise_error
    end
  end

  describe "#generate_start_list" do
    before do
      @series = FactoryGirl.create(:series)
    end

    context "when generation succeeds" do
      it "should call generate_numbers and generate_start_times" do
        @series.should_receive(:generate_numbers).with(0).and_return(true)
        @series.should_receive(:generate_start_times).and_return(true)
        @series.generate_start_list(0).should be_true
        @series.reload
        @series.should have_start_list
      end
    end

    context "when number generation fails" do
      it "should not generate start times, should return false and have no start list" do
        @series.should_receive(:generate_numbers).with(0).and_return(false)
        @series.should_not_receive(:generate_start_times)
        @series.generate_start_list(0).should be_false
        @series.reload
        @series.should_not have_start_list
      end
    end

    context "when start number generation fails" do
      it "should return false and have no start list" do
        @series.should_receive(:generate_numbers).with(0).and_return(true)
        @series.should_receive(:generate_start_times).and_return(false)
        @series.generate_start_list(0).should be_false
        @series.reload
        @series.should_not have_start_list
      end
    end
  end

  describe "#generate_start_list!" do
    before do
      @series = FactoryGirl.create(:series)
    end

    context "when generation succeeds" do
      it "should set has_start_list to true and return true" do
        @series.should_receive(:generate_numbers!).with(0)
        @series.should_receive(:generate_start_times!)
        @series.generate_start_list!(0).should be_true
        @series.reload
        @series.should have_start_list
      end
    end
  end

  describe "#active?" do
    before do
      @race = FactoryGirl.build(:race)
    end

    context "when race finished" do
      it "should return false" do
        @race.stub(:finished?).and_return(true)
        series = Series.new(race: @race)
        series.should_not be_active
      end
    end

    context "when race not finished" do
      before do
        @race.stub(:finished?).and_return(false)
      end

      it "should return false when series not started" do
        series = Series.new(race: @race)
        series.stub(:started?).and_return(false)
        series.should_not be_active
      end

      it "should return true when series started" do
        series = Series.new(race: @race)
        series.stub(:started?).and_return(true)
        series.should be_active
      end
    end
  end

  describe "#started?" do
    context "when no start time" do
      it "should return false" do
        Series.new.should_not be_started
      end
    end

    context "when start time" do
      before do
        @series = FactoryGirl.build(:series, start_time: '10:00')
      end

      context "and start date time before current time" do
        it "should return true" do
          @series.stub(:start_datetime).and_return(Time.now - 1)
          @series.should be_started
        end
      end

      context "and start date time after current time" do
        it "should return false" do
          @series.stub(:start_datetime).and_return(Time.now + 1)
          @series.should_not be_started
        end
      end
    end
  end

  describe "#each_competitor_has_number?" do
    before do
      @series = FactoryGirl.create(:series)
      @series.competitors << FactoryGirl.build(:competitor, :series => @series,
        :number => 1)
    end

    context "when at least one number is missing" do
      before do
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :number => nil)
      end

      specify { @series.each_competitor_has_number?.should be_false }
    end

    context "when no numbers missing" do
      specify { @series.each_competitor_has_number?.should be_true }
    end
  end

  describe "#each_competitor_has_start_time?" do
    before do
      @series = FactoryGirl.create(:series)
      @series.competitors << FactoryGirl.build(:competitor, :series => @series,
        :start_time => '12:45')
    end

    context "when at least one start_time is missing" do
      before do
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => nil)
      end

      specify { @series.each_competitor_has_start_time?.should be_false }
    end

    context "when no start_times missing" do
      specify { @series.each_competitor_has_start_time?.should be_true }
    end
  end

  describe "#each_competitor_finished?" do
    before do
      @series = FactoryGirl.build(:series)
      @c1 = mock_model(Competitor, :finished? => true)
      @c2 = mock_model(Competitor, :finished? => false)
    end

    context "when at least one competitor hasn't finished" do
      before do
        @series.stub(:competitors).and_return([@c1, @c2])
      end

      specify { @series.each_competitor_finished?.should be_false }
    end

    context "when all competitors have finished" do
      before do
        @series.stub(:competitors).and_return([@c1])
      end

      specify { @series.each_competitor_finished?.should be_true }
    end
  end

  describe "#finished_competitors_count" do
    before do
      @series = FactoryGirl.build(:series)
      @c1, @c2, @c3 = double(Competitor), double(Competitor), double(Competitor)
      @series.stub(:competitors).and_return([@c1, @c2, @c3])
      @c1.stub(:finished?).and_return(true)
      @c2.stub(:finished?).and_return(false)
      @c3.stub(:finished?).and_return(true)
    end

    it "should return count of competitors who have finished" do
      @series.finished_competitors_count.should == 2
    end
  end

  describe "#ready?" do
    before do
      @series = FactoryGirl.build(:series, :has_start_list => true)
      @series.stub(:each_competitor_finished?).and_return(true)
    end

    context "when start list not generated" do
      it "should return false" do
        @series.has_start_list = false
        @series.should_not be_ready
      end
    end

    context "when start list generated" do
      context "when some competitor has no result" do
        it "should return false" do
          @series.should_receive(:each_competitor_finished?).and_return(false)
          @series.should_not be_ready
        end
      end

      context "when each competitor has a result" do
        it "should return true" do
          @series.should be_ready
        end
      end
    end
  end

  describe "#each_competitor_has_correct_estimates?" do
    before do
      @series = FactoryGirl.create(:series)
      @c1 = FactoryGirl.create(:competitor, :series => @series,
        :correct_estimate1 => 55, :correct_estimate2 => 111)
      @c2 = FactoryGirl.create(:competitor, :series => @series,
        :correct_estimate1 => 100, :correct_estimate2 => 99)
    end

    context "when 2 estimates for the series" do
      it "should return true when correct estimates exists for all competitors" do
        @series.reload
        @series.each_competitor_has_correct_estimates?.should be_true
      end

      it "should return false when at least one competitor is missing correct estimate 1" do
        @c2.correct_estimate1 = nil
        @c2.save!
        @series.reload
        @series.each_competitor_has_correct_estimates?.should be_false
      end

      it "should return false when at least one competitor is missing correct estimate 2" do
        @c2.correct_estimate2 = nil
        @c2.save!
        @series.reload
        @series.each_competitor_has_correct_estimates?.should be_false
      end
    end

    context "when 4 estimates for the series" do
      before do
        @series.estimates = 4
        @series.save!
        @c1.correct_estimate3 = 120
        @c1.correct_estimate4 = 110
        @c1.save!
        @c2.correct_estimate3 = 120
        @c2.correct_estimate4 = 110
        @c2.save!
      end

      it "should return true when correct estimates exists for all competitors" do
        @series.reload
        @series.each_competitor_has_correct_estimates?.should be_true
      end

      it "should return false when at least one competitor is missing correct estimate 3" do
        @c2.correct_estimate3 = nil
        @c2.save!
        @series.reload
        @series.each_competitor_has_correct_estimates?.should be_false
      end

      it "should return false when at least one competitor is missing correct estimate 3" do
        @c2.correct_estimate4 = nil
        @c2.save!
        @series.reload
        @series.each_competitor_has_correct_estimates?.should be_false
      end
    end
  end
  
  describe "#start_datetime" do
    it "should return value from StartDateTime module" do
      race = mock_model(Race)
      series = FactoryGirl.build(:series, race: race, start_day: 2, start_time: '12:00')
      series.should_receive(:start_date_time).with(race, 2, series.start_time).and_return('time')
      series.start_datetime.should == 'time'
    end
  end

  describe "#has_unofficial_competitors?" do
    before do
      @series = FactoryGirl.create(:series)
      @series.competitors << FactoryGirl.build(:competitor, :series => @series)
    end

    it "should return false when no unofficial competitors" do
      @series.should_not have_unofficial_competitors
    end

    it "should return true when at least one unofficial competitor" do
      @series.competitors << FactoryGirl.build(:competitor, :series => @series,
        :unofficial => true)
      @series.should have_unofficial_competitors
    end
  end
  
  describe "#competitors_only_to_age_groups?" do
    it "false for M" do verify('M', false) end
    it "false for M60" do verify('M60', false) end
    it "false for N50" do verify('N50', false) end
    it "true for S9" do verify('S9', true) end
    it "true for S10" do verify('S10', true) end
    it "true for S11" do verify('S11', true) end
    it "true for S20" do verify('S20', true) end
    it "false for S1X" do verify('S1X', false) end
    it "false for 1S3" do verify('AS3', false) end
    it "false for S132" do verify('S132', false) end
    
    def verify(name, expected)
      Series.new(:name => name).competitors_only_to_age_groups?.should == expected
    end
  end
  
  describe "#age_groups_with_main_series" do
    context "when no age groups" do
      it "should be empty array" do
        Series.new.age_groups_with_main_series.should be_empty
      end
    end
    
    context "when age groups" do
      before do
        @series = FactoryGirl.create(:series)
        @age_group = FactoryGirl.build(:age_group, :series => @series)
        @series.age_groups << @age_group
      end

      context "and competitors can be added to main group" do
        it "should be age groups array prepended with main series" do
          @series.stub(:competitors_only_to_age_groups?).and_return(false)
          age_groups = @series.age_groups_with_main_series
          age_groups.length.should == 2
          age_groups[0].id.should be_nil
          age_groups[0].name.should == @series.name
          age_groups[1].id.should == @age_group.id
          age_groups[1].name.should == @age_group.name
        end
      end
      
      context "and competitors can be added only to age groups" do
        it "should be age groups array" do
          @series.stub(:competitors_only_to_age_groups?).and_return(true)
          age_groups = @series.age_groups_with_main_series
          age_groups.length.should == 1
          age_groups[0].id.should == @age_group.id
          age_groups[0].name.should == @age_group.name
        end
      end
    end
  end
  
  describe "#update_start_time_and_number" do
    context "when series has no start list" do
      before do
        @series = FactoryGirl.create(:series, :has_start_list => false)
        @series.competitors << FactoryGirl.create(:competitor, :series => @series,
          :start_time => '10:00', :number => 5)
      end
      
      it "should not update start times nor numbers" do
        @series.update_start_time_and_number
        @series.start_time.should be_nil
        @series.first_number.should be_nil
      end
    end
    
    context "when series has start list" do
      before do
        @series = FactoryGirl.create(:series, :has_start_list => true)
        @series.competitors << FactoryGirl.create(:competitor, :series => @series,
          :start_time => '10:00', :number => 5)
        c2 = FactoryGirl.create(:competitor, :series => @series, :start_time => '10:01', :number => 6)
        c3 = FactoryGirl.create(:competitor, :series => @series, :start_time => '10:02', :number => 7)
        c2.update_column(:number, 4)
        c3.update_column(:start_time, '09:59')
        @series.reload
        @series.update_start_time_and_number
      end
      
      it "should set the minimum competitor start time as series start time" do
        @series.start_time.strftime('%H:%M').should == '09:59'
      end
      
      it "should set the minimum competitor number as series first number" do
        @series.first_number.should == 4
      end
    end
  end
  
  describe "#has_result_for_some_competitor?" do
    context "when no competitors" do
      it "should return false" do
        Series.new.should_not have_result_for_some_competitor
      end
    end
    
    context "when has competitors" do
      before do
        @series = FactoryGirl.create(:series)
        @c1 = FactoryGirl.create(:competitor, :series => @series, :start_time => '12:00')
        @c2 = FactoryGirl.create(:competitor, :series => @series, :start_time => '12:01')
      end
      
      context "but none of the competitors have neither arrival time, estimates nor shots total" do
        it "should return false" do
          @series.reload
          @series.should_not have_result_for_some_competitor
        end
      end
      
      context "and some competitor has arrival time" do
        it "should return true" do
          @c1.arrival_time = '12:23:34'
          @c1.save!
          @series.reload
          @series.should have_result_for_some_competitor
        end
      end
      
      context "and some competitor has estimate 1" do
        it "should return true" do
          @c2.estimate1 = 123
          @c2.save!
          @series.reload
          @series.should have_result_for_some_competitor
        end
      end

      context "and some competitor has estimate 2" do
        it "should return true" do
          @c1.estimate2 = 111
          @c1.save!
          @series.reload
          @series.should have_result_for_some_competitor
        end
      end

      context "and some competitor has shots total" do
        it "should return true" do
          @c2.shots_total_input = 99
          @c2.save!
          @series.reload
          @series.should have_result_for_some_competitor
        end
      end
    end
  end

  def expect_postgres_query_for_minimum_time(conditions, return_value)
    competitors = double(Array)
    limited_competitors = double(Array)
    DatabaseHelper.should_receive(:postgres?).and_return(true)
    @series.should_receive(:competitors).and_return(competitors)
    competitors.should_receive(:where).with(conditions).and_return(limited_competitors)
    limited_competitors.should_receive(:minimum).with("EXTRACT(EPOCH FROM (arrival_time-start_time))").and_return(return_value)
  end
end
