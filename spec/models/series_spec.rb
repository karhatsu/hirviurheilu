require 'spec_helper'

describe Series do
  describe "create" do
    it "should create series with valid attrs" do
      create(:series)
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:race) }
    it { is_expected.to have_many(:age_groups) }
    it { is_expected.to have_many(:competitors) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    #it { should validate_presence_of(:race) }

    describe "start_day" do
      it { is_expected.to validate_numericality_of(:start_day) }
      it { is_expected.not_to allow_value(0).for(:start_day) }
      it { is_expected.to allow_value(1).for(:start_day) }
      it { is_expected.not_to allow_value(1.1).for(:start_day) }

      before do
        race = build(:race)
        allow(race).to receive(:days_count).and_return(2)
        @series = build(:series, :race => race, :start_day => 3)
      end

      it "should not be bigger than race days count" do
        expect(@series).to have(1).errors_on(:start_day)
      end
    end

    describe 'start_time' do
      it { is_expected.to allow_value(nil).for(:start_time) }

      it 'has to be less than 07:00' do
        expect(build :series, start_time: '06:59:59').to be_valid
      end

      it 'cannot be 07:00:00' do
        expect(build :series, start_time: '07:00:00').to have(1).errors_on(:start_time)
      end

      it 'cannot be 07:00:01' do
        expect(build :series, start_time: '07:00:01').to have(1).errors_on(:start_time)
      end
    end

    describe "first_number" do
      it { is_expected.to validate_numericality_of(:first_number) }
      it { is_expected.to allow_value(nil).for(:first_number) }
      it { is_expected.not_to allow_value(23.5).for(:first_number) }
      it { is_expected.not_to allow_value(0).for(:first_number) }
      it { is_expected.to allow_value(1).for(:first_number) }
    end

    describe "estimates" do
      it { is_expected.not_to allow_value(nil).for(:estimates) }
      it { is_expected.not_to allow_value(0).for(:estimates) }
      it { is_expected.not_to allow_value(1).for(:estimates) }
      it { is_expected.to allow_value(2).for(:estimates) }
      it { is_expected.not_to allow_value(3).for(:estimates) }
      it { is_expected.to allow_value(4).for(:estimates) }
      it { is_expected.not_to allow_value(5).for(:estimates) }
      it { is_expected.not_to allow_value(2.1).for(:estimates) }
    end

    describe "national_record" do
      it { is_expected.to validate_numericality_of(:national_record) }
      it { is_expected.to allow_value(nil).for(:national_record) }
      it { is_expected.not_to allow_value(23.5).for(:national_record) }
      it { is_expected.not_to allow_value(0).for(:national_record) }
      it { is_expected.to allow_value(1).for(:national_record) }
      it { is_expected.not_to allow_value(-51).for(:national_record) }
    end

    describe "time_points_type" do
      it { is_expected.to allow_value(Series::TIME_POINTS_TYPE_NORMAL).for(:time_points_type) }
      it { is_expected.to allow_value(Series::TIME_POINTS_TYPE_NONE).for(:time_points_type) }
      it { is_expected.to allow_value(Series::TIME_POINTS_TYPE_ALL_300).for(:time_points_type) }
      it { is_expected.not_to allow_value(3).for(:time_points_type) }

      it "should convert nil to default value" do
        series = create(:series, :time_points_type => nil)
        expect(series.time_points_type).to eq(Series::TIME_POINTS_TYPE_NORMAL)
      end
    end
  end

  describe '#cache_key' do
    let(:race) { create :race }
    let(:series) { create :series, race: race }

    it 'contains series and race timestamps' do
      race_ts = race.updated_at.utc.to_s(:nsec)
      series_ts = series.updated_at.utc.to_s(:nsec)
      expect(series.cache_key).to eq("series/#{series.id}-#{series_ts}-#{race_ts}")
    end
  end
  
  describe "has_start_list" do
    context "when race start order is by series" do
      before do
        @race = create(:race, :start_order => Race::START_ORDER_BY_SERIES)
      end
      
      it "should become false on create" do
        series = create(:series, :race => @race)
        expect(series).not_to have_start_list
      end
      
      it "should stay true if already is true" do
        series = create(:series, :race => @race, :has_start_list => true)
        expect(series).to have_start_list
      end
    end
    
    context "when race start order is mixed" do
      before do
        @race = create(:race, :start_order => Race::START_ORDER_MIXED)
        @series = create(:series, :race => @race)
      end
      
      it "should become true on create" do
        expect(@series).to have_start_list
      end
    end
  end

  describe "#best_time_in_seconds" do
    describe "for whole series" do
      before do
        @series = create(:series)
        @series.competitors << build(:competitor, :series => @series)
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '12:00:00')
        # below the time is 60 secs but the competitors are not valid
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNS")
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNF")
        @series.competitors << build(:competitor, :series => @series,
           :start_time => '12:00:00', :arrival_time => '12:01:00',
           :no_result_reason => "DQ")
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '12:00:00',
          :arrival_time => '12:01:00', :unofficial => true)
      end
  
      it "should return nil if no competitors" do
        series = create(:series)
        expect(series.send(:best_time_in_seconds, [nil], false)).to be_nil
      end
  
      it "should return nil if no official, finished competitors with time" do
        expect(@series.send(:best_time_in_seconds, [nil], false)).to be_nil
      end
  
      describe "finished competitors found" do
        before do
          @series.competitors << build(:competitor, :series => @series,
            :start_time => '12:00:00', :arrival_time => '12:01:02') # 62 s
          @series.competitors << build(:competitor, :series => @series,
            :start_time => '12:00:01', :arrival_time => '12:01:03') # 62 s
          @series.competitors << build(:competitor, :series => @series,
            :start_time => '12:00:03', :arrival_time => '12:01:04') # 61 s
        end
  
        it "should return the fastest time for official, finished competitors" do
          expect(@series.send(:best_time_in_seconds, [nil], false)).to eq(61)
        end
  
        it "should return the fastest time of all finished competitors when unofficials included" do
          expect(@series.send(:best_time_in_seconds, [nil], true)).to eq(60)
        end
      end
  
      it "should use postgres syntax when postgres database" do
        expect_postgres_query_for_minimum_time({:unofficial => false, :no_result_reason => nil, age_group_id: [nil, 0]}, 123)
        expect(@series.send(:best_time_in_seconds, [nil], false)).to eq(123)
      end
    end
    
    describe "for given age groups" do
      before do
        @series = create(:series)
        @age_group_M75 = build(:age_group, :series => @series)
        @age_group_M80 = build(:age_group, :series => @series)
        @age_group_other = build(:age_group, :series => @series)
        @series.age_groups << @age_group_M75
        @series.age_groups << @age_group_M80
        @series.age_groups << @age_group_other
        @series.competitors << build(:competitor, :series => @series, :age_group => @age_group_M75)
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '12:00:00', :age_group => @age_group_M75)
        # below the time is 60 secs but the competitors are not valid
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNS", :age_group => @age_group_M80)
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DNF", :age_group => @age_group_M75)
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00',
          :no_result_reason => "DQ", :age_group => @age_group_M75)
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '12:00:00',
          :arrival_time => '12:01:00', :unofficial => true, :age_group => @age_group_M80)
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '12:00:00', :arrival_time => '12:01:00', :age_group => @age_group_other)
        @age_groups = [@age_group_M75, @age_group_M80, nil]
        @age_group_ids = [@age_group_M75.id, @age_group_M80.id, nil, 0]
      end
  
      it "should return nil if no competitors" do
        series = create(:series)
        expect(series.send(:best_time_in_seconds, @age_groups, false)).to be_nil
      end
  
      it "should return nil if no official, finished competitors with time" do
        expect(@series.send(:best_time_in_seconds, @age_groups, false)).to be_nil
      end
  
      describe "finished competitors found" do
        before do
          @series.competitors << build(:competitor, :series => @series,
            :start_time => '12:00:00', :arrival_time => '12:01:02', :age_group => @age_group_M75) # 62 s
          @series.competitors << build(:competitor, :series => @series,
            :start_time => '12:00:01', :arrival_time => '12:01:03', :age_group => @age_group_M80) # 62 s
          @series.competitors << build(:competitor, :series => @series,
            :start_time => '12:00:03', :arrival_time => '12:01:04', :age_group => @age_group_M75) # 61 s
        end
  
        it "should return the fastest time for official, finished competitors" do
          expect(@series.send(:best_time_in_seconds, @age_groups, false)).to eq(61)
        end
  
        it "should return the fastest time of all finished competitors when unofficials included" do
          expect(@series.send(:best_time_in_seconds, @age_groups, true)).to eq(60)
        end
      end
  
      it "should use postgres syntax when postgres database" do
        expect_postgres_query_for_minimum_time({:unofficial => false, :no_result_reason => nil, :age_group_id => @age_group_ids}, 123)
        expect(@series.send(:best_time_in_seconds, @age_groups, false)).to eq(123)
      end
    end
    
    describe "cache" do
      before do
        @series = build(:series)
        @competitors = [instance_double(Competitor)]
        expect(@series).to receive(:competitors).once.and_return(@competitors)
        @age_groups = [double(AgeGroup, id: 1), double(AgeGroup, id: 2)]
      end
      
      context "when first method call returns non-nil" do
        it "should return correct value without db query" do
          result = "1234"
          limited_competitors = double(Array)
          expect(@competitors).to receive(:where).once.and_return(limited_competitors)
          expect(limited_competitors).to receive(:minimum).once.and_return(result)
          expect(@series.send(:best_time_in_seconds, @age_groups, true)).to eq(result.to_i)
          expect(@series.send(:best_time_in_seconds, @age_groups, true)).to eq(result.to_i)
        end
      end
      
      context "when first method call returns nil" do
        it "should return nil without db query" do
          limited_competitors = double(Array)
          expect(@competitors).to receive(:where).once.and_return(limited_competitors)
          expect(limited_competitors).to receive(:minimum).once.and_return(nil)
          expect(@series.send(:best_time_in_seconds, @age_groups, true)).to eq(nil)
          expect(@series.send(:best_time_in_seconds, @age_groups, true)).to eq(nil)
        end
      end
    end
  end
  
  describe "#comparison_time_in_seconds" do
    before do
      @series = build(:series)
      @all_competitors = true
    end
    
    it "should get age group comparison groups and call best_time_in_seconds with that" do
      age_group = instance_double(AgeGroup)
      hash = double(Hash)
      age_group_array = double(Array)
      expect(@series).to receive(:age_groups_for_comparison_time).with(@all_competitors).and_return(hash)
      expect(hash).to receive(:[]).with(age_group).and_return(age_group_array)
      expect(@series).to receive(:best_time_in_seconds).with(age_group_array, @all_competitors).and_return(9998)
      expect(@series.comparison_time_in_seconds(age_group, @all_competitors)).to eq(9998)
    end
  end
  
  describe "#age_groups_for_comparison_time" do
    before do
      @series = build(:series, :name => 'M70')
      @all_competitors = true
    end
    
    context "when no age groups" do
      it "should return an empty hash" do
        groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
        expect(groups).to eq({})
      end
    end
    
    context "when age groups that start with same letters" do
      before do
        @age_group_M75 = build :age_group, name: 'M75', min_competitors: 3
        @age_group_M80 = build :age_group, name: 'M80', min_competitors: 3
        @age_group_M85 = build :age_group, name: 'M85', min_competitors: 3
      end
      
      context "and all age groups have enough competitors" do
        before do
          expect_ordered_age_groups(@series, [@age_group_M75, @age_group_M80, @age_group_M85])
          allow(@age_group_M75).to receive(:competitors_count).with(@all_competitors).and_return(3)
          allow(@age_group_M80).to receive(:competitors_count).with(@all_competitors).and_return(4)
          allow(@age_group_M85).to receive(:competitors_count).with(@all_competitors).and_return(3)
        end
        
        it "should return all age groups as keys and self with older age groups as values" do
          groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
          expect(groups.length).to eq(3+1) # see the next test
          expect(groups[@age_group_M75]).to eq([@age_group_M85, @age_group_M80, @age_group_M75])
          expect(groups[@age_group_M80]).to eq([@age_group_M85, @age_group_M80])
          expect(groups[@age_group_M85]).to eq([@age_group_M85])
        end

        it "should have nil referring to main series in the hash with all groups + nil (self) as values" do
          groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
          expect(groups[nil]).to eq([@age_group_M85, @age_group_M80, @age_group_M75, nil])
        end
      end
      
      context "and the first+second youngest age groups have together enough competitors" do
        before do
          expect_ordered_age_groups(@series, [@age_group_M75, @age_group_M80, @age_group_M85])
          allow(@age_group_M75).to receive(:competitors_count).with(@all_competitors).and_return(1)
          allow(@age_group_M80).to receive(:competitors_count).with(@all_competitors).and_return(2)
          allow(@age_group_M85).to receive(:competitors_count).with(@all_competitors).and_return(3)
        end
        
        it "should return a hash where the youngest age groups have all age groups" do
          groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
          expect(groups.length).to eq(4)
          expect(groups[@age_group_M75]).to eq([@age_group_M85, @age_group_M80, @age_group_M75])
          expect(groups[@age_group_M80]).to eq([@age_group_M85, @age_group_M80, @age_group_M75])
          expect(groups[@age_group_M85]).to eq([@age_group_M85])
        end

        it "should have nil referring to main series in the hash with all groups + nil (self) as values" do
          groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
          expect(groups[nil]).to eq([@age_group_M85, @age_group_M80, @age_group_M75, nil])
        end
      end
      
      context "and age groups form two combined groups plus one without enough competitors" do
        before do
          @age_group_M86 = instance_double(AgeGroup, :id => @age_group_M86, :name => 'M86', :min_competitors => 3)
          @age_group_M87 = instance_double(AgeGroup, :id => @age_group_M87, :name => 'M87', :min_competitors => 3)
          @age_group_M88 = instance_double(AgeGroup, :id => @age_group_M88, :name => 'M88', :min_competitors => 3)
          @age_group_M89 = instance_double(AgeGroup, :id => @age_group_M89, :name => 'M89', :min_competitors => 3)
          @age_groups = [@age_group_M75, @age_group_M80, @age_group_M85, @age_group_M86, @age_group_M87, @age_group_M88, @age_group_M89]
          @age_groups.each do |age_group|
            allow(age_group).to receive(:competitors_count).with(@all_competitors).and_return(1)
            allow(age_group).to receive(:shorter_trip).and_return(false)
          end
          expect_ordered_age_groups(@series, @age_groups)
        end
        
        it "should return correct hash" do
          groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
          expect(groups.length).to eq(8)
          all_age_groups = (@age_groups.reverse << nil)
          expect(groups[nil]).to eq(all_age_groups)
          expect(groups[@age_group_M75]).to eq(all_age_groups)
          expect(groups[@age_group_M80]).to eq([@age_group_M89, @age_group_M88, @age_group_M87, @age_group_M86, @age_group_M85, @age_group_M80])
          expect(groups[@age_group_M85]).to eq([@age_group_M89, @age_group_M88, @age_group_M87, @age_group_M86, @age_group_M85, @age_group_M80])
          expect(groups[@age_group_M86]).to eq([@age_group_M89, @age_group_M88, @age_group_M87, @age_group_M86, @age_group_M85, @age_group_M80])
          expect(groups[@age_group_M87]).to eq([@age_group_M89, @age_group_M88, @age_group_M87])
          expect(groups[@age_group_M88]).to eq([@age_group_M89, @age_group_M88, @age_group_M87])
          expect(groups[@age_group_M89]).to eq([@age_group_M89, @age_group_M88, @age_group_M87])
        end

        context "and oldest groups have shorter trip to run" do
          before do
            allow(@age_group_M88).to receive(:shorter_trip).and_return(true)
            allow(@age_group_M89).to receive(:shorter_trip).and_return(true)
          end

          it "should not mix those age groups with the other ones having a longer trip" do
            groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
            expect(groups.length).to eq(8)
            all_groups_with_longer_trip = [@age_group_M87, @age_group_M86, @age_group_M85, @age_group_M80, @age_group_M75, nil]
            expect(groups[nil]).to eq(all_groups_with_longer_trip)
            expect(groups[@age_group_M75]).to eq(all_groups_with_longer_trip)
            expect(groups[@age_group_M80]).to eq(all_groups_with_longer_trip)
            expect(groups[@age_group_M85]).to eq([@age_group_M87, @age_group_M86, @age_group_M85])
            expect(groups[@age_group_M86]).to eq([@age_group_M87, @age_group_M86, @age_group_M85])
            expect(groups[@age_group_M87]).to eq([@age_group_M87, @age_group_M86, @age_group_M85])
            expect(groups[@age_group_M88]).to eq([@age_group_M89, @age_group_M88])
            expect(groups[@age_group_M89]).to eq([@age_group_M89, @age_group_M88])
          end
        end
      end
    end
      
    context "when age groups that start with different letters" do
      before do
        @age_group_T16 = instance_double(AgeGroup, :name => 'T16', :min_competitors => 1)
        @age_group_P16 = instance_double(AgeGroup, :name => 'P16', :min_competitors => 1)
        expect_ordered_age_groups(@series, [@age_group_T16, @age_group_P16])
      end
      
      it "should return hash with each age group referring only to itself inside of an array" do
        groups = @series.send(:age_groups_for_comparison_time, @all_competitors)
        expect(groups.length).to eq(2)
        expect(groups[@age_group_T16]).to eq([@age_group_T16])
        expect(groups[@age_group_P16]).to eq([@age_group_P16])
      end
    end

    def expect_ordered_age_groups(series, age_groups)
      tmp_groups = double(Array)
      expect(series).to receive(:age_groups).and_return(tmp_groups)
      expect(tmp_groups).to receive(:except).with(:order).and_return(age_groups)
      expect(age_groups).to receive(:order).with('name desc').and_return(age_groups.reverse)
    end
  end

  describe "#ordered_competitors" do
    it "should call Competitor.sort_competitors with all competitors in the series" do
      all_competitors = false
      series = build(:series)
      competitors, included = ['a', 'b', 'c'], ['d', 'e']
      allow(series).to receive(:competitors).and_return(competitors)
      expect(competitors).to receive(:includes).with([:shots, :club, :age_group, :series]).
        and_return(included)
      expect(Competitor).to receive(:sort_competitors).with(included, all_competitors, Competitor::SORT_BY_POINTS).and_return([1, 2, 3])
      expect(series.ordered_competitors(all_competitors)).to eq([1, 2, 3])
    end
    
    context "when sort parameter given" do
      it "should call Competitor.sort_competitors with given sort parameter" do
        all_competitors = false
        series = build(:series)
        competitors, included = ['a', 'b', 'c'], ['d', 'e']
        allow(series).to receive(:competitors).and_return(competitors)
        expect(competitors).to receive(:includes).with([:shots, :club, :age_group, :series]).
          and_return(included)
        expect(Competitor).to receive(:sort_competitors).with(included, all_competitors, Competitor::SORT_BY_TIME).and_return([1, 2, 3])
        expect(series.ordered_competitors(all_competitors, Competitor::SORT_BY_TIME)).to eq([1, 2, 3])
      end
    end
  end

  describe "#start_list" do
    it "should return empty array when no competitors" do
      expect(build(:series).start_list).to eq([])
    end

    it "should return competitors with start time ordered by start time, then by start number" do
      series = create(:series)
      c1 = build(:competitor, :series => series, :start_time => '15:15')
      c2 = build(:competitor, :series => series, :start_time => '9:00:00')
      c3 = build(:competitor, :series => series, :start_time => '9:00:01', :number => 6)
      c4 = build(:competitor, :series => series, :start_time => '9:00:01', :number => 5)
      c5 = build(:competitor, :series => series, :start_time => nil)
      series.competitors << c1
      series.competitors << c2
      series.competitors << c3
      series.competitors << c4
      series.competitors << c5
      expect(series.start_list).to eq([c2, c4, c3, c1])
    end
  end
  
  describe "#next_start_number" do
    it "should return the value from race" do
      race = build :race
      expect(race).to receive(:next_start_number).and_return(123)
      series = build(:series, :race => race)
      expect(series.next_start_number).to eq(123)
    end
  end
  
  describe "#next_start_time" do
    it "should return the value from race" do
      race = build :race
      expect(race).to receive(:next_start_time).and_return(456)
      series = build(:series, :race => race)
      expect(series.next_start_time).to eq(456)
    end
  end

  describe "#some_competitor_has_arrival_time?" do
    before do
      @series = build(:series)
      @c1 = build(:competitor, :series => @series)
      @c2 = build(:competitor, :series => @series)
    end

    it "should return false when no competitors" do
      expect(@series.some_competitor_has_arrival_time?).to be_falsey
    end

    it "should return false when none of the competitors have an arrival time" do
      allow(@series).to receive(:competitors).and_return([@c1, @c2])
      expect(@series.some_competitor_has_arrival_time?).to be_falsey
    end

    it "should return true when any of the competitors have an arrival time" do
      @c2.start_time = '11:34:45'
      @c2.arrival_time = '12:34:45'
      allow(@series).to receive(:competitors).and_return([@c1, @c2])
      expect(@series.some_competitor_has_arrival_time?).to be_truthy
    end
  end

  describe "#generate_numbers" do
    before do
      @race = create(:race)
      @series = create(:series, :race => @race, :first_number => 5)
      @old1, @old2, @old3 = nil, 9, 6
      @c1 = create(:competitor, :series => @series, :number => @old1)
      @c2 = create(:competitor, :series => @series, :number => @old2)
      @c3 = create(:competitor, :series => @series, :number => @old3)
    end
    
    describe "generation fails" do
      context "some competitor already has arrival time" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = create(:competitor, :series => @series,
            :start_time => '14:00', :arrival_time => '14:30', :number => 5)
          @series.reload
          expect(@series.generate_numbers(Series::START_LIST_ADDING_ORDER)).to be_falsey
          expect(@series.errors.size).to eq(1)
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
          expect(@series.generate_numbers(Series::START_LIST_ADDING_ORDER)).to be_falsey
          expect(@series.errors.size).to eq(1)
          check_no_changes_in_competitors
        end
      end

      context "there is no space for numbers in the race" do
        before do
          series = create(:series, :race => @race, :first_number => 7)
          create(:competitor, :series => series, :number => 7)
          @race.reload
        end

        it "should do nothing for competitors, add error and return false" do
          @series.reload
          expect(@series.generate_numbers(Series::START_LIST_ADDING_ORDER)).to be_falsey
          expect(@series.errors.size).to eq(1)
          check_no_changes_in_competitors
        end
      end
      
      def check_no_changes_in_competitors
        reload_competitors
        expect(@c1.number).to eq(@old1)
        expect(@c2.number).to eq(@old2)
        expect(@c3.number).to eq(@old3)
      end
    end

    describe "generation succeeds" do
      describe "adding order" do
        it "should generate numbers based on series first number and return true" do
          expect(@series.generate_numbers(Series::START_LIST_ADDING_ORDER)).to be_truthy
          expect(@series).to be_valid
          reload_competitors
          expect(@c1.number).to eq(5)
          expect(@c2.number).to eq(6)
          expect(@c3.number).to eq(7)
        end
      end

      describe "random order" do
        it "should generate numbers based on series first number and return true" do
          expect(@series.generate_numbers(Series::START_LIST_RANDOM)).to be_truthy
          expect(@series).to be_valid
          reload_competitors
          expect([5,6,7]).to include(@c1.number)
          expect([5,6,7]).to include(@c2.number)
          expect([5,6,7]).to include(@c3.number)
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
        expect(@race).to receive(:set_correct_estimates_for_competitors)
        expect(@series.generate_numbers(Series::START_LIST_ADDING_ORDER)).to be_truthy
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
      @series = build(:series)
    end

    it "should return true when generation succeeds" do
      expect(@series).to receive(:generate_numbers).with(0).and_return(true)
      expect(@series.generate_numbers!(0)).to be_truthy
    end

    it "raise exception if generation fails" do
      expect(@series).to receive(:generate_numbers).with(0).and_return(false)
      expect { @series.generate_numbers!(0) }.to raise_error(RuntimeError)
    end
  end

  describe "#generate_start_times" do
    before do
      @race = create(:race, :start_date => '2010-08-15',
        :start_interval_seconds => 30)
      @series = create(:series, :race => @race,
        :first_number => 9, :start_time => '2010-08-15 10:00:15')
      @c1 = create(:competitor, :series => @series, :number => 9)
      @c2 = create(:competitor, :series => @series, :number => 11)
      @c3 = create(:competitor, :series => @series, :number => 13)
    end

    describe "generation fails" do
      context "competitors are missing numbers" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = create(:competitor, :series => @series, :number => nil)
          @series.reload
          expect(@series.generate_start_times).to be_falsey
          expect(@series.errors.size).to eq(1)
          check_competitors_no_changes([@c1, @c2, @c3, @c4])
        end
      end

      context "some competitor already has arrival time" do
        it "should do nothing for competitors, add error and return false" do
          @c4 = create(:competitor, :series => @series,
            :start_time => '14:00', :arrival_time => '14:30', :number => 5)
          @series.reload
          expect(@series.generate_start_times).to be_falsey
          expect(@series.errors.size).to eq(1)
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
          expect(@series.generate_start_times).to be_falsey
          expect(@series.errors.size).to eq(1)
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
          expect(@series.generate_start_times).to be_falsey
          expect(@series.errors.size).to eq(1)
          check_competitors_no_changes([@c1, @c2, @c3])
        end
      end
  
      def check_competitors_no_changes(competitors)
        competitors.each do |c|
          c.reload
          expect(c.start_time).to be_nil
        end
      end
    end

    describe "generation succeeds" do
      context "without batches" do
        it "should generate start times based on time interval and numbers and return true" do
          expect(@series.generate_start_times).to be_truthy
          expect(@series).to be_valid
          @c1.reload
          @c2.reload
          @c3.reload
          expect(@c1.start_time.strftime('%H:%M:%S')).to eq('10:00:15')
          expect(@c2.start_time.strftime('%H:%M:%S')).to eq('10:01:15')
          expect(@c3.start_time.strftime('%H:%M:%S')).to eq('10:02:15')
        end
      end

      context "with batches" do
        before do
          @race = create(:race, :start_date => '2010-08-15',
            :start_interval_seconds => 30, :batch_interval_seconds => 180,
            :batch_size => 3)
          @series = create(:series, :race => @race,
            :first_number => 1, :start_time => '2010-08-15 10:00:15')
          @c1 = create(:competitor, :series => @series, :number => 1)
          @c2 = create(:competitor, :series => @series, :number => 2)
          @c3 = create(:competitor, :series => @series, :number => 3)
          @c4 = create(:competitor, :series => @series, :number => 4)
          @c5 = create(:competitor, :series => @series, :number => 5)
          @c6 = create(:competitor, :series => @series, :number => 6)
          @c7 = create(:competitor, :series => @series, :number => 7)
          @c8 = create(:competitor, :series => @series, :number => 8)
        end
  
        describe "when batch generation succeeds" do
          it "should generate start times based on batch size, batch interval and time interval and numbers and return true" do
            expect(@series.generate_start_times).to be_truthy
            expect(@series).to be_valid
            @c1.reload
            @c2.reload
            @c3.reload
            @c4.reload
            @c5.reload
            @c6.reload
            expect(@c1.start_time.strftime('%H:%M:%S')).to eq('10:00:15')
            expect(@c2.start_time.strftime('%H:%M:%S')).to eq('10:00:45')
            expect(@c3.start_time.strftime('%H:%M:%S')).to eq('10:01:15')
            expect(@c4.start_time.strftime('%H:%M:%S')).to eq('10:04:15')
            expect(@c5.start_time.strftime('%H:%M:%S')).to eq('10:04:45')
            expect(@c6.start_time.strftime('%H:%M:%S')).to eq('10:05:15')
          end
        end
        context "when last batch is short" do
          describe "when last batch tail attachment succeeds" do
            it "should generate start times based on batch size, batch interval and time interval and numbers and return true" do
              expect(@series.generate_start_times).to be_truthy
              expect(@series).to be_valid
              @c7.reload
              @c8.reload
              expect(@c7.start_time.strftime('%H:%M:%S')).to eq('10:05:45')
              expect(@c8.start_time.strftime('%H:%M:%S')).to eq('10:06:15')
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
              expect(@series.generate_start_times).to be_truthy
              expect(@series).to be_valid
            end
            it "should generate start times based on batch size, batch interval and time interval and numbers and return true" do
              expect(@series.generate_start_times).to be_truthy
              expect(@series).to be_valid
              @c1.reload
              @c2.reload
              expect(@c1.start_time.strftime('%H:%M:%S')).to eq('10:00:15')
              expect(@c2.start_time.strftime('%H:%M:%S')).to eq('10:00:45')
              expect(@c3.start_time).to be_nil
            end
          end
        end
      end
    end
  end

  describe "#generate_start_times!" do
    before do
      @series = build(:series)
    end
    
    it "should return true when generation succeeds" do
      expect(@series).to receive(:generate_start_times).and_return(true)
      expect(@series.generate_start_times!).to be_truthy
    end
    
    it "raise exception if generation fails" do
      expect(@series).to receive(:generate_start_times).and_return(false)
      expect { @series.generate_start_times! }.to raise_error(RuntimeError)
    end
  end

  describe "#generate_start_list" do
    before do
      @series = create(:series)
    end

    context "when generation succeeds" do
      it "should call generate_numbers and generate_start_times" do
        expect(@series).to receive(:generate_numbers).with(0).and_return(true)
        expect(@series).to receive(:generate_start_times).and_return(true)
        expect(@series.generate_start_list(0)).to be_truthy
        @series.reload
        expect(@series).to have_start_list
      end
    end

    context "when number generation fails" do
      it "should not generate start times, should return false and have no start list" do
        expect(@series).to receive(:generate_numbers).with(0).and_return(false)
        expect(@series).not_to receive(:generate_start_times)
        expect(@series.generate_start_list(0)).to be_falsey
        @series.reload
        expect(@series).not_to have_start_list
      end
    end

    context "when start number generation fails" do
      it "should return false and have no start list" do
        expect(@series).to receive(:generate_numbers).with(0).and_return(true)
        expect(@series).to receive(:generate_start_times).and_return(false)
        expect(@series.generate_start_list(0)).to be_falsey
        @series.reload
        expect(@series).not_to have_start_list
      end
    end
  end

  describe "#generate_start_list!" do
    before do
      @series = create(:series)
    end

    context "when generation succeeds" do
      it "should set has_start_list to true and return true" do
        expect(@series).to receive(:generate_numbers!).with(0)
        expect(@series).to receive(:generate_start_times!)
        expect(@series.generate_start_list!(0)).to be_truthy
        @series.reload
        expect(@series).to have_start_list
      end
    end
  end

  describe "#active?" do
    before do
      @race = build(:race)
    end

    context "when race finished" do
      it "should return false" do
        allow(@race).to receive(:finished?).and_return(true)
        series = Series.new(race: @race)
        expect(series).not_to be_active
      end
    end

    context "when race not finished" do
      before do
        allow(@race).to receive(:finished?).and_return(false)
      end

      it "should return false when series not started" do
        series = Series.new(race: @race)
        allow(series).to receive(:started?).and_return(false)
        expect(series).not_to be_active
      end

      it "should return true when series started" do
        series = Series.new(race: @race)
        allow(series).to receive(:started?).and_return(true)
        expect(series).to be_active
      end
    end
  end

  describe "#started?" do
    context "when no start time" do
      it "should return false" do
        expect(Series.new).not_to be_started
      end
    end

    context "when start time" do
      before do
        @series = build(:series, start_time: '10:00')
      end

      context "and start date time before current time" do
        it "should return true" do
          allow(@series).to receive(:start_datetime).and_return(Time.now - 1)
          expect(@series).to be_started
        end
      end

      context "and start date time after current time" do
        it "should return false" do
          allow(@series).to receive(:start_datetime).and_return(Time.now + 1)
          expect(@series).not_to be_started
        end
      end
    end
  end

  describe "#each_competitor_has_number?" do
    before do
      @series = create(:series)
      @series.competitors << build(:competitor, :series => @series,
        :number => 1)
    end

    context "when at least one number is missing" do
      before do
        @series.competitors << build(:competitor, :series => @series,
          :number => nil)
      end

      specify { expect(@series.each_competitor_has_number?).to be_falsey }
    end

    context "when no numbers missing" do
      specify { expect(@series.each_competitor_has_number?).to be_truthy }
    end
  end

  describe "#each_competitor_has_start_time?" do
    before do
      @series = create(:series)
      @series.competitors << build(:competitor, :series => @series,
        :start_time => '12:45')
    end

    context "when at least one start_time is missing" do
      before do
        @series.competitors << build(:competitor, :series => @series,
          :start_time => nil)
      end

      specify { expect(@series.each_competitor_has_start_time?).to be_falsey }
    end

    context "when no start_times missing" do
      specify { expect(@series.each_competitor_has_start_time?).to be_truthy }
    end
  end

  describe "#each_competitor_finished?" do
    before do
      @series = build(:series)
      @c1 = instance_double(Competitor, :finished? => true)
      @c2 = instance_double(Competitor, :finished? => false)
    end

    context "when at least one competitor hasn't finished" do
      before do
        allow(@series).to receive(:competitors).and_return([@c1, @c2])
      end

      specify { expect(@series.each_competitor_finished?).to be_falsey }
    end

    context "when all competitors have finished" do
      before do
        allow(@series).to receive(:competitors).and_return([@c1])
      end

      specify { expect(@series.each_competitor_finished?).to be_truthy }
    end
  end

  describe "#finished_competitors_count" do
    before do
      @series = build(:series)
      @c1, @c2, @c3 = double(Competitor), double(Competitor), double(Competitor)
      allow(@series).to receive(:competitors).and_return([@c1, @c2, @c3])
      allow(@c1).to receive(:finished?).and_return(true)
      allow(@c2).to receive(:finished?).and_return(false)
      allow(@c3).to receive(:finished?).and_return(true)
    end

    it "should return count of competitors who have finished" do
      expect(@series.finished_competitors_count).to eq(2)
    end
  end

  describe "#ready?" do
    before do
      @series = build(:series, :has_start_list => true)
      allow(@series).to receive(:each_competitor_finished?).and_return(true)
    end

    context "when start list not generated" do
      it "should return false" do
        @series.has_start_list = false
        expect(@series).not_to be_ready
      end
    end

    context "when start list generated" do
      context "when some competitor has no result" do
        it "should return false" do
          expect(@series).to receive(:each_competitor_finished?).and_return(false)
          expect(@series).not_to be_ready
        end
      end

      context "when each competitor has a result" do
        it "should return true" do
          expect(@series).to be_ready
        end
      end
    end
  end

  describe "#each_competitor_has_correct_estimates?" do
    before do
      @series = create(:series)
      @c1 = create(:competitor, :series => @series,
        :correct_estimate1 => 55, :correct_estimate2 => 111)
      @c2 = create(:competitor, :series => @series,
        :correct_estimate1 => 100, :correct_estimate2 => 99)
    end

    context "when 2 estimates for the series" do
      it "should return true when correct estimates exists for all competitors" do
        @series.reload
        expect(@series.each_competitor_has_correct_estimates?).to be_truthy
      end

      it "should return false when at least one competitor is missing correct estimate 1" do
        @c2.correct_estimate1 = nil
        @c2.save!
        @series.reload
        expect(@series.each_competitor_has_correct_estimates?).to be_falsey
      end

      it "should return false when at least one competitor is missing correct estimate 2" do
        @c2.correct_estimate2 = nil
        @c2.save!
        @series.reload
        expect(@series.each_competitor_has_correct_estimates?).to be_falsey
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
        expect(@series.each_competitor_has_correct_estimates?).to be_truthy
      end

      it "should return false when at least one competitor is missing correct estimate 3" do
        @c2.correct_estimate3 = nil
        @c2.save!
        @series.reload
        expect(@series.each_competitor_has_correct_estimates?).to be_falsey
      end

      it "should return false when at least one competitor is missing correct estimate 3" do
        @c2.correct_estimate4 = nil
        @c2.save!
        @series.reload
        expect(@series.each_competitor_has_correct_estimates?).to be_falsey
      end
    end
  end
  
  describe "#start_datetime" do
    it "should return value from StartDateTime module" do
      race = build :race
      series = build(:series, race: race, start_day: 2, start_time: '12:00')
      expect(series).to receive(:start_date_time).with(race, 2, series.start_time).and_return('time')
      expect(series.start_datetime).to eq('time')
    end
  end

  describe "#has_unofficial_competitors?" do
    before do
      @series = create(:series)
      @series.competitors << build(:competitor, :series => @series)
    end

    it "should return false when no unofficial competitors" do
      expect(@series).not_to have_unofficial_competitors
    end

    it "should return true when at least one unofficial competitor" do
      @series.competitors << build(:competitor, :series => @series,
        :unofficial => true)
      expect(@series).to have_unofficial_competitors
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
      expect(Series.new(:name => name).competitors_only_to_age_groups?).to eq(expected)
    end
  end
  
  describe "#age_groups_with_main_series" do
    context "when no age groups" do
      it "should be empty array" do
        expect(Series.new.age_groups_with_main_series).to be_empty
      end
    end
    
    context "when age groups" do
      before do
        @series = create(:series)
        @age_group = build(:age_group, :series => @series)
        @series.age_groups << @age_group
      end

      context "and competitors can be added to main group" do
        it "should be age groups array prepended with main series" do
          allow(@series).to receive(:competitors_only_to_age_groups?).and_return(false)
          age_groups = @series.age_groups_with_main_series
          expect(age_groups.length).to eq(2)
          expect(age_groups[0].id).to be_nil
          expect(age_groups[0].name).to eq(@series.name)
          expect(age_groups[1].id).to eq(@age_group.id)
          expect(age_groups[1].name).to eq(@age_group.name)
        end
      end
      
      context "and competitors can be added only to age groups" do
        it "should be age groups array" do
          allow(@series).to receive(:competitors_only_to_age_groups?).and_return(true)
          age_groups = @series.age_groups_with_main_series
          expect(age_groups.length).to eq(1)
          expect(age_groups[0].id).to eq(@age_group.id)
          expect(age_groups[0].name).to eq(@age_group.name)
        end
      end
    end
  end
  
  describe "#update_start_time_and_number" do
    context "when series has no start list" do
      before do
        @series = create(:series, :has_start_list => false)
        @series.competitors << create(:competitor, :series => @series,
          :start_time => '10:00', :number => 5)
      end
      
      it "should not update start times nor numbers" do
        @series.update_start_time_and_number
        expect(@series.start_time).to be_nil
        expect(@series.first_number).to be_nil
      end
    end
    
    context "when series has start list" do
      before do
        @series = create(:series, :has_start_list => true)
        @series.competitors << create(:competitor, :series => @series,
          :start_time => '10:00', :number => 5)
        c2 = create(:competitor, :series => @series, :start_time => '10:01', :number => 6)
        c3 = create(:competitor, :series => @series, :start_time => '10:02', :number => 7)
        c2.update_column(:number, 4)
        c3.update_column(:start_time, '09:59')
        @series.reload
        @series.update_start_time_and_number
      end
      
      it "should set the minimum competitor start time as series start time" do
        expect(@series.start_time.strftime('%H:%M')).to eq('09:59')
      end
      
      it "should set the minimum competitor number as series first number" do
        expect(@series.first_number).to eq(4)
      end
    end
  end
  
  describe "#has_result_for_some_competitor?" do
    context "when no competitors" do
      it "should return false" do
        expect(Series.new).not_to have_result_for_some_competitor
      end
    end
    
    context "when has competitors" do
      before do
        @series = create(:series)
        @c1 = create(:competitor, :series => @series, :start_time => '12:00')
        @c2 = create(:competitor, :series => @series, :start_time => '12:01')
      end
      
      context "but none of the competitors have neither arrival time, estimates nor shots total" do
        it "should return false" do
          @series.reload
          expect(@series).not_to have_result_for_some_competitor
        end
      end
      
      context "and some competitor has arrival time" do
        it "should return true" do
          @c1.arrival_time = '12:23:34'
          @c1.save!
          @series.reload
          expect(@series).to have_result_for_some_competitor
        end
      end
      
      context "and some competitor has estimate 1" do
        it "should return true" do
          @c2.estimate1 = 123
          @c2.save!
          @series.reload
          expect(@series).to have_result_for_some_competitor
        end
      end

      context "and some competitor has shots total" do
        it "should return true" do
          @c2.shots_total_input = 99
          @c2.save!
          @series.reload
          expect(@series).to have_result_for_some_competitor
        end
      end

      context 'and some competitor has a shot' do
        it 'should return true' do
          @c2.shots << create(:shot)
          @series.reload
          expect(@series).to have_result_for_some_competitor
        end
      end
    end
  end

  describe '#age_groups_with_shorter_trip' do
    context 'when no age groups' do
      it 'is an empty array' do
        expect(Series.new.age_groups_with_shorter_trip).to eq([])
      end
    end

    context 'when age groups' do
      it 'returns groups that have a shorter trip' do
        series = build(:series)
        normal_group = double(AgeGroup, shorter_trip: false)
        shorter_trip_group = double(AgeGroup, shorter_trip: true)
        age_groups = [normal_group, shorter_trip_group]
        expect(series).to receive(:age_groups).and_return(age_groups)
        expect(series.age_groups_with_shorter_trip).to eq([shorter_trip_group])
      end
    end
  end

  def expect_postgres_query_for_minimum_time(conditions, return_value)
    competitors = double(Array)
    limited_competitors = double(Array)
    expect(DatabaseHelper).to receive(:postgres?).and_return(true)
    expect(@series).to receive(:competitors).and_return(competitors)
    expect(competitors).to receive(:where).with(conditions).and_return(limited_competitors)
    expect(limited_competitors).to receive(:minimum).with("EXTRACT(EPOCH FROM (arrival_time-start_time))").and_return(return_value)
  end
end
