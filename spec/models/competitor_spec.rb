require 'spec_helper'

describe Competitor do
  describe "create" do
    it "should create competitor with valid attrs" do
      create(:competitor)
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:club) }
    it { is_expected.to belong_to(:series) }
    it { is_expected.to belong_to(:age_group) }
    it { is_expected.to have_many(:shots) }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    describe "number" do
      it { is_expected.to allow_value(nil).for(:number) }
      it { is_expected.to validate_numericality_of(:number) }
      it { is_expected.not_to allow_value(23.5).for(:number) }
      it { is_expected.not_to allow_value(0).for(:number) }
      it { is_expected.to allow_value(1).for(:number) }

      describe "uniqueness" do
        before do
          @c = create(:competitor, :number => 5)
        end
        
        it "should require uniqueness for numbers in the same race" do
          series = create(:series, :race => @c.series.race)
          competitor = build(:competitor, :series => series, :number => 6)
          expect(competitor).to be_valid
          competitor.number = 5
          expect(competitor).not_to be_valid
        end
        
        it "should allow updating the competitor" do
          expect(@c).to be_valid
        end
        
        it "should allow same number in another race" do
          race = create(:race)
          series = create(:series)
          expect(build(:competitor, :series => series, :number => 5)).to be_valid
        end
        
        it "should allow two nils for same series" do
          c = create(:competitor, :number => nil)
          expect(build(:competitor, :number => nil, :series => c.series)).
            to be_valid
        end
      end

      context "when series has start list" do
        it "should not be nil" do
          series = build(:series, :has_start_list => true)
          competitor = build(:competitor, :series => series, :number => nil)
          expect(competitor).to have(1).errors_on(:number)
        end
      end
    end

    describe "start_time" do
      it { is_expected.to allow_value(nil).for(:start_time) }

      context "when series has start list" do
        it "should not be nil" do
          series = build(:series, :has_start_list => true)
          competitor = build(:competitor, :series => series, :start_time => nil)
          expect(competitor).to have(1).errors_on(:start_time)
        end
      end
    end

    describe "shots_total_input" do
      it { is_expected.to allow_value(nil).for(:shots_total_input) }
      it { is_expected.not_to allow_value(1.1).for(:shots_total_input) }
      it { is_expected.not_to allow_value(-1).for(:shots_total_input) }
      it { is_expected.to allow_value(100).for(:shots_total_input) }
      it { is_expected.not_to allow_value(101).for(:shots_total_input) }

      it "cannot be given if also individual shots have been defined" do
        comp = build(:competitor, :shots_total_input => 50)
        comp.shots << build(:shot, :competitor => comp, :value => 8)
        comp.shots << build(:shot, :competitor => comp, :value => 8)
        expect(comp).to have(1).errors_on(:base)
      end

      it "can be given if individual shots only with nils" do
        comp = build(:competitor, :shots_total_input => 50)
        comp.shots << build(:shot, :competitor => comp, :value => nil)
        expect(comp).to be_valid
      end
    end
    
    describe "shots" do
      it "should have at maximum ten shots" do
        comp = build(:competitor)
        10.times do
          comp.shots << build(:shot, :competitor => comp, :value => 8)
        end
        expect(comp).to be_valid
        comp.shots << build(:shot, :competitor => comp, :value => 8)
        expect(comp).to have(1).errors_on(:shots)
      end
    end

    describe "estimate1" do
      it { is_expected.to allow_value(nil).for(:estimate1) }
      it { is_expected.not_to allow_value(1.1).for(:estimate1) }
      it { is_expected.not_to allow_value(-1).for(:estimate1) }
      it { is_expected.not_to allow_value(0).for(:estimate1) }
      it { is_expected.to allow_value(1).for(:estimate1) }
    end

    describe "estimate2" do
      it { is_expected.to allow_value(nil).for(:estimate2) }
      it { is_expected.not_to allow_value(1.1).for(:estimate2) }
      it { is_expected.not_to allow_value(-1).for(:estimate2) }
      it { is_expected.not_to allow_value(0).for(:estimate2) }
      it { is_expected.to allow_value(1).for(:estimate2) }
    end

    describe "estimate3" do
      it { is_expected.to allow_value(nil).for(:estimate3) }
      it { is_expected.not_to allow_value(1.1).for(:estimate3) }
      it { is_expected.not_to allow_value(-1).for(:estimate3) }
      it { is_expected.not_to allow_value(0).for(:estimate3) }
      it { is_expected.to allow_value(1).for(:estimate3) }
    end

    describe "estimate4" do
      it { is_expected.to allow_value(nil).for(:estimate4) }
      it { is_expected.not_to allow_value(1.1).for(:estimate4) }
      it { is_expected.not_to allow_value(-1).for(:estimate4) }
      it { is_expected.not_to allow_value(0).for(:estimate4) }
      it { is_expected.to allow_value(1).for(:estimate4) }
    end

    describe "correct_estimate1" do
      it { is_expected.to allow_value(nil).for(:correct_estimate1) }
      it { is_expected.not_to allow_value(1.1).for(:correct_estimate1) }
      it { is_expected.not_to allow_value(-1).for(:correct_estimate1) }
      it { is_expected.not_to allow_value(0).for(:correct_estimate1) }
      it { is_expected.to allow_value(1).for(:correct_estimate1) }
    end

    describe "correct_estimate2" do
      it { is_expected.to allow_value(nil).for(:correct_estimate2) }
      it { is_expected.not_to allow_value(1.1).for(:correct_estimate2) }
      it { is_expected.not_to allow_value(-1).for(:correct_estimate2) }
      it { is_expected.not_to allow_value(0).for(:correct_estimate2) }
      it { is_expected.to allow_value(1).for(:correct_estimate2) }
    end

    describe "correct_estimate3" do
      it { is_expected.to allow_value(nil).for(:correct_estimate3) }
      it { is_expected.not_to allow_value(1.1).for(:correct_estimate3) }
      it { is_expected.not_to allow_value(-1).for(:correct_estimate3) }
      it { is_expected.not_to allow_value(0).for(:correct_estimate3) }
      it { is_expected.to allow_value(1).for(:correct_estimate3) }
    end

    describe "correct_estimate4" do
      it { is_expected.to allow_value(nil).for(:correct_estimate4) }
      it { is_expected.not_to allow_value(1.1).for(:correct_estimate4) }
      it { is_expected.not_to allow_value(-1).for(:correct_estimate4) }
      it { is_expected.not_to allow_value(0).for(:correct_estimate4) }
      it { is_expected.to allow_value(1).for(:correct_estimate4) }
    end

    describe "arrival_time" do
      it { is_expected.to allow_value(nil).for(:arrival_time) }

      it "can be nil even when start time is not nil" do
        expect(build(:competitor, :start_time => '14:00', :arrival_time => nil)).
          to be_valid
      end

      it "should not be before start time" do
        expect(build(:competitor, :start_time => '14:00', :arrival_time => '13:59')).
          to have(1).errors_on(:arrival_time)
      end

      it "should not be same as start time" do
        expect(build(:competitor, :start_time => '14:00', :arrival_time => '14:00')).
          to have(1).errors_on(:arrival_time)
      end

      it "is valid when later than start time" do
        expect(build(:competitor, :start_time => '14:00', :arrival_time => '14:01')).
          to be_valid
      end

      it "cannot be given if no start time" do
        expect(build(:competitor, :start_time => nil, :arrival_time => '13:59')).
          not_to be_valid
      end
    end

    describe "no_result_reason" do
      it { is_expected.to allow_value(nil).for(:no_result_reason) }
      it { is_expected.to allow_value(Competitor::DNS).for(:no_result_reason) }
      it { is_expected.to allow_value(Competitor::DNF).for(:no_result_reason) }
      it { is_expected.to allow_value(Competitor::DQ).for(:no_result_reason) }
      it { is_expected.not_to allow_value('test').for(:no_result_reason) }

      it "converts empty string to nil" do
        comp = build(:competitor, :no_result_reason => '')
        expect(comp).to be_valid
        comp.save!
        expect(comp.no_result_reason).to eq(nil)
      end
    end
    
    describe "names" do
      it "should be unique for same series" do
        c1 = create(:competitor)
        s2 = create(:series, :race => c1.race)
        expect(build(:competitor, :first_name => c1.first_name,
          :last_name => c1.last_name, :series => c1.series)).not_to be_valid
        expect(build(:competitor, :first_name => 'Other first name',
          :last_name => c1.last_name, :series => c1.series)).to be_valid
        expect(build(:competitor, :first_name => c1.first_name,
          :last_name => 'Other last name', :series => c1.series)).to be_valid
        expect(build(:competitor, :first_name => c1.first_name,
          :last_name => c1.last_name, :series => s2)).to be_valid
      end
    end
  end

  describe 'callbacks' do
    describe 'on update' do
      describe 'when series is updated' do
        it 'resets competitors counters on old and new series' do
          race = create :race
          series1 = create :series, race: race
          series2 = create :series, race: race
          competitor1 = create :competitor, series: series1
          create :competitor, series: series2
          expect(series1.competitors_count).to eq(1)
          expect(series2.competitors_count).to eq(1)
          competitor1.series_id = series2.id
          competitor1.save!
          expect(series1.reload.competitors_count).to eq(0)
          expect(series2.reload.competitors_count).to eq(2)
        end
      end

      describe 'when series is not updated' do
        it 'does not reset competitors counters' do
          expect(Series).not_to receive(:reset_counters)
          competitor = create :competitor
          competitor.first_name = 'New name'
          competitor.save!
        end
      end
    end
  end

  describe "race" do
    it "should be the series.race" do
      race = build(:race)
      series = build(:series, :race => race)
      competitor = build(:competitor, :series => series)
      expect(competitor.race).to eq(race)
    end
  end
  
  describe "save" do
    context "when competitor has no start time or number" do
      it "should not save series for nothing" do
        series = create(:series, :start_time => nil, :first_number => nil)
        comp = build(:competitor, :series => series, :start_time => nil, :number => nil)
        expect(comp.series).not_to receive(:update_start_time_and_number)
        comp.save!
      end
    end
    
    context "when competitor has no start time but has number" do
      it "should not save series" do
        series = create(:series, :start_time => nil, :first_number => nil)
        comp = build(:competitor, :series => series, :start_time => nil, :number => 12)
        expect(comp.series).not_to receive(:update_start_time_and_number)
        comp.save!
      end
    end

    context "when competitor has start time but has no number" do
      it "should not save series" do
        series = create(:series, :start_time => nil, :first_number => nil)
        comp = build(:competitor, :series => series, :start_time => '12:00', :number => nil)
        expect(comp.series).not_to receive(:update_start_time_and_number)
        comp.save!
      end
    end
    
    context "when competitor has both start time and number" do
      it "should let series update its start time and first number" do
        series = create(:series, :start_time => nil, :first_number => nil, :has_start_list => true)
        comp = create(:competitor, :series => series, :start_time => '12:35:30', :number => 15)
        expect(comp.series).to receive(:update_start_time_and_number)
        comp.save!
      end
    end

    describe 'result saving' do
      before do
        @competitor = create :competitor, start_time: '00:00:30'
        expect(@competitor.has_result?).to be_falsey
      end

      context 'when arrival_time is saved' do
        it 'marks has_result true' do
          @competitor.arrival_time = '00:25:00'
          @competitor.save!
          expect(@competitor.has_result?).to be_truthy
        end
      end

      context 'when estimate1 is saved' do
        it 'marks has_result true' do
          @competitor.estimate1 = 100
          @competitor.save!
          expect(@competitor.has_result?).to be_truthy
        end
      end

      context 'when shots_total_input is saved' do
        it 'marks has_result true' do
          @competitor.shots_total_input = 88
          @competitor.save!
          expect(@competitor.has_result?).to be_truthy
        end
      end
    end
  end
  
  describe "concurrency check" do
    context "on create" do
      it "should do nothing" do
        @competitor = build(:competitor)
        expect(@competitor).not_to receive(:values_equal?)
        @competitor.save!
      end
    end
    
    context "on update" do
      before do
        @competitor = create(:competitor)
      end
    
      it "should pass if old and current values equal" do
        expect(@competitor).to receive(:values_equal?).and_return(true)
        @competitor.save
        expect(@competitor.errors.size).to eq(0)
      end
      
      it "should fail if old and current values differ" do
        expect(@competitor).to receive(:values_equal?).and_return(false)
        expect(@competitor).to have(1).errors_on(:base)
      end
    end
  end

  describe "#sort_competitors" do
    describe 'without unofficial competitors' do
      before do
        @all_competitors = false
        @sort_by = 'some-sort-order'
      end

      it 'should sort by relative points and number' do
        competitor1 = create_competitor_with_relative_points 100, 30
        competitor2 = create_competitor_with_relative_points 99, 4
        competitor3 = create_competitor_with_relative_points 98, 99
        competitor0_1 = create_competitor_with_relative_points 0, 15
        competitor0_2 = create_competitor_with_relative_points 0, 16
        competitors = [competitor0_2, competitor3, competitor1, competitor2, competitor0_1]
        expect(Competitor.sort_competitors(competitors, @all_competitors, @sort_by))
            .to eq([competitor1, competitor2, competitor3, competitor0_1, competitor0_2])
      end
    end

    describe 'with unofficial competitors' do
      before do
        @all_competitors = true
        @sort_by = 'another-sort-order'
      end

      it 'should sort by relative points and number' do
        competitor1 = create_competitor_with_relative_points 100, 30
        competitor2 = create_competitor_with_relative_points 99, 4
        competitors = [competitor1, competitor2]
        expect(Competitor.sort_competitors(competitors, @all_competitors, @sort_by))
            .to eq([competitor1, competitor2])
      end
    end

    def create_competitor_with_relative_points(relative_points, number)
      competitor = build :competitor, number: number
      allow(competitor).to receive(:relative_points).with(@all_competitors, @sort_by).and_return(relative_points)
      competitor
    end
  end

  describe "#shots_sum" do
    it "should return nil when total input is nil and no shots" do
      expect(build(:competitor).shots_sum).to be_nil
    end

    it "should be shots_total_input when it is given" do
      expect(build(:competitor, :shots_total_input => 55).shots_sum).to eq(55)
    end

    it "should be sum of defined individual shots if no input sum" do
      comp = build(:competitor, :shots_total_input => nil)
      comp.shots << build(:shot, :value => 8, :competitor => comp)
      comp.shots << build(:shot, :value => 9, :competitor => comp)
      comp.shots << build(:shot, :value => nil, :competitor => comp)
      expect(comp.shots_sum).to eq(17)
    end
  end

  describe "#shot_points" do
    it "should be nil if shots not defined" do
      competitor = build(:competitor)
      expect(competitor).to receive(:shots_sum).and_return(nil)
      expect(competitor.shot_points).to be_nil
    end

    it "should be 6 times shots_sum" do
      competitor = build(:competitor)
      expect(competitor).to receive(:shots_sum).and_return(50)
      expect(competitor.shot_points).to eq(300)
    end
  end

  describe "#estimate_diff1_m" do
    it "should be nil when no correct estimate1" do
      expect(build(:competitor, :estimate1 => 100, :correct_estimate1 => nil).
        estimate_diff1_m).to be_nil
    end

    it "should be nil when no estimate1" do
      expect(build(:competitor, :estimate1 => nil, :correct_estimate1 => 100).
        estimate_diff1_m).to be_nil
    end

    it "should be positive diff when estimate1 is more than correct" do
      expect(build(:competitor, :estimate1 => 105, :correct_estimate1 => 100).
        estimate_diff1_m).to eq(5)
    end

    it "should be negative diff when estimate1 is less than correct" do
      expect(build(:competitor, :estimate1 => 91, :correct_estimate1 => 100).
        estimate_diff1_m).to eq(-9)
    end
  end

  describe "#estimate_diff2_m" do
    it "should be nil when no correct estimate2" do
      expect(build(:competitor, :estimate2 => 100, :correct_estimate2 => nil).
        estimate_diff2_m).to be_nil
    end

    it "should be nil when no estimate2" do
      expect(build(:competitor, :estimate2 => nil, :correct_estimate2 => 200).
        estimate_diff2_m).to be_nil
    end

    it "should be positive diff when estimate2 is more than correct" do
      expect(build(:competitor, :estimate2 => 205, :correct_estimate2 => 200).
        estimate_diff2_m).to eq(5)
    end

    it "should be negative diff when estimate2 is less than correct" do
      expect(build(:competitor, :estimate2 => 191, :correct_estimate2 => 200).
        estimate_diff2_m).to eq(-9)
    end
  end

  describe "#estimate_diff3_m" do
    it "should be nil when no correct estimate3" do
      expect(build(:competitor, :estimate3 => 100, :correct_estimate3 => nil).
        estimate_diff3_m).to be_nil
    end

    it "should be nil when no estimate3" do
      expect(build(:competitor, :estimate3 => nil, :correct_estimate3 => 100).
        estimate_diff3_m).to be_nil
    end

    it "should be positive diff when estimate3 is more than correct" do
      expect(build(:competitor, :estimate3 => 105, :correct_estimate3 => 100).
        estimate_diff3_m).to eq(5)
    end

    it "should be negative diff when estimate3 is less than correct" do
      expect(build(:competitor, :estimate3 => 91, :correct_estimate3 => 100).
        estimate_diff3_m).to eq(-9)
    end
  end

  describe "#estimate_diff4_m" do
    it "should be nil when no correct estimate4" do
      expect(build(:competitor, :estimate4 => 100, :correct_estimate4 => nil).
        estimate_diff4_m).to be_nil
    end

    it "should be nil when no estimate4" do
      expect(build(:competitor, :estimate4 => nil, :correct_estimate4 => 200).
        estimate_diff4_m).to be_nil
    end

    it "should be positive diff when estimate4 is more than correct" do
      expect(build(:competitor, :estimate4 => 205, :correct_estimate4 => 200).
        estimate_diff4_m).to eq(5)
    end

    it "should be negative diff when estimate4 is less than correct" do
      expect(build(:competitor, :estimate4 => 191, :correct_estimate4 => 200).
        estimate_diff4_m).to eq(-9)
    end
  end

  describe "#estimate_points" do
    describe "estimate missing" do
      it "should be nil if estimate1 is missing" do
        competitor = build(:competitor,
          :estimate1 => nil, :estimate2 => 145,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to be_nil
      end

      it "should be nil if estimate2 is missing" do
        competitor = build(:competitor,
          :estimate1 => 156, :estimate2 => nil,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to be_nil
      end

      context "when 4 estimates for the series" do
        before do
          @series = build(:series, :estimates => 4)
        end

        it "should be nil if estimate3 is missing" do
          competitor = build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 145,
            :estimate3 => nil, :estimate4 => 150,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 100, :correct_estimate4 => 200)
          expect(competitor.estimate_points).to be_nil
        end

        it "should be nil if estimate4 is missing" do
          competitor = build(:competitor, :series => @series,
            :estimate1 => 156, :estimate2 => 100,
            :estimate3 => 150, :estimate4 => nil,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 100, :correct_estimate4 => 200)
          expect(competitor.estimate_points).to be_nil
        end
      end
    end

    describe "correct estimate missing" do
      it "should be nil if correct estimate 1 is missing" do
        competitor = build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => nil, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to be_nil
      end

      it "should be nil if correct estimate 2 is missing" do
        competitor = build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => nil)
        expect(competitor.estimate_points).to be_nil
      end

      context "when 4 estimates for the series" do
        before do
          @series = build(:series, :estimates => 4)
        end

        it "should be nil if correct estimate 3 is missing" do
          competitor = build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 200,
            :estimate3 => 100, :estimate4 => 200,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => nil, :correct_estimate4 => 200)
          expect(competitor.estimate_points).to be_nil
        end

        it "should be nil if correct estimate 4 is missing" do
          competitor = build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 200,
            :estimate3 => 100, :estimate4 => 200,
            :correct_estimate1 => 100, :correct_estimate2 => 150,
            :correct_estimate3 => 100, :correct_estimate4 => nil)
          expect(competitor.estimate_points).to be_nil
        end
      end
    end

    describe "no estimates nor correct estimates missing" do
      it "should be 300 when perfect estimates" do
        competitor = build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(300)
      end

      it "should be 298 when the first is 1 meter too low" do
        competitor = build(:competitor,
          :estimate1 => 99, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(298)
      end

      it "should be 298 when the second is 1 meter too low" do
        competitor = build(:competitor,
          :estimate1 => 100, :estimate2 => 199,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(298)
      end

      it "should be 298 when the first is 1 meter too high" do
        competitor = build(:competitor,
          :estimate1 => 101, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(298)
      end

      it "should be 298 when the second is 1 meter too high" do
        competitor = build(:competitor,
          :estimate1 => 100, :estimate2 => 201,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(298)
      end

      it "should be 296 when both have 1 meter difference" do
        competitor = build(:competitor,
          :estimate1 => 99, :estimate2 => 201,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(296)
      end

      it "should never be negative" do
        competitor = build(:competitor,
          :estimate1 => 111111, :estimate2 => 222222,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        expect(competitor.estimate_points).to eq(0)
      end
      
      context "when 4 estimates for the series" do
        before do
          @series = build(:series, :estimates => 4)
        end
        
        it "should be 600 when perfect estimates" do
          competitor = build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 200,
            :estimate3 => 80, :estimate4 => 140,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 80, :correct_estimate4 => 140)
          expect(competitor.estimate_points).to eq(600)
        end

        it "should be 584 when each estimate is 2 meters wrong" do
          competitor = build(:competitor, :series => @series,
            :estimate1 => 98, :estimate2 => 202,
            :estimate3 => 108, :estimate4 => 152,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 110, :correct_estimate4 => 150)
          expect(competitor.estimate_points).to eq(584) # 600 - 4*4
        end
      end
    end
  end

  describe "#time_in_seconds" do
    it "should be nil when start time not known yet" do
      expect(build(:competitor, :start_time => nil).time_in_seconds).to be_nil
    end

    it "should be nil when arrival time is not known yet" do
      expect(build(:competitor, :start_time => '14:00', :arrival_time => nil).
        time_in_seconds).to be_nil
    end

    it "should be difference of arrival and start times" do
      expect(build(:competitor, :start_time => '13:58:02', :arrival_time => '15:02:04').
        time_in_seconds).to eq(64 * 60 + 2)
    end
  end

  describe "#time_points" do
    before do
      @all_competitors = true
      @series = build(:series)
      @competitor = build(:competitor, :series => @series)
      @best_time_seconds = 3603.0 # rounded: 3600
      allow(@competitor).to receive(:comparison_time_in_seconds).with(@all_competitors).and_return(@best_time_seconds)
    end

    it "should be nil when time cannot be calculated yet" do
      expect(@competitor).to receive(:time_in_seconds).and_return(nil)
      expect(@competitor.time_points(@all_competitors)).to eq(nil)
    end

    it "should be nil when competitor has time but best time cannot be calculated" do
      # this happens if competitor has time but did not finish (no_result_reason=DNF)
      # and no-one else has result either
      expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds)
      expect(@competitor).to receive(:comparison_time_in_seconds).with(@all_competitors).and_return(nil)
      expect(@competitor.time_points(@all_competitors)).to eq(nil)
    end

    context "when the competitor has the best time" do
      it "should be 300" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds)
        expect(@competitor.time_points(@all_competitors)).to eq(300)
      end
    end

    context "when the competitor has worse time which is rounded down to 10 secs" do
      it "should be 300 when the rounded time is the same as the best time rounded" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 6)
        expect(@competitor.time_points(@all_competitors)).to eq(300)
      end

      it "should be 299 when the rounded time is 10 seconds worse than the best time" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 7)
        expect(@competitor.time_points(@all_competitors)).to eq(299)
      end

      it "should be 299 when the rounded time is still 10 seconds worse" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 16)
        expect(@competitor.time_points(@all_competitors)).to eq(299)
      end

      it "should be 298 when the rounded time is 20 seconds worse" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 17)
        expect(@competitor.time_points(@all_competitors)).to eq(298)
      end
    end
    
    context "when the competitor is an unofficial competitor and has better time than official best time" do
      it "should be 300" do
        @competitor.unofficial = true
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds - 60)
        expect(@competitor.time_points(@all_competitors)).to eq(300)
      end
    end

    it "should never be negative" do
      expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 100000)
      expect(@competitor.time_points(@all_competitors)).to eq(0)
    end

    context "when no time points" do
      it "should be nil" do
        @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_NONE
        allow(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds)
        expect(@competitor.time_points(@all_competitors)).to be_nil
      end
    end

    context "when 300 time points for all competitors in the series" do
      it "should be 300" do
        @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_ALL_300
        allow(@competitor).to receive(:time_in_seconds).and_return(nil)
        expect(@competitor.time_points(@all_competitors)).to eq(300)
      end
    end

    context "no result" do
      before do
        @competitor = build(:competitor, :series => @series,
          :no_result_reason => Competitor::DNF)
        @best_time_seconds = 3603.0
        allow(@competitor).to receive(:comparison_time_in_seconds).with(@all_competitors).and_return(@best_time_seconds)
      end

      it "should be like normally when the competitor has not the best time" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 20)
        expect(@competitor.time_points(@all_competitors)).to eq(298)
      end

      it "should be nil when competitor's time is better than the best time" do
        # note: when no result, the time really can be better than the best time
        # since such a competitor's time cannot be the best time
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds - 1)
        expect(@competitor.time_points(@all_competitors)).to be_nil
      end
    end
  end

  describe "#points" do
    before do
      @all_competitors = true
      @competitor = build(:competitor)
      allow(@competitor).to receive(:shot_points).and_return(100)
      allow(@competitor).to receive(:estimate_points).and_return(150)
      allow(@competitor).to receive(:time_points).with(@all_competitors).and_return(200)
    end

    it "should consider missing shot points as 0" do
      expect(@competitor).to receive(:shot_points).and_return(nil)
      expect(@competitor.points(@all_competitors)).to eq(150 + 200)
    end

    it "should consider missing estimate points as 0" do
      expect(@competitor).to receive(:estimate_points).and_return(nil)
      expect(@competitor.points(@all_competitors)).to eq(100 + 200)
    end

    it "should consider missing time points as 0" do
      expect(@competitor).to receive(:time_points).with(@all_competitors).and_return(nil)
      expect(@competitor.points(@all_competitors)).to eq(100 + 150)
    end

    it "should be sum of sub points when all of them are available" do
      expect(@competitor.points(@all_competitors)).to eq(100 + 150 + 200)
    end
  end

  describe "#shot_values" do
    it "should return an ordered array of 10 shots" do
      c = build(:competitor)
      c.shots << build(:shot, :value => 10, :competitor => c)
      c.shots << build(:shot, :value => 3, :competitor => c)
      c.shots << build(:shot, :value => 4, :competitor => c)
      c.shots << build(:shot, :value => 9, :competitor => c)
      c.shots << build(:shot, :value => 1, :competitor => c)
      c.shots << build(:shot, :value => 0, :competitor => c)
      c.shots << build(:shot, :value => 9, :competitor => c)
      c.shots << build(:shot, :value => 7, :competitor => c)
      expect(c.shot_values).to eq([10,9,9,7,4,3,1,0,nil,nil])
    end
  end

  describe "#next_competitor" do
    before do
      @series = create(:series)
      @c = create(:competitor, :series => @series, :number => 15)
      create(:competitor) # another series
    end

    it "should return itself when no other competitors" do
      expect(@c.next_competitor).to eq(@c)
    end

    context "other competitors" do
      before do
        @first = create(:competitor, :series => @series, :number => 10)
        @nil = create(:competitor, :series => @series, :number => nil)
        @prev = create(:competitor, :series => @series, :number => 12)
        @next = create(:competitor, :series => @series, :number => 17)
        @last = create(:competitor, :series => @series, :number => 20)
        @series.reload
      end

      it "should return the competitor with next biggest number when such exists" do
        expect(@c.next_competitor).to eq(@next)
      end

      it "should return the competitor with smallest number when no bigger numbers" do
        expect(@last.next_competitor).to eq(@first)
      end

      it "should return the next by id if competitor has no number" do
        expect(@nil.next_competitor).to eq(@prev)
      end
    end
  end

  describe "#previous_competitor" do
    before do
      @series = create(:series)
      @c = create(:competitor, :series => @series, :number => 15)
      create(:competitor) # another series
    end

    it "should return itself when no other competitors" do
      expect(@c.previous_competitor).to eq(@c)
    end

    context "other competitors" do
      before do
        @first = create(:competitor, :series => @series, :number => 10)
        @nil = create(:competitor, :series => @series, :number => nil)
        @prev = create(:competitor, :series => @series, :number => 12)
        @next = create(:competitor, :series => @series, :number => 17)
        @last = create(:competitor, :series => @series, :number => 20)
        @series.reload
      end

      it "should return the competitor with next smallest number when such exists" do
        expect(@c.previous_competitor).to eq(@prev)
      end

      it "should return the competitor with biggest number when no smaller numbers" do
        expect(@first.previous_competitor).to eq(@last)
      end

      it "should return the previous by id if competitor has no number" do
        expect(@nil.previous_competitor).to eq(@first)
      end
    end
  end

  describe "#finished?" do
    context "when competitor has some 'no result reason'" do
      it "should return true" do
        c = build(:competitor, :no_result_reason => Competitor::DNS)
        expect(c).to be_finished
      end
    end

    context "when competitor has no 'no result reason'" do
      before do
        # no need to have correct estimate
        series = build(:series)
        @competitor = build(:competitor, :no_result_reason => nil,
          :series => series)
        @competitor.start_time = '11:10'
        @competitor.arrival_time = '11:20'
        @competitor.shots_total_input = 90
        @competitor.estimate1 = 100
        @competitor.estimate2 = 110
      end

      context "when competitor has shots and arrival time" do
        context "when competitor has both estimates" do
          it "should return true" do
            expect(@competitor).to be_finished
          end
        end

        context "when either estimate is missing" do
          it "should return false" do
            @competitor.estimate2 = nil
            expect(@competitor).not_to be_finished
            @competitor.estimate1 = nil
            @competitor.estimate2 = 110
            expect(@competitor).not_to be_finished
          end
        end

        context "when 4 estimates for the series" do
          before do
            @competitor.series.estimates = 4
          end

          context "when 3rd estimate is missing" do
            it "should return false" do
              @competitor.estimate3 = nil
              @competitor.estimate4 = 110
              expect(@competitor).not_to be_finished
            end
          end

          context "when 4th estimate is missing" do
            it "should return false" do
              @competitor.estimate3 = 110
              @competitor.estimate4 = nil
              expect(@competitor).not_to be_finished
            end
          end
        end
      end

      context "when shots result is missing" do
        it "should return false" do
          @competitor.shots_total_input = nil
          expect(@competitor).not_to be_finished
        end
      end

      context "when time result is missing" do
        it "should return false" do
          @competitor.arrival_time = nil
          expect(@competitor).not_to be_finished
        end
      end

      context "when series does not calculate time points and other results are there" do
        it "should return true" do
          @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_NONE
          @competitor.arrival_time = nil
          expect(@competitor).to be_finished
        end
      end

      context "when series gives 300 time points for all and other results are there" do
        it "should return true" do
          @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_ALL_300
          @competitor.arrival_time = nil
          expect(@competitor).to be_finished
        end
      end
    end
  end

  describe "#comparison_time_in_seconds" do
    it "should delegate call to series with own age group and all_competitors as parameters" do
      all_competitors = true
      series = build :series
      age_group = build :age_group
      competitor = build(:competitor, :series => series, :age_group => age_group)
      expect(series).to receive(:comparison_time_in_seconds).with(age_group, all_competitors).and_return(12345)
      expect(competitor.comparison_time_in_seconds(all_competitors)).to eq(12345)
    end
  end

  describe "#reset_correct_estimates" do
    it "should set all correct estimates to nil" do
      c = build(:competitor, :correct_estimate1 => 100,
        :correct_estimate2 => 110, :correct_estimate3 => 130,
        :correct_estimate4 => 140)
      c.reset_correct_estimates
      expect(c.correct_estimate1).to be_nil
      expect(c.correct_estimate2).to be_nil
      expect(c.correct_estimate3).to be_nil
      expect(c.correct_estimate4).to be_nil
    end
  end

  describe "#free_offline_competitors_left" do
    context "when online state" do
      it "should raise error" do
        allow(Mode).to receive(:online?).and_return(true)
        allow(Mode).to receive(:offline?).and_return(false)
        expect { Competitor.free_offline_competitors_left }.to raise_error
      end
    end

    context "when offline state" do
      before do
        allow(Mode).to receive(:online?).and_return(false)
        allow(Mode).to receive(:offline?).and_return(true)
      end

      it "should return full amount initially" do
        expect(Competitor.free_offline_competitors_left).to eq(
          Competitor::MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE
        )
      end

      it "should recude added competitors from the full amount" do
        create(:competitor)
        create(:competitor)
        expect(Competitor.free_offline_competitors_left).to eq(
          Competitor::MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE - 2
        )
      end

      it "should be zero when would actually be negative (for some reason)" do
        allow(Competitor).to receive(:count).and_return(Competitor::MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE + 1)
        expect(Competitor.free_offline_competitors_left).to eq(0)
      end
    end
  end

  describe "create with number" do
    before do
      @race = create(:race)
      series = create(:series, :race => @race)
      @competitor = build(:competitor, :series => series, :number => 10)
    end

    context "when no correct estimates defined for this number" do
      it "should leave correct estimates as nil" do
        @competitor.save!
        verify_correct_estimates nil, nil, nil, nil
      end
    end

    context "when correct estimates defined for this number" do
      before do
        @race.correct_estimates << build(:correct_estimate, :race => @race,
          :min_number => 9, :distance1 => 101, :distance2 => 102,
          :distance3 => 103, :distance4 => 104)
      end

      it "should set the correct estimates for the competitor" do
        @competitor.number = 11
        @competitor.save!
        verify_correct_estimates 101, 102, 103, 104
      end
    end

    def verify_correct_estimates(ce1, ce2, ce3, ce4)
      @competitor.reload
      expect(@competitor.correct_estimate1).to eq(ce1)
      expect(@competitor.correct_estimate2).to eq(ce2)
      expect(@competitor.correct_estimate3).to eq(ce3)
      expect(@competitor.correct_estimate4).to eq(ce4)
    end
  end
  
  describe "#relative_points" do
    before do
      @dq = create_competitor(1200, 600, 60*1, Competitor::DQ)
      @dns = create_competitor(1200, 600, 60*1, Competitor::DNS)
      @dnf = create_competitor(1200, 600, 60*1, Competitor::DNF)
      @unofficial_1 = create_competitor(1200, 600, 60*5, nil, true)
      @unofficial_2 = create_competitor(1199, 600, 60*5, nil, true)
      @unofficial_3 = create_competitor(1199, 599, 60*5-2, nil, true)
      @unofficial_4 = create_competitor(1199, 599, 60*5-1, nil, true)
      @no_result = create_competitor(nil, nil, nil)
      @points_1 = create_competitor(1100, 500, 60*20)
      @points_2_shots_1 = create_competitor(1000, 600, 60*20)
      @points_2_shots_2 = create_competitor(1000, 594, 60*20)
      @points_3_time_1 = create_competitor(900, 600, 60*15-1)
      @points_3_time_2 = create_competitor(900, 600, 60*15)
      @competitors_in_random_order = [@unofficial_1, @points_3_time_1, @dns, @points_1, @unofficial_4,
                                      @unofficial_3, @unofficial_2, @dq, @points_2_shots_1, @no_result,
                                      @points_3_time_2, @points_2_shots_2, @dnf]
    end

    it 'should rank best points, best shots points, best time, unofficials, DNF, DNS, DQ' do
      expected_order = [@dq, @dns, @dnf, @no_result, @unofficial_4, @unofficial_3, @unofficial_2, @unofficial_1,
                      @points_3_time_2, @points_3_time_1, @points_2_shots_2, @points_2_shots_1, @points_1]
      expect_relative_points_order @competitors_in_random_order, expected_order
    end

    it 'should rank unofficial competitors among others when all competitors wanted' do
      expected_order = [@dq, @dns, @dnf, @no_result, @points_3_time_2, @points_3_time_1, @points_2_shots_2,
                        @points_2_shots_1, @points_1, @unofficial_4, @unofficial_3, @unofficial_2, @unofficial_1]
      expect_relative_points_order @competitors_in_random_order, expected_order, true
    end

    describe 'by shots' do
      before do
        @sort_by = Competitor::SORT_BY_SHOTS
      end

      it 'returns shot points for competitors with result' do
        @competitors_in_random_order.each do |competitor|
          unless competitor.no_result_reason
            expect(competitor.relative_points(false, @sort_by)).to eq(competitor.shot_points.to_i)
            expect(competitor.relative_points(true, @sort_by)).to eq(competitor.shot_points.to_i)
          end
        end
      end

      it 'handles DNF, DNS, DQ as usual' do
        some_competitors = [@dns, @unofficial_3, @no_result, @dq, @dnf, @points_2_shots_2]
        expected_order = [@dq, @dns, @dnf, @no_result, @points_2_shots_2, @unofficial_3]
        expect_relative_points_order some_competitors, expected_order, false, @sort_by
        expect_relative_points_order some_competitors, expected_order, true, @sort_by
      end
    end

    describe 'by estimates' do
      before do
        @sort_by = Competitor::SORT_BY_ESTIMATES
      end

      it 'returns estimate points for competitors with result' do
        @competitors_in_random_order.each do |competitor|
          unless competitor.no_result_reason
            expect(competitor.relative_points(false, @sort_by)).to eq(competitor.estimate_points.to_i)
            expect(competitor.relative_points(true, @sort_by)).to eq(competitor.estimate_points.to_i)
          end
        end
      end

      it 'handles DNF, DNS, DQ as usual' do
        some_competitors = [@dns, @no_result, @dq, @dnf, @points_2_shots_2]
        expected_order = [@dq, @dns, @dnf, @no_result, @points_2_shots_2]
        expect_relative_points_order some_competitors, expected_order, false, @sort_by
      end
    end

    describe 'by time' do
      before do
        @sort_by = Competitor::SORT_BY_TIME
      end

      it 'returns negative time in seconds for competitors with result' do
        @competitors_in_random_order.each do |competitor|
          unless competitor.no_result_reason || competitor.time_in_seconds.nil?
            expect(competitor.relative_points(false, @sort_by)).to eq(-competitor.time_in_seconds.to_i)
            expect(competitor.relative_points(true, @sort_by)).to eq(-competitor.time_in_seconds.to_i)
          end
        end
      end

      it 'handles DNF, DNS, DQ as usual; does not set nil time to the top' do
        some_competitors = [@no_result, @dns, @points_3_time_1, @dq, @dnf, @points_3_time_2]
        expected_order = [@dq, @dns, @dnf, @no_result, @points_3_time_2, @points_3_time_1]
        expect_relative_points_order some_competitors, expected_order, false, @sort_by
        expect_relative_points_order some_competitors, expected_order, true, @sort_by
      end
    end

    def create_competitor(points, shot_points, time_in_seconds, no_result_reason=nil, unofficial=false)
      competitor = build :competitor
      allow(competitor).to receive(:no_result_reason).and_return(no_result_reason)
      allow(competitor).to receive(:points).and_return(points)
      allow(competitor).to receive(:shot_points).and_return(shot_points)
      allow(competitor).to receive(:time_in_seconds).and_return(time_in_seconds)
      allow(competitor).to receive(:unofficial?).and_return(unofficial)
      allow(competitor).to receive(:estimate_points).and_return(550)
      competitor
    end

    def expect_relative_points_order(competitors, expected_order, all_competitors=false, sort_by=nil)
      expect(competitors.map {|c|c.relative_points(all_competitors, sort_by)}.sort)
          .to eq(expected_order.map {|c|c.relative_points(all_competitors, sort_by)})
    end
  end

  describe '#relative_shot_points' do
    context 'when no shots' do
      it 'returns 0' do
        expect(build(:competitor).relative_shot_points).to eq 0
      end
    end

    context 'when shots' do
      it 'multiplies each shot by its value' do
        competitor = create :competitor
        create :shot, competitor: competitor, value: 10
        create :shot, competitor: competitor, value: 10
        create :shot, competitor: competitor, value: 8
        create :shot, competitor: competitor, value: 7
        create :shot, competitor: competitor, value: 3
        create :shot, competitor: competitor, value: 3
        expect(competitor.reload.relative_shot_points).to eq(2*10*10 + 8*8 + 7*7 + 2*3*3)
      end
    end
  end

  describe "#start_datetime" do
    it "should return value from StartDateTime module" do
      race = build :race
      series = build(:series, race: race, start_day: 2)
      competitor = build(:competitor, series: series)
      expect(competitor).to receive(:start_date_time).with(race, 2, competitor.start_time).and_return('time')
      expect(competitor.start_datetime).to eq('time')
    end
  end
end
