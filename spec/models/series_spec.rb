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
    it { is_expected.to validate_inclusion_of(:points_method).in_array([0, 1, 2, 3]) }

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

    it_should_behave_like 'non-negative integer', :first_number, true
    it_should_behave_like 'positive integer', :national_record, true, { max_value: 1200 }
    it_should_behave_like 'positive integer', :rifle_national_record, true, { max_value: 200 }
  end

  describe 'callbacks' do
    describe 'set estimates' do
      it { expect_estimates Series::POINTS_METHOD_TIME_2_ESTIMATES, 2 }
      it { expect_estimates Series::POINTS_METHOD_TIME_4_ESTIMATES, 4 }
      it { expect_estimates Series::POINTS_METHOD_NO_TIME_4_ESTIMATES, 4 }
      it { expect_estimates Series::POINTS_METHOD_300_TIME_2_ESTIMATES, 2 }
      it { expect_estimates Series::POINTS_METHOD_NO_TIME_2_ESTIMATES, 2 }
    end

    it 'trims name' do
      series = create :series, name: ' With spaces  '
      expect(series.name).to eql 'With spaces'
    end

    def expect_estimates(points_method, estimates)
      expect(create(:series, points_method: points_method).estimates).to eql estimates
    end
  end

  describe '#cache_key' do
    let(:race) { create :race }
    let(:series) { create :series, race: race }

    it 'contains series and race timestamps' do
      race_ts = race.updated_at.utc.to_formatted_s(:usec)
      series_ts = series.updated_at.utc.to_formatted_s(:usec)
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
          :start_time => '01:00:00')
        # below the time is 60 secs but the competitors are not valid
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '01:00:00', :arrival_time => '01:01:00',
          :no_result_reason => "DNS")
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '01:00:00', :arrival_time => '01:01:00',
          :no_result_reason => "DNF")
        @series.competitors << build(:competitor, :series => @series,
           :start_time => '01:00:00', :arrival_time => '01:01:00',
           :no_result_reason => "DQ")
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '01:00:00',
          :arrival_time => '01:01:00', :unofficial => true)
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
            :start_time => '01:00:00', :arrival_time => '01:01:02') # 62 s
          @series.competitors << build(:competitor, :series => @series,
            :start_time => '01:00:01', :arrival_time => '01:01:03') # 62 s
          @series.competitors << build(:competitor, :series => @series,
            :start_time => '01:00:03', :arrival_time => '01:01:04') # 61 s
        end

        it "should return the fastest time for official, finished competitors when unofficials_rule included but without best time" do
          expect(@series.send(:best_time_in_seconds, [nil], Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)).to eq(61)
        end

        it "should return the fastest time for official, finished competitors when unofficials_rule excluded" do
          expect(@series.send(:best_time_in_seconds, [nil], Series::UNOFFICIALS_EXCLUDED)).to eq(61)
        end

        it "should return the fastest time of all finished competitors unofficials_rule included with best time" do
          expect(@series.send(:best_time_in_seconds, [nil], Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME)).to eq(60)
        end
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
          :start_time => '01:00:00', :age_group => @age_group_M75)
        # below the time is 60 secs but the competitors are not valid
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '01:00:00', :arrival_time => '01:01:00',
          :no_result_reason => "DNS", :age_group => @age_group_M80)
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '01:00:00', :arrival_time => '01:01:00',
          :no_result_reason => "DNF", :age_group => @age_group_M75)
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '01:00:00', :arrival_time => '01:01:00',
          :no_result_reason => "DQ", :age_group => @age_group_M75)
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '01:00:00',
          :arrival_time => '01:01:00', :unofficial => true, :age_group => @age_group_M80)
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '01:00:00', :arrival_time => '01:01:00', :age_group => @age_group_other)
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
            :start_time => '01:00:00', :arrival_time => '01:01:02', :age_group => @age_group_M75) # 62 s
          @series.competitors << build(:competitor, :series => @series,
            :start_time => '01:00:01', :arrival_time => '01:01:03', :age_group => @age_group_M80) # 62 s
          @series.competitors << build(:competitor, :series => @series,
            :start_time => '01:00:03', :arrival_time => '01:01:04', :age_group => @age_group_M75) # 61 s
        end

        it "should return the fastest time for official, finished competitors when unofficials_rule included but without best time" do
          expect(@series.send(:best_time_in_seconds, @age_groups, Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)).to eq(61)
        end

        it "should return the fastest time for official, finished competitors when unofficials_rule excluded" do
          expect(@series.send(:best_time_in_seconds, @age_groups, Series::UNOFFICIALS_EXCLUDED)).to eq(61)
        end

        it "should return the fastest time of all finished competitors when unofficials_rule included with best time" do
          expect(@series.send(:best_time_in_seconds, @age_groups, Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME)).to eq(60)
        end
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
      @unofficials_rule = Series::UNOFFICIALS_EXCLUDED
    end

    it "should get age group comparison groups and call best_time_in_seconds with that" do
      age_group = instance_double(AgeGroup)
      hash = double(Hash)
      age_group_array = double(Array)
      expect(@series).to receive(:age_groups_for_comparison_time).with(@unofficials_rule).and_return(hash)
      expect(hash).to receive(:[]).with(age_group).and_return(age_group_array)
      expect(@series).to receive(:best_time_in_seconds).with(age_group_array, @unofficials_rule).and_return(9998)
      expect(@series.comparison_time_in_seconds(age_group, @unofficials_rule)).to eq(9998)
    end
  end

  describe "#age_groups_for_comparison_time" do
    before do
      @series = build(:series, :name => 'M70')
      @unofficials_rule = Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME
    end

    context "when no age groups" do
      it "should return an empty hash" do
        groups = @series.send(:age_groups_for_comparison_time, @unofficials_rule)
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
          allow(@age_group_M75).to receive(:competitors_count).with(@unofficials_rule).and_return(3)
          allow(@age_group_M80).to receive(:competitors_count).with(@unofficials_rule).and_return(4)
          allow(@age_group_M85).to receive(:competitors_count).with(@unofficials_rule).and_return(3)
        end

        it "should return all age groups as keys and self with older age groups as values" do
          groups = @series.send(:age_groups_for_comparison_time, @unofficials_rule)
          expect(groups.length).to eq(3+1) # see the next test
          expect(groups[@age_group_M75]).to eq([@age_group_M85, @age_group_M80, @age_group_M75])
          expect(groups[@age_group_M80]).to eq([@age_group_M85, @age_group_M80])
          expect(groups[@age_group_M85]).to eq([@age_group_M85])
        end

        it "should have nil referring to main series in the hash with all groups + nil (self) as values" do
          groups = @series.send(:age_groups_for_comparison_time, @unofficials_rule)
          expect(groups[nil]).to eq([@age_group_M85, @age_group_M80, @age_group_M75, nil])
        end
      end

      context "and the first+second youngest age groups have together enough competitors" do
        before do
          expect_ordered_age_groups(@series, [@age_group_M75, @age_group_M80, @age_group_M85])
          allow(@age_group_M75).to receive(:competitors_count).with(@unofficials_rule).and_return(1)
          allow(@age_group_M80).to receive(:competitors_count).with(@unofficials_rule).and_return(2)
          allow(@age_group_M85).to receive(:competitors_count).with(@unofficials_rule).and_return(3)
        end

        it "should return a hash where the youngest age groups have all age groups" do
          groups = @series.send(:age_groups_for_comparison_time, @unofficials_rule)
          expect(groups.length).to eq(4)
          expect(groups[@age_group_M75]).to eq([@age_group_M85, @age_group_M80, @age_group_M75])
          expect(groups[@age_group_M80]).to eq([@age_group_M85, @age_group_M80, @age_group_M75])
          expect(groups[@age_group_M85]).to eq([@age_group_M85])
        end

        it "should have nil referring to main series in the hash with all groups + nil (self) as values" do
          groups = @series.send(:age_groups_for_comparison_time, @unofficials_rule)
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
            allow(age_group).to receive(:competitors_count).with(@unofficials_rule).and_return(1)
            allow(age_group).to receive(:shorter_trip).and_return(false)
          end
          expect_ordered_age_groups(@series, @age_groups)
        end

        it "should return correct hash" do
          groups = @series.send(:age_groups_for_comparison_time, @unofficials_rule)
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
            groups = @series.send(:age_groups_for_comparison_time, @unofficials_rule)
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

    context "when children's series" do
      before do
        @series = build(:series, :name => 'S13')
        @age_group_T13 = instance_double(AgeGroup, :name => 'T13', :min_competitors => 1)
        @age_group_P13 = instance_double(AgeGroup, :name => 'P13', :min_competitors => 1)
        @age_group_T11 = instance_double(AgeGroup, :name => 'T11', :min_competitors => 1)
        @age_group_P11 = instance_double(AgeGroup, :name => 'P11', :min_competitors => 1)
        @age_group_T9 = instance_double(AgeGroup, :name => 'T9', :min_competitors => 1)
        @age_group_P9 = instance_double(AgeGroup, :name => 'P9', :min_competitors => 1)
        expect_ordered_age_groups(@series, [@age_group_T9, @age_group_P9,
                                            @age_group_T13, @age_group_P13, @age_group_T11, @age_group_P11])
      end

      it "should return all age groups as keys and self with younger same gender age groups as values" do
        groups = @series.send(:age_groups_for_comparison_time, @unofficials_rule)
        expect(groups.length).to eq(6)
        expect(groups[@age_group_T13]).to eq([@age_group_T13, @age_group_T11, @age_group_T9])
        expect(groups[@age_group_T11]).to eq([@age_group_T11, @age_group_T9])
        expect(groups[@age_group_T9]).to eq([@age_group_T9])
        expect(groups[@age_group_P13]).to eq([@age_group_P13, @age_group_P11, @age_group_P9])
        expect(groups[@age_group_P11]).to eq([@age_group_P11, @age_group_P9])
        expect(groups[@age_group_P9]).to eq([@age_group_P9])
      end
    end

    context "when children's, women's and men's age groups are mixed" do
      before do
        @series = build(:series, name: 'Mixed one')
        @age_group_S20 = instance_double AgeGroup, name: 'S20', min_competitors: 1, competitors_count: 1, shorter_trip: false
        @age_group_M70 = instance_double AgeGroup, name: 'M70', min_competitors: 1, competitors_count: 1, shorter_trip: false
        @age_group_N70 = instance_double AgeGroup, name: 'N70', min_competitors: 1, competitors_count: 1, shorter_trip: false
        @age_group_N75 = instance_double AgeGroup, name: 'N75', min_competitors: 1, competitors_count: 1, shorter_trip: false
        @age_group_M80 = instance_double AgeGroup, name: 'M80', min_competitors: 1, competitors_count: 1, shorter_trip: false
        @age_group_N80 = instance_double AgeGroup, name: 'N80', min_competitors: 1, competitors_count: 1, shorter_trip: false
        expect_ordered_age_groups(@series, [@age_group_M70, @age_group_M80,
                                            @age_group_N70, @age_group_N75, @age_group_N80, @age_group_S20])
      end

      it 'uses the age group first name as splitting the age groups into groups' do
        groups = @series.send(:age_groups_for_comparison_time, @unofficials_rule)
        expect(groups.length).to eq(7)
        expect(groups[nil]).to eq([@age_group_S20, @age_group_N80, @age_group_N75, @age_group_N70,
                                   @age_group_M80, @age_group_M70, nil])
        expect(groups[@age_group_M70]).to eq([@age_group_M80, @age_group_M70])
        expect(groups[@age_group_M80]).to eq([@age_group_M80])
        expect(groups[@age_group_N70]).to eq([@age_group_N80, @age_group_N75, @age_group_N70])
        expect(groups[@age_group_N75]).to eq([@age_group_N80, @age_group_N75])
        expect(groups[@age_group_N80]).to eq([@age_group_N80])
        expect(groups[@age_group_S20]).to eq([@age_group_S20])
      end
    end

    def expect_ordered_age_groups(series, age_groups)
      tmp_groups = double(Array)
      expect(series).to receive(:age_groups).and_return(tmp_groups)
      expect(tmp_groups).to receive(:except).with(:order).and_return(age_groups)
      expect(age_groups).to receive(:order).with('name desc').and_return(age_groups.reverse)
    end
  end

  describe "#three_sports_results" do
    it "should call Competitor.sort_competitors with all competitors in the series" do
      unofficials_rule = Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME
      series = build(:series)
      competitors, included = ['a', 'b', 'c'], ['d', 'e']
      sorted_competitors = [instance_double(Competitor), instance_double(Competitor), instance_double(Competitor)]
      allow(series).to receive(:competitors).and_return(competitors)
      expect(competitors).to receive(:includes).with([:club, :age_group, :series]).and_return(included)
      expect(Competitor).to receive(:sort_three_sports_competitors).with(included, unofficials_rule).and_return(sorted_competitors)
      sorted_competitors.each_with_index do |c, i|
        expect(c).to receive(:three_sports_race_results).with(unofficials_rule).and_return([i])
        expect(c).to receive(:position=).with(i + 1)
        expect(c).to receive(:position).and_return(i + 1)
      end
      expect(series.three_sports_results(unofficials_rule)).to eq(sorted_competitors)
    end
  end

  describe "#start_list" do
    it "should return empty array when no competitors" do
      expect(build(:series).start_list).to eq([])
    end

    it "should return competitors with start time ordered by start time, then by start number" do
      series = create(:series)
      c1 = create(:competitor, :series => series, :start_time => '02:15', :number => 1)
      c2 = create(:competitor, :series => series, :start_time => '01:00:00', :number => 10)
      c3 = create(:competitor, :series => series, :start_time => '01:00:01', :number => 6)
      c4 = create(:competitor, :series => series, :start_time => '01:00:01', :number => 5)
      create(:competitor, :series => series, :start_time => nil, number: nil)
      expect(series.reload.start_list.map &:id).to eq([c2, c4, c3, c1].map &:id)
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
      @c2.start_time = '01:34:45'
      @c2.arrival_time = '02:34:45'
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
            :start_time => '04:00', :arrival_time => '04:30', :number => 5)
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
        :first_number => 9, :start_time => '2010-08-15 01:00:15')
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
            :start_time => '01:00', :arrival_time => '01:30', :number => 5)
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
          expect(@c1.start_time.strftime('%H:%M:%S')).to eq('01:00:15')
          expect(@c2.start_time.strftime('%H:%M:%S')).to eq('01:01:15')
          expect(@c3.start_time.strftime('%H:%M:%S')).to eq('01:02:15')
        end
      end

      context "with batches" do
        before do
          @race = create(:race, :start_date => '2010-08-15',
            :start_interval_seconds => 30, :batch_interval_seconds => 180,
            :batch_size => 3)
          @series = create(:series, :race => @race,
            :first_number => 1, :start_time => '2010-08-15 01:00:15')
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
            expect(@c1.start_time.strftime('%H:%M:%S')).to eq('01:00:15')
            expect(@c2.start_time.strftime('%H:%M:%S')).to eq('01:00:45')
            expect(@c3.start_time.strftime('%H:%M:%S')).to eq('01:01:15')
            expect(@c4.start_time.strftime('%H:%M:%S')).to eq('01:04:15')
            expect(@c5.start_time.strftime('%H:%M:%S')).to eq('01:04:45')
            expect(@c6.start_time.strftime('%H:%M:%S')).to eq('01:05:15')
          end
        end
        context "when last batch is short" do
          describe "when last batch tail attachment succeeds" do
            it "should generate start times based on batch size, batch interval and time interval and numbers and return true" do
              expect(@series.generate_start_times).to be_truthy
              expect(@series).to be_valid
              @c7.reload
              @c8.reload
              expect(@c7.start_time.strftime('%H:%M:%S')).to eq('01:05:45')
              expect(@c8.start_time.strftime('%H:%M:%S')).to eq('01:06:15')
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
              expect(@c1.start_time.strftime('%H:%M:%S')).to eq('01:00:15')
              expect(@c2.start_time.strftime('%H:%M:%S')).to eq('01:00:45')
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

    context "when series finished" do
      it "should return false" do
        series = Series.new(race: @race, finished: true)
        expect(series).not_to be_active
      end
    end

    context "when race finished" do
      it "should return false" do
        allow(@race).to receive(:finished?).and_return(true)
        series = Series.new(race: @race)
        expect(series).not_to be_active
      end
    end

    context "when series and race not finished" do
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
    let(:race) { build :race, sport_key: sport_key }
    let(:series) { build :series, race: race }

    context 'when three sports race' do
      let(:sport_key) { Sport::SKI }

      context "when no start time" do
        it "should return false" do
          expect(series).not_to be_started
        end
      end

      context "when start time" do
        before do
          series.start_time = '10:00'
        end

        context "and start date time before current time" do
          it "should return true" do
            allow(series).to receive(:start_datetime).and_return(Time.now - 1)
            expect(series).to be_started
          end
        end

        context "and start date time after current time" do
          it "should return false" do
            allow(series).to receive(:start_datetime).and_return(Time.now + 1)
            expect(series).not_to be_started
          end
        end
      end
    end

    context 'when shooting race' do
      let(:sport_key) { Sport::ILMAHIRVI }

      context 'and race start time is in the future' do
        before do
          allow(race).to receive(:start_datetime).and_return(1.minute.from_now)
          series.race = race
        end

        it 'should return false' do
          expect(series).not_to be_started
        end
      end

      context 'and race start time is not in the future' do
        before do
          allow(race).to receive(:start_datetime).and_return(1.minute.ago)
          series.race = race
        end

        it 'should return true' do
          expect(series).to be_started
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
      @series.competitors << build(:competitor, :series => @series, :start_time => '01:45')
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
        @series.points_method = Series::POINTS_METHOD_NO_TIME_4_ESTIMATES
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
          :start_time => '01:00', :number => 5)
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
          :start_time => '01:00', :number => 5)
        c2 = create(:competitor, :series => @series, :start_time => '01:01', :number => 6)
        c3 = create(:competitor, :series => @series, :start_time => '01:02', :number => 7)
        c2.update_column(:number, 4)
        c3.update_column(:start_time, '00:59')
        @series.reload
        @series.update_start_time_and_number
      end

      it "should set the minimum competitor start time as series start time" do
        expect(@series.start_time.strftime('%H:%M')).to eq('00:59')
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
        @c1 = create(:competitor, :series => @series, :start_time => '02:00')
        @c2 = create(:competitor, :series => @series, :start_time => '02:01')
      end

      context "but none of the competitors have neither arrival time, estimates nor shots total" do
        it "should return false" do
          @series.reload
          expect(@series).not_to have_result_for_some_competitor
        end
      end

      context "and some competitor has arrival time" do
        it "should return true" do
          @c1.arrival_time = '02:23:34'
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
          @c2.shooting_score_input = 99
          @c2.save!
          @series.reload
          expect(@series).to have_result_for_some_competitor
        end
      end

      context 'and some competitor has a shot' do
        it 'should return true' do
          @c2.shots = [7]
          @c2.save!
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

  describe '#walking_series?' do
    it 'is false for points methods with time' do
      test_walking_series Series::POINTS_METHOD_TIME_2_ESTIMATES, false
      test_walking_series Series::POINTS_METHOD_TIME_4_ESTIMATES, false
    end

    it 'is true when no time points' do
      test_walking_series Series::POINTS_METHOD_NO_TIME_2_ESTIMATES, true
      test_walking_series Series::POINTS_METHOD_NO_TIME_4_ESTIMATES, true
    end

    it 'is true when all get 300 time points' do
      test_walking_series Series::POINTS_METHOD_300_TIME_2_ESTIMATES, true
    end

    def test_walking_series(points_method, expected)
      expect(build(:series, points_method: points_method).walking_series?).to eql expected
    end
  end
end
