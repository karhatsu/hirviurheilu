require 'spec_helper'

describe Series do
  describe "create" do
    it "should create series with valid attrs" do
      Factory.create(:series)
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
        race = Factory.build(:race)
        race.stub!(:days_count).and_return(2)
        @series = Factory.build(:series, :race => race, :start_day => 3)
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
        series = Factory.create(:series, :time_points_type => nil)
        series.time_points_type.should == Series::TIME_POINTS_TYPE_NORMAL
      end
    end
  end

  describe "#best_time_in_seconds" do
    describe "for whole series" do
      before do
        @series = Factory.create(:series)
        @series.competitors << Factory.build(:competitor, :series => @series)
        @series.competitors << Factory.build(:competitor, :series => @series,
          :start_time => '12:00:00')
        # below the time is 60 secs but the competitors are not valid
        @series.competitors << Factory.build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNS")
        @series.competitors << Factory.build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNF")
        @series.competitors << Factory.build(:competitor, :series => @series,
          :start_time => '12:00:00',
          :arrival_time => '12:01:00', :unofficial => true)
      end
  
      it "should return nil if no competitors" do
        series = Factory.create(:series)
        series.best_time_in_seconds(nil, false).should be_nil
      end
  
      it "should return nil if no official, finished competitors with time" do
        @series.best_time_in_seconds(nil, false).should be_nil
      end
  
      describe "finished competitors found" do
        before do
          @series.competitors << Factory.build(:competitor, :series => @series,
            :start_time => '12:00:00', :arrival_time => '12:01:02') # 62 s
          @series.competitors << Factory.build(:competitor, :series => @series,
            :start_time => '12:00:01', :arrival_time => '12:01:03') # 62 s
          @series.competitors << Factory.build(:competitor, :series => @series,
            :start_time => '12:00:03', :arrival_time => '12:01:04') # 61 s
        end
  
        it "should return the fastest time for official, finished competitors" do
          @series.best_time_in_seconds(nil, false).should == 61
        end
  
        it "should return the fastest time of all finished competitors when unofficials included" do
          @series.best_time_in_seconds(nil, true).should == 60
        end
      end
  
      it "should use postgres syntax when postgres database" do
        competitors = mock(Array)
        DatabaseHelper.should_receive(:postgres?).and_return(true)
        @series.should_receive(:competitors).and_return(competitors)
        competitors.should_receive(:minimum).
          with("EXTRACT(EPOCH FROM (arrival_time-start_time))",
          :conditions => {:unofficial => false, :no_result_reason => nil}).
          and_return(123)
        @series.best_time_in_seconds(nil, false).should == 123
      end
    end
    
    describe "for given age group ids" do
      before do
        @series = Factory.create(:series)
        @age_group1 = Factory.build(:age_group, :series => @series)
        @age_group2 = Factory.build(:age_group, :series => @series)
        @age_group_other = Factory.build(:age_group, :series => @series)
        @series.age_groups << @age_group1
        @series.age_groups << @age_group2
        @series.age_groups << @age_group_other
        @series.competitors << Factory.build(:competitor, :series => @series, :age_group => @age_group1)
        @series.competitors << Factory.build(:competitor, :series => @series,
          :start_time => '12:00:00', :age_group => @age_group1)
        # below the time is 60 secs but the competitors are not valid
        @series.competitors << Factory.build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNS", :age_group => @age_group2)
        @series.competitors << Factory.build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNF", :age_group => @age_group1)
        @series.competitors << Factory.build(:competitor, :series => @series,
          :start_time => '12:00:00',
          :arrival_time => '12:01:00', :unofficial => true, :age_group => @age_group2)
        @series.competitors << Factory.build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00', :age_group => @age_group_other)
        @age_group_ids = [@age_group1.id, @age_group2.id]
      end
  
      it "should return nil if no competitors" do
        series = Factory.create(:series)
        series.best_time_in_seconds(@age_group_ids, false).should be_nil
      end
  
      it "should return nil if no official, finished competitors with time" do
        @series.best_time_in_seconds(@age_group_ids, false).should be_nil
      end
  
      describe "finished competitors found" do
        before do
          @series.competitors << Factory.build(:competitor, :series => @series,
            :start_time => '12:00:00', :arrival_time => '12:01:02', :age_group => @age_group1) # 62 s
          @series.competitors << Factory.build(:competitor, :series => @series,
            :start_time => '12:00:01', :arrival_time => '12:01:03', :age_group => @age_group2) # 62 s
          @series.competitors << Factory.build(:competitor, :series => @series,
            :start_time => '12:00:03', :arrival_time => '12:01:04', :age_group => @age_group1) # 61 s
        end
  
        it "should return the fastest time for official, finished competitors" do
          @series.best_time_in_seconds(@age_group_ids, false).should == 61
        end
  
        it "should return the fastest time of all finished competitors when unofficials included" do
          @series.best_time_in_seconds(@age_group_ids, true).should == 60
        end
      end
  
      it "should use postgres syntax when postgres database" do
        competitors = mock(Array)
        DatabaseHelper.should_receive(:postgres?).and_return(true)
        @series.should_receive(:competitors).and_return(competitors)
        competitors.should_receive(:minimum).
          with("EXTRACT(EPOCH FROM (arrival_time-start_time))",
          :conditions => {:unofficial => false, :no_result_reason => nil, :age_group_id => @age_group_ids}).
          and_return(123)
        @series.best_time_in_seconds(@age_group_ids, false).should == 123
      end
    end
  end
  
  describe "#comparison_time_in_seconds" do
    before do
      @series = Factory.build(:series)
      @all_competitors = true
    end
    
    context "when nil age_group given" do
      it "should call best_time_in_seconds with nil age_group_ids" do
        @series.should_receive(:best_time_in_seconds).with(nil, @all_competitors).and_return(5678)
        @series.comparison_time_in_seconds(nil, @all_competitors).should == 5678
      end
    end
    
    context "when real age group given" do
      it "should get age group comparison group ids and call best_time_in_seconds with that" do
        ids = [1, 4, 7]
        age_group = mock_model(AgeGroup)
        id_hash = { :foo => :bar, age_group => ids }
        @series.should_receive(:age_group_comparison_group_ids).with(@all_competitors).and_return(id_hash)
        @series.should_receive(:best_time_in_seconds).with(ids, @all_competitors).and_return(9998)
        @series.comparison_time_in_seconds(age_group, @all_competitors).should == 9998
      end
    end
  end
  
  describe "#age_group_comparison_group_ids" do
    before do
      @series = Factory.build(:series, :name => 'M70')
      @all_competitors = true
    end
    
    context "when no age groups" do
      it "should return an empty hash" do
        groups = @series.send(:age_group_comparison_group_ids, @all_competitors)
        groups.should == {}
      end
    end
    
    context "when age groups that start with same letters" do
      before do
        @age_group1_id = 10
        @age_group2_id = 11
        @age_group3_id = 12
        @age_group1 = mock_model(AgeGroup, :id => @age_group1_id, :name => 'M75', :min_competitors => 3)
        @age_group2 = mock_model(AgeGroup, :id => @age_group2_id, :name => 'M80', :min_competitors => 3)
        @age_group3 = mock_model(AgeGroup, :id => @age_group3_id, :name => 'M85', :min_competitors => 3)
        @age_groups = [@age_group1, @age_group2, @age_group3]
        @series.stub!(:age_groups).and_return(@age_groups)
        @age_groups.stub!(:order).with('name desc').and_return(@age_groups.reverse)
      end
      
      context "and all age groups have enough competitors" do
        before do
          @age_group1.stub!(:competitors_count).with(@all_competitors).and_return(3)
          @age_group2.stub!(:competitors_count).with(@all_competitors).and_return(4)
          @age_group3.stub!(:competitors_count).with(@all_competitors).and_return(3)
        end
        
        it "should return all age groups as keys and id + older age group ids as values" do
          groups = @series.send(:age_group_comparison_group_ids, @all_competitors)
          groups.length.should == 3
          groups[@age_group1].should == [@age_group3_id, @age_group2_id, @age_group1_id]
          groups[@age_group2].should == [@age_group3_id, @age_group2_id]
          groups[@age_group3].should == [@age_group3_id]
        end
      end
      
      context "and the first+second age group have together enough competitors" do
        before do
          @age_group1.stub!(:competitors_count).with(@all_competitors).and_return(1)
          @age_group2.stub!(:competitors_count).with(@all_competitors).and_return(2)
          @age_group3.stub!(:competitors_count).with(@all_competitors).and_return(3)
        end
        
        it "should return a hash where second age group key has all group ids as values" do
          groups = @series.send(:age_group_comparison_group_ids, @all_competitors)
          groups.length.should == 3
          groups[@age_group1].should == [@age_group3_id, @age_group2_id, @age_group1_id]
          groups[@age_group2].should == [@age_group3_id, @age_group2_id, @age_group1_id]
          groups[@age_group3].should == [@age_group3_id]
        end
      end
      
      context "and the first ones have no enough competitors" do
        before do
          @age_group1.stub!(:competitors_count).with(@all_competitors).and_return(1)
          @age_group2.stub!(:competitors_count).with(@all_competitors).and_return(1)
          @age_group3.stub!(:competitors_count).with(@all_competitors).and_return(3)
        end
        
        it "should return a hash where the first age groups have nil id as value" do
          groups = @series.send(:age_group_comparison_group_ids, @all_competitors)
          groups.length.should == 3
          groups[@age_group1].should == nil
          groups[@age_group2].should == nil
          groups[@age_group3].should == [@age_group3_id]
        end
      end
      
      context "and age groups form two combined groups plus one without enough competitors" do
        before do
          @age_group4_id = 14
          @age_group5_id = 15
          @age_group6_id = 16
          @age_group7_id = 17
          @age_group4 = mock_model(AgeGroup, :id => @age_group4_id, :name => 'M86', :min_competitors => 3)
          @age_group5 = mock_model(AgeGroup, :id => @age_group5_id, :name => 'M87', :min_competitors => 3)
          @age_group6 = mock_model(AgeGroup, :id => @age_group6_id, :name => 'M88', :min_competitors => 3)
          @age_group7 = mock_model(AgeGroup, :id => @age_group7_id, :name => 'M89', :min_competitors => 3)
          @age_groups = [@age_group1, @age_group2, @age_group3, @age_group4, @age_group5, @age_group6, @age_group7]
          @age_groups.each do |age_group|
            age_group.stub!(:competitors_count).with(@all_competitors).and_return(1)
          end
          @series.stub!(:age_groups).and_return(@age_groups)
          @age_groups.stub!(:order).with('name desc').and_return(@age_groups.reverse)
        end
        
        it "should return correct hash" do
          groups = @series.send(:age_group_comparison_group_ids, @all_competitors)
          groups.length.should == 7
          groups[@age_group1].should == nil
          groups[@age_group2].should == [@age_group7_id, @age_group6_id, @age_group5_id, @age_group4_id, @age_group3_id, @age_group2_id]
          groups[@age_group3].should == [@age_group7_id, @age_group6_id, @age_group5_id, @age_group4_id, @age_group3_id, @age_group2_id]
          groups[@age_group4].should == [@age_group7_id, @age_group6_id, @age_group5_id, @age_group4_id, @age_group3_id, @age_group2_id]
          groups[@age_group5].should == [@age_group7_id, @age_group6_id, @age_group5_id]
          groups[@age_group6].should == [@age_group7_id, @age_group6_id, @age_group5_id]
          groups[@age_group7].should == [@age_group7_id, @age_group6_id, @age_group5_id]
        end
      end
    end
      
    context "when age groups that start with different letters" do
      before do
        @age_group1_id = 10
        @age_group2_id = 11
        @age_group1 = mock_model(AgeGroup, :id => @age_group1_id, :name => 'T16', :min_competitors => 1)
        @age_group2 = mock_model(AgeGroup, :id => @age_group2_id, :name => 'P16', :min_competitors => 1)
        @age_groups = [@age_group1, @age_group2]
        @series.stub!(:age_groups).and_return(@age_groups)
        @age_groups.stub!(:order).with('name desc').and_return(@age_groups.reverse)
      end
      
      it "should return all groups with only their own ids" do
        groups = @series.send(:age_group_comparison_group_ids, @all_competitors)
        groups.length.should == 2
        groups[@age_group1].should == @age_group1_id
        groups[@age_group2].should == @age_group2_id
      end
    end
  end

  describe "#ordered_competitors" do
    it "should call Competitor.sort with all competitors in the series" do
      all_competitors = false
      series = Factory.build(:series)
      competitors, included = ['a', 'b', 'c'], ['d', 'e']
      series.stub!(:competitors).and_return(competitors)
      competitors.should_receive(:includes).with([:shots, :club, :age_group, :series]).
        and_return(included)
      Competitor.should_receive(:sort).with(included, all_competitors, Competitor::SORT_BY_POINTS).and_return([1, 2, 3])
      series.ordered_competitors(all_competitors).should == [1, 2, 3]
    end
    
    context "when sort parameter given" do
      it "should call Competitor.sort with given sort parameter" do
        all_competitors = false
        series = Factory.build(:series)
        competitors, included = ['a', 'b', 'c'], ['d', 'e']
        series.stub!(:competitors).and_return(competitors)
        competitors.should_receive(:includes).with([:shots, :club, :age_group, :series]).
          and_return(included)
        Competitor.should_receive(:sort).with(included, all_competitors, Competitor::SORT_BY_TIME).and_return([1, 2, 3])
        series.ordered_competitors(all_competitors, Competitor::SORT_BY_TIME).should == [1, 2, 3]
      end
    end
  end

  describe "#start_list" do
    it "should return empty array when no competitors" do
      Factory.build(:series).start_list.should == []
    end

    it "should return competitors with start time ordered by start time" do
      series = Factory.create(:series)
      c1 = Factory.build(:competitor, :series => series, :start_time => '15:15')
      c2 = Factory.build(:competitor, :series => series, :start_time => '9:00:00')
      c3 = Factory.build(:competitor, :series => series, :start_time => '9:00:01')
      c4 = Factory.build(:competitor, :series => series, :start_time => nil)
      series.competitors << c1
      series.competitors << c2
      series.competitors << c3
      series.competitors << c4
      series.start_list.should == [c2, c3, c1]
    end
  end

  describe "#next_number" do
    context "no competitors" do
      it "should be 1 when first_number is nil" do
        series = Factory.build(:series, :first_number => nil)
        series.next_number.should == 1
      end

      it "should be first_number when it is defined" do
        series = Factory.build(:series, :first_number => 45)
        series.next_number.should == 45
      end
    end

    context "competitors" do
      it "should the biggest number + 1" do
        series = Factory.create(:series, :first_number => 45)
        series.competitors << Factory.build(:competitor, :number => 15, :series => series)
        series.competitors << Factory.build(:competitor, :number => 24, :series => series)
        series.competitors << Factory.build(:competitor, :number => 17, :series => series)
        series.next_number.should == 25
      end

      it "should be like no competitors when competitors have no numbers yet" do
        series = Factory.create(:series, :first_number => 45)
        series.competitors << Factory.build(:competitor, :number => nil, :series => series)
        series.competitors << Factory.build(:competitor, :number => nil, :series => series)
        series.next_number.should == 45
      end
    end
  end

  describe "#next_start_time" do
    context "when no competitors" do
      it "should be nil when start_time is nil" do
        series = Factory.build(:series, :start_time => nil)
        series.next_start_time.should be_nil
      end

      it "should be start_time when it is defined" do
        series = Factory.build(:series, :start_time => '12:30')
        series.next_start_time.should == series.start_time
      end
    end

    context "when competitors" do
      it "should be the start time of the latest competitor + race time interval" do
        race = Factory.create(:race, :start_interval_seconds => 45)
        series = Factory.create(:series, :race => race)
        series.competitors << Factory.build(:competitor, :number => 15, :series => series)
        series.competitors << Factory.build(:competitor, :number => 24, :series => series,
          :start_time => '12:30:00')
        series.competitors << Factory.build(:competitor, :number => 17, :series => series)
        series.next_start_time.strftime('%H:%M:%S').should == '12:30:45'
      end

      it "should be like no competitors when competitors have no start times yet" do
        race = Factory.create(:race, :start_date => '2010-11-10')
        series = Factory.create(:series, :race => race, :start_time => '2010-11-10 09:30')
        series.competitors << Factory.build(:competitor, :start_time => nil, :series => series)
        series.competitors << Factory.build(:competitor, :start_time => nil, :series => series)
        series.next_start_time.strftime('%H:%M:%S').should == '09:30:00'
      end
    end
  end

  describe "#some_competitor_has_arrival_time?" do
    before do
      @series = Factory.build(:series)
      @c1 = Factory.build(:competitor, :series => @series)
      @c2 = Factory.build(:competitor, :series => @series)
    end

    it "should return false when no competitors" do
      @series.some_competitor_has_arrival_time?.should be_false
    end

    it "should return false when none of the competitors have an arrival time" do
      @series.stub!(:competitors).and_return([@c1, @c2])
      @series.some_competitor_has_arrival_time?.should be_false
    end

    it "should return true when any of the competitors have an arrival time" do
      @c2.start_time = '11:34:45'
      @c2.arrival_time = '12:34:45'
      @series.stub!(:competitors).and_return([@c1, @c2])
      @series.some_competitor_has_arrival_time?.should be_true
    end
  end

  describe "#generate_numbers" do
    before do
      @race = Factory.create(:race)
      @series = Factory.create(:series, :race => @race, :first_number => 5)
      @old1, @old2, @old3 = nil, 9, 6
      @c1 = Factory.create(:competitor, :series => @series, :number => @old1)
      @c2 = Factory.create(:competitor, :series => @series, :number => @old2)
      @c3 = Factory.create(:competitor, :series => @series, :number => @old3)
    end
    
    describe "generation fails" do
      context "some competitor already has arrival time" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = Factory.create(:competitor, :series => @series,
            :start_time => '14:00', :arrival_time => '14:30', :number => 5)
          @series.reload
          @series.generate_numbers(Series::START_LIST_ADDING_ORDER).should be_false
          @series.should have(1).errors
          check_competitors_no_changes
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
          check_competitors_no_changes
        end
      end

      context "there is no space for numbers in the race" do
        before do
          series = Factory.create(:series, :race => @race, :first_number => 7)
          Factory.create(:competitor, :series => series, :number => 7)
          @race.reload
        end

        it "should do nothing for competitors, add error and return false" do
          @series.reload
          @series.generate_numbers(Series::START_LIST_ADDING_ORDER).should be_false
          @series.should have(1).errors
          check_competitors_no_changes
        end
      end
      
      def check_competitors_no_changes
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
      @series = Factory.build(:series)
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
      @race = Factory.create(:race, :start_date => '2010-08-15',
        :start_interval_seconds => 30)
      @series = Factory.create(:series, :race => @race,
        :first_number => 9, :start_time => '2010-08-15 10:00:15')
      @c1 = Factory.create(:competitor, :series => @series, :number => 9)
      @c2 = Factory.create(:competitor, :series => @series, :number => 11)
      @c3 = Factory.create(:competitor, :series => @series, :number => 13)
    end

    describe "generation fails" do
      context "competitors are missing numbers" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = Factory.create(:competitor, :series => @series, :number => nil)
          @series.reload
          @series.generate_start_times.should be_false
          @series.should have(1).errors
          check_competitors_no_changes([@c1, @c2, @c3, @c4])
        end
      end

      context "some competitor already has arrival time" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = Factory.create(:competitor, :series => @series,
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
          @race = Factory.create(:race, :start_date => '2010-08-15',
            :start_interval_seconds => 30, :batch_interval_seconds => 180,
            :batch_size => 3)
          @series = Factory.create(:series, :race => @race,
            :first_number => 1, :start_time => '2010-08-15 10:00:15')
          @c1 = Factory.create(:competitor, :series => @series, :number => 1)
          @c2 = Factory.create(:competitor, :series => @series, :number => 2)
          @c3 = Factory.create(:competitor, :series => @series, :number => 3)
          @c4 = Factory.create(:competitor, :series => @series, :number => 4)
          @c5 = Factory.create(:competitor, :series => @series, :number => 5)
          @c6 = Factory.create(:competitor, :series => @series, :number => 6)
          @c7 = Factory.create(:competitor, :series => @series, :number => 7)
          @c8 = Factory.create(:competitor, :series => @series, :number => 8)
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
      @series = Factory.build(:series)
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
      @series = Factory.create(:series)
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
      @series = Factory.create(:series)
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
      @race = Factory.build(:race, :start_date => Date.today,
        :end_date => Date.today + 1, :finished => false)
      @series = Factory.build(:series, :race => @race, :start_day => 1,
        :start_time => (Time.now - 10).strftime('%H:%M:%S'))
    end

    it "should return true when the series is today and started " +
        "but the race not finished yet" do
      @series.should be_active
    end

    it "should return true when the series was yesterday " +
        "but the race is not finished yet" do
      @race.start_date = Date.today - 1
      @series.start_time = (Time.now + 100).strftime('%H:%M:%S') # time shouldn't matter
      @series.should be_active
    end

    it "should return false when no start time defined" do
      @series.start_time = nil
      @series.should_not be_active
    end

    it "should return false when the race will start in the future" do
      @race.start_date = Date.today + 1
      @series.should_not be_active
    end

    it "should return false when the race has started but the series is not today" do
      @series.start_day = 2
      @series.should_not be_active
    end

    it "should return false when the series is today but has not started yet" do
      @series.start_time = (Time.now + 100).strftime('%H:%M:%S')
      @series.should_not be_active
    end

    it "should return false when the race is finished" do
      @race.finished = true
      @series.should_not be_active
    end
  end

  describe "#destroy" do
    before do
      @series = Factory.create(:series)
    end

    it "should be prevented if series has competitors" do
      @series.competitors << Factory.build(:competitor, :series => @series)
      @series.destroy
      @series.should have(1).errors
      Series.should be_exist(@series.id)
    end

    it "should destroy series when no competitors" do
      @series.destroy
      Series.should_not be_exist(@series.id)
    end
  end

  describe "#each_competitor_has_number?" do
    before do
      @series = Factory.create(:series)
      @series.competitors << Factory.build(:competitor, :series => @series,
        :number => 1)
    end

    context "when at least one number is missing" do
      before do
        @series.competitors << Factory.build(:competitor, :series => @series,
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
      @series = Factory.create(:series)
      @series.competitors << Factory.build(:competitor, :series => @series,
        :start_time => '12:45')
    end

    context "when at least one start_time is missing" do
      before do
        @series.competitors << Factory.build(:competitor, :series => @series,
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
      @series = Factory.build(:series)
      @c1 = mock_model(Competitor, :finished? => true)
      @c2 = mock_model(Competitor, :finished? => false)
    end

    context "when at least one competitor hasn't finished" do
      before do
        @series.stub!(:competitors).and_return([@c1, @c2])
      end

      specify { @series.each_competitor_finished?.should be_false }
    end

    context "when all competitors have finished" do
      before do
        @series.stub!(:competitors).and_return([@c1])
      end

      specify { @series.each_competitor_finished?.should be_true }
    end
  end

  describe "#finished_competitors_count" do
    before do
      @series = Factory.build(:series)
      @c1, @c2, @c3 = mock(Competitor), mock(Competitor), mock(Competitor)
      @series.stub!(:competitors).and_return([@c1, @c2, @c3])
      @c1.stub!(:finished?).and_return(true)
      @c2.stub!(:finished?).and_return(false)
      @c3.stub!(:finished?).and_return(true)
    end

    it "should return count of competitors who have finished" do
      @series.finished_competitors_count.should == 2
    end
  end

  describe "#ready?" do
    before do
      @series = Factory.build(:series, :has_start_list => true)
      @series.stub!(:each_competitor_finished?).and_return(true)
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
      @series = Factory.create(:series)
      @c1 = Factory.create(:competitor, :series => @series,
        :correct_estimate1 => 55, :correct_estimate2 => 111)
      @c2 = Factory.create(:competitor, :series => @series,
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
    it "should return nil when no start time" do
      Factory.build(:series, :start_time => nil).start_datetime.should be_nil
    end
    
    it "should return nil when no race" do
      Factory.build(:series, :race => nil, :start_time => '13:45:31').start_datetime.should be_nil
    end
    
    it "should return nil when no race start date" do
      race = Factory.build(:race, :start_date => nil)
      Factory.build(:series, :race => race, :start_time => '13:45:31').start_datetime.should be_nil
    end
    
    context "when race date and start time available" do
      before do
        @race = Factory.build(:race, :start_date => '2011-06-30')
        @series = Factory.build(:series, :race => @race, :start_time => '13:45:31')
      end
      
      it "should return the compination of race date and start time when both available" do
        @series.start_datetime.strftime('%d.%m.%Y %H:%M:%S').should == '30.06.2011 13:45:31'
      end
      
      it "should return the object with local zone" do
        original_zone = Time.zone
        Time.zone = 'Hawaii'
        @series.start_datetime.zone.should == 'HST'
        Time.zone = original_zone # must reset back to original!
      end
      
      it "should return the correct date when series start day is not 1" do
        @race.end_date = '2011-07-02'
        @series.start_day = 3
        @series.start_datetime.strftime('%d.%m.%Y %H:%M:%S').should == '02.07.2011 13:45:31'
      end
    end
  end

  describe "#has_unofficial_competitors?" do
    before do
      @series = Factory.create(:series)
      @series.competitors << Factory.build(:competitor, :series => @series)
    end

    it "should return false when no unofficial competitors" do
      @series.should_not have_unofficial_competitors
    end

    it "should return true when at least one unofficial competitor" do
      @series.competitors << Factory.build(:competitor, :series => @series,
        :unofficial => true)
      @series.should have_unofficial_competitors
    end
  end
end
