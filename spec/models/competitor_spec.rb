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
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it_should_behave_like 'non-negative integer', :shooting_overtime_min

    describe "number" do
      it_should_behave_like 'non-negative integer', :number
      it { is_expected.to allow_value(nil).for(:number) }

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

      it 'has to be less than 07:00' do
        expect(build :competitor, start_time: '06:59:59').to be_valid
      end

      it 'cannot be 07:00:00' do
        expect(build :competitor, start_time: '07:00:00').to have(1).errors_on(:start_time)
      end

      it 'cannot be 07:00:01' do
        expect(build :competitor, start_time: '07:00:01').to have(1).errors_on(:start_time)
      end

      context "when series has start list" do
        it "should not be nil" do
          series = build(:series, :has_start_list => true)
          competitor = build(:competitor, :series => series, :start_time => nil)
          expect(competitor).to have(1).errors_on(:start_time)
        end
      end
    end

    describe "shooting_score_input" do
      it { is_expected.to allow_value(nil).for(:shooting_score_input) }
      it { is_expected.not_to allow_value(1.1).for(:shooting_score_input) }
      it { is_expected.not_to allow_value(-1).for(:shooting_score_input) }
      it { is_expected.to allow_value(100).for(:shooting_score_input) }
      it { is_expected.not_to allow_value(101).for(:shooting_score_input) }

      it "cannot be given if also individual shots have been defined" do
        comp = build(:competitor, shooting_score_input: 50, shots: [8])
        expect(comp).to have(1).errors_on(:base)
      end

      it "can be given if individual shots only with nils" do
        comp = build(:competitor, :shooting_score_input => 50)
        expect(comp).to be_valid
      end
    end

    describe 'shots' do
      it { is_expected.to allow_value(nil).for('shots') }
      it { is_expected.not_to allow_value([10, -1, 0]).for('shots') }
      it { is_expected.not_to allow_value([11, 10]).for('shots') }
      it { is_expected.not_to allow_value([10, 9, 1.1]).for('shots') }
      it { is_expected.to allow_value([10, 9, 8, 7, 6, 5, 4, 3, 2, 0]).for('shots') }
      it { is_expected.to allow_value(['10', '9', '0']).for('shots') }
      it { is_expected.not_to allow_value(['10', '9', '1.1']).for('shots') }

      describe 'when only shooting' do
        it 'can have at most 20 shots' do
          competitor = build :competitor, shots: [9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
          allow(competitor).to receive(:sport).and_return(Sport.by_key(Sport::ILMAHIRVI))
          expect(competitor).to have(0).errors_on(:shots)
          competitor.shots << 5
          expect(competitor).to have(1).errors_on(:shots)
        end
      end

      describe 'when 3 sports race' do
        it 'can have at most 10 shots' do
          competitor = build :competitor, shots: [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
          allow(competitor).to receive(:sport).and_return(Sport.by_key(Sport::RUN))
          expect(competitor).to have(0).errors_on(:shots)
          competitor.shots << 9
          expect(competitor).to have(1).errors_on(:shots)
        end
      end

      describe 'when special setting for max shot value' do
        it 'max shot value comes from the setting' do
          sport = double Sport, max_shot: 15, only_shooting?: false, max_shots_count: 10
          competitor = build :competitor, shots: [15, 14]
          allow(competitor).to receive(:sport).and_return(sport)
          expect(competitor).to have(0).errors_on(:shots)
          competitor.shots = [16, 15]
          expect(competitor).to have(1).errors_on(:shots)
        end
      end
    end

    describe 'extra_shots' do
      it { is_expected.to allow_value(nil).for('extra_shots') }
      it { is_expected.not_to allow_value([10, -1, 0]).for('extra_shots') }
      it { is_expected.not_to allow_value([11, 10]).for('extra_shots') }
      it { is_expected.not_to allow_value([10, 9, 1.1]).for('extra_shots') }
      it { is_expected.to allow_value([10, 9, 8, 7, 6, 5, 4, 3, 2, 0]).for('extra_shots') }
      it { is_expected.to allow_value(['10', '9', '0']).for('extra_shots') }
      it { is_expected.not_to allow_value(['10', '9', '1.1']).for('extra_shots') }

      describe 'when special setting for max shot value' do
        it 'max shot value comes from the setting' do
          sport = double Sport, max_shot: 15, only_shooting?: false
          competitor = build :competitor, extra_shots: [15, 14]
          allow(competitor).to receive(:sport).and_return(sport)
          expect(competitor).to have(0).errors_on(:extra_shots)
          competitor.extra_shots = [16, 15]
          expect(competitor).to have(1).errors_on(:extra_shots)
        end
      end
    end

    it_should_behave_like 'positive integer', :estimate1, true
    it_should_behave_like 'positive integer', :estimate2, true
    it_should_behave_like 'positive integer', :estimate3, true
    it_should_behave_like 'positive integer', :estimate4, true
    it_should_behave_like 'positive integer', :correct_estimate1, true
    it_should_behave_like 'positive integer', :correct_estimate2, true
    it_should_behave_like 'positive integer', :correct_estimate3, true
    it_should_behave_like 'positive integer', :correct_estimate4, true

    describe 'shooting_start_time' do
      it 'can be nil' do
        test_shooting_start_time nil, nil, true
        test_shooting_start_time '00:04:00', nil, true
      end

      it 'should not be before start time' do
        test_shooting_start_time '00:04:00', '00:03:59', false
      end

      it 'should not be same as start time' do
        test_shooting_start_time '00:04:00', '00:04:00', false
      end

      it 'is valid when later than start time' do
        test_shooting_start_time '00:04:00', '00:04:01', true
      end

      it 'cannot be given if no start time' do
        test_shooting_start_time nil, '00:04:00', false
      end

      def test_shooting_start_time(start_time, shooting_start_time, valid)
        competitor = build :competitor, start_time: start_time, shooting_start_time: shooting_start_time
        if valid
          expect(competitor).to be_valid
        else
          expect(competitor).not_to be_valid
          expect(competitor).to have(1).errors_on(:shooting_start_time)
        end
      end
    end

    describe 'shooting_finish_time' do
      it 'can be nil' do
        test_shooting_finish_time nil, nil, nil, true
        test_shooting_finish_time '00:04:00', '00:05:00', nil, true
        test_shooting_finish_time '00:04:00', nil, nil, true
      end

      it 'should not be before start time' do
        test_shooting_finish_time '00:04:00', nil, '00:03:59', false
      end

      it 'should not be same as start time' do
        test_shooting_finish_time '00:04:00', nil, '00:04:00', false
      end

      it 'should not be before shooting start time' do
        test_shooting_finish_time '00:04:00', '00:04:02', '00:04:01', false
      end

      it 'should not be same as shooting start time' do
        test_shooting_finish_time '00:04:00', '00:04:02', '00:04:02', false
      end

      it 'is valid when later than start time and shooting start time' do
        test_shooting_finish_time '00:04:00', '00:04:01', '00:04:02', true
      end

      it 'cannot be given if no start time' do
        test_shooting_finish_time nil, nil, '00:04:00', false
      end

      def test_shooting_finish_time(start_time, shooting_start_time, shooting_finish_time, valid)
        competitor = build :competitor, start_time: start_time, shooting_start_time: shooting_start_time,
                           shooting_finish_time: shooting_finish_time
        if valid
          expect(competitor).to be_valid
        else
          expect(competitor).not_to be_valid
          expect(competitor).to have(1).errors_on(:shooting_finish_time)
        end
      end
    end

    describe 'arrival_time' do
      it 'can be nil' do
        test_arrival_time nil, nil, nil, nil, true
        test_arrival_time '00:04:00', nil, nil, nil, true
        test_arrival_time '00:04:00', '00:05:00', nil, nil, true
        test_arrival_time '00:04:00', '00:05:00', '00:06:00', nil, true
      end

      it 'should not be before start time' do
        test_arrival_time '00:04:00', nil, nil, '00:03:59', false
      end

      it 'should not be same as start time' do
        test_arrival_time '00:04:00', nil, nil, '00:04:00', false
      end

      it 'should not be before shooting start time' do
        test_arrival_time '00:04:00', '00:04:03', nil, '00:04:02', false
      end

      it 'should not be same as shooting start time' do
        test_arrival_time '00:04:00', '00:04:03', nil, '00:04:03', false
      end

      it 'should not be before shooting finish time' do
        test_arrival_time '00:04:00', '00:04:03', '00:04:05', '00:04:04', false
      end

      it 'should not be same as shooting finish time' do
        test_arrival_time '00:04:00', '00:04:03', '00:04:05', '00:04:05', false
      end

      it 'is valid when later than start time' do
        test_arrival_time '00:04:00', nil, nil, '00:04:03', true
      end

      it 'is valid when later than start time, shooting start time, and shooting finish time' do
        test_arrival_time '00:04:00', '00:04:01', '00:04:02', '00:04:03', true
      end

      it 'cannot be given if no start time' do
        test_arrival_time nil, nil, nil, '00:04:00', false
      end

      def test_arrival_time(start_time, shooting_start_time, shooting_finish_time, arrival_time, valid)
        competitor = build :competitor, start_time: start_time, shooting_start_time: shooting_start_time,
                           shooting_finish_time: shooting_finish_time, arrival_time: arrival_time
        if valid
          expect(competitor).to be_valid
        else
          expect(competitor).not_to be_valid
          expect(competitor).to have(1).errors_on(:arrival_time)
        end
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

    describe 'track_place' do
      it_should_behave_like 'positive integer', :track_place, true

      context 'when race has shooting place count' do
        let(:race) { create :race, shooting_place_count: 30 }
        let(:series) { create :series, race: race }

        it 'can be the same as the count' do
          competitor = build :competitor, series: series, track_place: 30
          expect(competitor).to have(0).errors_on(:track_place)
        end

        it 'cannot be bigger than the count' do
          competitor = build :competitor, series: series, track_place: 31
          expect(competitor).to have(1).errors_on(:track_place)
        end
      end
    end
  end

  describe 'callbacks' do
    describe 'shots' do
      it 'converts string shots into integers' do
        competitor = create :competitor, shots: %w(10 9 8)
        expect(competitor.shots).to eql([10, 9, 8])
      end
    end

    describe 'extra_shots' do
      it 'converts string shots into integers' do
        competitor = create :competitor, extra_shots: %w(10 9 8)
        expect(competitor.extra_shots).to eql([10, 9, 8])
      end
    end

    describe 'shooting times' do
      before do
        @competitor = build :competitor, start_time: '00:05:00', shooting_overtime_min: 10
      end

      describe 'when shooting start and finish times available' do
        describe 'and shooting time was max 7 minutes' do
          it 'sets shooting overtime minutes to 0 min' do
            test_overtime '00:10:00', '00:17:00', 0
          end
        end

        describe 'and shooting time was 7:01-8:00' do
          it 'sets shooting overtime minutes to 1 min' do
            test_overtime '00:10:00', '00:17:01', 1
            test_overtime '00:10:00', '00:17:59', 1
          end
        end

        describe 'and shooting time was 8:01-9:00' do
          it 'sets shooting overtime minutes to 2 min' do
            test_overtime '00:10:00', '00:18:01', 2
            test_overtime '00:10:00', '00:18:59', 2
          end
        end

        def test_overtime(start_time, finish_time, expected_overtime_min)
          @competitor.shooting_start_time = start_time
          @competitor.shooting_finish_time = finish_time
          @competitor.save!
          expect(@competitor.shooting_overtime_min).to eql expected_overtime_min
        end
      end

      describe 'when shooting start time not available' do
        it 'keeps overtime minutes as is' do
          @competitor.save!
          expect(@competitor.shooting_overtime_min).to eql 10
        end
      end

      describe 'when shooting finish time not available' do
        it 'keeps overtime minutes as is' do
          @competitor.shooting_start_time = '00:10:00'
          @competitor.save!
          expect(@competitor.shooting_overtime_min).to eql 10
        end
      end
    end

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

        it 'reset age group when new series has no age groups' do
          race = create :race
          series1 = create :series, race: race
          series2 = create :series, race: race
          age_group = create :age_group, series: series2
          competitor = create :competitor, series: series2, age_group: age_group
          expect(competitor.age_group_id).to eq(age_group.id)
          competitor.series_id = series1.id
          competitor.save!
          expect(competitor.age_group_id).to be_nil
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
        comp = build(:competitor, :series => series, :start_time => '02:00', :number => nil)
        expect(comp.series).not_to receive(:update_start_time_and_number)
        comp.save!
      end
    end

    context "when competitor has both start time and number" do
      it "should let series update its start time and first number" do
        series = create(:series, :start_time => nil, :first_number => nil, :has_start_list => true)
        comp = create(:competitor, :series => series, :start_time => '02:35:30', :number => 15)
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

      context 'when shooting_score_input is saved' do
        it 'marks has_result true' do
          @competitor.shooting_score_input = 88
          @competitor.save!
          expect(@competitor.has_result?).to be_truthy
        end
      end

      context 'when shots are saved' do
        it 'marks has_result true' do
          @competitor.shots = [9]
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

  describe "#sort_three_sports_competitors" do
    describe 'without unofficial competitors' do
      before do
        @unofficials = Series::UNOFFICIALS_EXCLUDED
        @sort_by = 'some-sort-order'
      end

      it 'should sort by result array and number' do
        competitor1 = create_competitor 100, 48, 30
        competitor2 = create_competitor 99, 50, 4
        competitor3 = create_competitor 99, 49, 3
        competitor0_1 = create_competitor 10, 9, 15
        competitor0_2 = create_competitor 10, 9, 16
        competitors = [competitor0_2, competitor3, competitor1, competitor2, competitor0_1]
        expect(Competitor.sort_three_sports_competitors(competitors, @unofficials, @sort_by))
            .to eq([competitor1, competitor2, competitor3, competitor0_1, competitor0_2])
      end
    end

    describe 'with unofficial competitors' do
      before do
        @unofficials = Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME
        @sort_by = 'another-sort-order'
      end

      it 'should sort by result array and number' do
        competitor1 = create_competitor 100, 59, 30
        competitor2 = create_competitor 99, 40, 4
        competitors = [competitor1, competitor2]
        expect(Competitor.sort_three_sports_competitors(competitors, @unofficials, @sort_by)).to eq([competitor1, competitor2])
      end
    end

    describe 'when competitors have no points yet but only some competitors have number' do
      it 'should consider number as 0' do
        competitor1 = build :competitor, number: nil
        competitor2 = build :competitor, number: 5
        competitors = [competitor1, competitor2]
        expect(Competitor.sort_three_sports_competitors(competitors)).to eq competitors
      end
    end

    def create_competitor(points, shooting_points, number)
      competitor = build :competitor, number: number
      allow(competitor).to receive(:three_sports_race_results).with(@unofficials, @sort_by).and_return([points, shooting_points])
      competitor
    end
  end

  describe "#sort_shooting_race_competitors" do
    it 'should sort by result array and number' do
      competitor1 = create_competitor 100, 48, 30
      competitor2 = create_competitor 99, 50, 4
      competitor3 = create_competitor 99, 49, 3
      competitor0_1 = create_competitor 10, 9, 15
      competitor0_2 = create_competitor 10, 9, 16
      competitors = [competitor0_2, competitor3, competitor1, competitor2, competitor0_1]
      expect(Competitor.sort_shooting_race_competitors(competitors)).to eq([competitor1, competitor2, competitor3, competitor0_1, competitor0_2])
    end

    describe 'when competitors have no points yet but only some competitors have number' do
      it 'should consider number as 0' do
        competitor1 = create_competitor 0, 0, nil
        competitor2 = create_competitor 0, 0, 5
        competitors = [competitor1, competitor2]
        expect(Competitor.sort_shooting_race_competitors(competitors)).to eq competitors
      end
    end

    def create_competitor(shooting_score, final_round_score, number)
      competitor = build :competitor, number: number
      allow(competitor).to receive(:shooting_race_results).and_return([shooting_score, final_round_score])
      competitor
    end
  end

  describe "#shooting_score" do
    it "should return nil when total input is nil and no shots" do
      expect(build(:competitor).shooting_score).to be_nil
    end

    it "should be shooting_score_input when it is given" do
      expect(build(:competitor, :shooting_score_input => 55).shooting_score).to eq(55)
    end

    it "should be sum of defined individual shots if no input sum" do
      comp = build(:competitor, shooting_score_input: nil, shots: [8, 9])
      expect(comp.shooting_score).to eq(17)
    end
  end

  describe "#shooting_points" do
    it "should be nil if shots not defined" do
      competitor = build(:competitor)
      expect(competitor).to receive(:shooting_score).and_return(nil)
      expect(competitor.shooting_points).to be_nil
    end

    it "should be 6 times shooting_score" do
      competitor = build(:competitor)
      expect(competitor).to receive(:shooting_score).and_return(50)
      expect(competitor.shooting_points).to eq(300)
    end

    it 'should subtract 3 points from every overtime minute' do
      series = build :series, points_method: Series::POINTS_METHOD_NO_TIME_4_ESTIMATES
      competitor = build(:competitor, series: series, shooting_overtime_min: 2)
      expect(competitor).to receive(:shooting_score).and_return(90)
      expect(competitor.shooting_points).to eq(6 * (90-2*3))
    end
  end

  describe '#shooting_overtime_penalty' do
    it 'is nil when no overtime minutes' do
      competitor = build :competitor
      expect(competitor.shooting_overtime_penalty).to be_nil
    end

    it 'is nil when overtime minutes is 0' do
      competitor = build :competitor, shooting_overtime_min: 0
      expect(competitor.shooting_overtime_penalty).to be_nil
    end

    context 'when overtime minutes is positive number' do
      context 'and walking series' do
        it 'is 3 times overtime minutes as negative' do
          series = build :series
          allow(series).to receive(:walking_series?).and_return(true)
          competitor = build :competitor, shooting_overtime_min: 4, series: series
          expect(competitor.shooting_overtime_penalty).to eql -12
        end
      end

      context 'and running series' do
        it 'is nil' do
          series = build :series
          allow(series).to receive(:walking_series?).and_return(false)
          competitor = build :competitor, shooting_overtime_min: 4, series: series
          expect(competitor.shooting_overtime_penalty).to be_nil
        end
      end
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
          @series = build(:series, points_method: Series::POINTS_METHOD_NO_TIME_4_ESTIMATES)
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
          @series = build(:series, points_method: Series::POINTS_METHOD_NO_TIME_4_ESTIMATES)
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

      context "when 4 estimates without time points for the series" do
        before do
          @series = build(:series, points_method: Series::POINTS_METHOD_NO_TIME_4_ESTIMATES)
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

      context "when 4 estimates with time points for the series" do
        before do
          @series = build(:series, points_method: Series::POINTS_METHOD_TIME_4_ESTIMATES)
        end

        it "should be 300 when perfect estimates" do
          competitor = build(:competitor, :series => @series,
                             :estimate1 => 100, :estimate2 => 200,
                             :estimate3 => 80, :estimate4 => 140,
                             :correct_estimate1 => 100, :correct_estimate2 => 200,
                             :correct_estimate3 => 80, :correct_estimate4 => 140)
          expect(competitor.estimate_points).to eq(300)
        end

        it "should be 592 when each estimate is 2 meters wrong" do
          competitor = build(:competitor, :series => @series,
                             :estimate1 => 98, :estimate2 => 202,
                             :estimate3 => 108, :estimate4 => 152,
                             :correct_estimate1 => 100, :correct_estimate2 => 200,
                             :correct_estimate3 => 110, :correct_estimate4 => 150)
          expect(competitor.estimate_points).to eq(292)
        end
      end

      context "when 2 estimates without time points for the series" do
        before do
          @series = build(:series, points_method: Series::POINTS_METHOD_NO_TIME_2_ESTIMATES)
        end

        it "should be 600 when perfect estimates" do
          competitor = build(:competitor, :series => @series, :estimate1 => 100, :estimate2 => 200,
                             :correct_estimate1 => 100, :correct_estimate2 => 200)
          expect(competitor.estimate_points).to eq(600)
        end

        it "should be 576 when both estimates are 3 meters wrong" do
          competitor = build(:competitor, :series => @series, :estimate1 => 97, :estimate2 => 203,
                             :correct_estimate1 => 100, :correct_estimate2 => 200)
          expect(competitor.estimate_points).to eq(576) # 600 - 4*3 - 4*3
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
      @unofficials = Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME
      @series = build(:series)
      @age_group = build :age_group, series: @series
      @competitor = build(:competitor, series: @series, age_group: @age_group)
      @best_time_seconds = 3603.0 # rounded: 3600
      allow(@series).to receive(:comparison_time_in_seconds).with(@age_group, @unofficials).and_return(@best_time_seconds)
    end

    it "should be nil when time cannot be calculated yet" do
      expect(@competitor).to receive(:time_in_seconds).and_return(nil)
      expect(@competitor.time_points(@unofficials)).to eq(nil)
    end

    it "should be nil when competitor has time but best time cannot be calculated" do
      # this happens if competitor has time but did not finish (no_result_reason=DNF)
      # and no-one else has result either
      expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds)
      expect(@series).to receive(:comparison_time_in_seconds).with(@age_group, @unofficials).and_return(nil)
      expect(@competitor.time_points(@unofficials)).to eq(nil)
    end

    context 'when only unofficial competitors in the series' do
      before do
        @competitor.unofficial = true
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 10)
        expect(@series).to receive(:comparison_time_in_seconds).with(@age_group, Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME).and_return(@best_time_seconds)
      end

      it 'should find the comparison time for all competitors and calculate time points based on that' do
        expect(@series).to receive(:comparison_time_in_seconds).with(@age_group, Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME).and_return(nil)
        expect(@competitor.time_points(Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)).to eq(299)
      end

      it 'should find the comparison time for all competitors and calculate time points based on that' do
        expect(@series).to receive(:comparison_time_in_seconds).with(@age_group, Series::UNOFFICIALS_EXCLUDED).and_return(nil)
        expect(@competitor.time_points(Series::UNOFFICIALS_EXCLUDED)).to eq(299)
      end
    end

    context "when the competitor has the best time" do
      it "should be 300" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds)
        expect(@competitor.time_points(@unofficials)).to eq(300)
      end
    end

    context "when the competitor has worse time which is rounded down to 10 secs" do
      it "should be 300 when the rounded time is the same as the best time rounded" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 6)
        expect(@competitor.time_points(@unofficials)).to eq(300)
      end

      it "should be 299 when the rounded time is 10 seconds worse than the best time" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 7)
        expect(@competitor.time_points(@unofficials)).to eq(299)
      end

      it "should be 299 when the rounded time is still 10 seconds worse" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 16)
        expect(@competitor.time_points(@unofficials)).to eq(299)
      end

      it "should be 298 when the rounded time is 20 seconds worse" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 17)
        expect(@competitor.time_points(@unofficials)).to eq(298)
      end

      context 'when the rounded time is over 5 minutes worse' do
        before do
          expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 6 * 60 - 2)
        end

        context 'and the race was before 2017' do
          it 'should be 300 - 1 point for every 10 seconds' do
            race = build :race, start_date: '2016-12-31'
            allow(@competitor).to receive(:race).and_return(race)
            expect(@competitor.time_points(@unofficials)).to eq(300 - 6 * 6)
          end
        end

        context 'and the race is 2017 or later' do
          it 'should be 300 - 1 point for every 10 seconds for the first 5 min, then -1 point for every 20 second' do
            race = build :race, start_date: '2017-01-01'
            allow(@competitor).to receive(:race).and_return(race)
            expect(@competitor.time_points(@unofficials)).to eq(300 - 5 * 6 - 3)
          end
        end
      end
    end

    context "when the competitor is an unofficial competitor and has better time than official best time" do
      it "should be 300" do
        @competitor.unofficial = true
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds - 60)
        expect(@competitor.time_points(@unofficials)).to eq(300)
      end
    end

    it "should never be negative" do
      expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 100000)
      expect(@competitor.time_points(@unofficials)).to eq(0)
    end

    context "when no time points (4 estimates)" do
      it "should be nil" do
        @competitor.series.points_method = Series::POINTS_METHOD_NO_TIME_4_ESTIMATES
        allow(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds)
        expect(@competitor.time_points(@unofficials)).to be_nil
      end
    end

    context "when no time points (2 estimates)" do
      it "should be nil" do
        @competitor.series.points_method = Series::POINTS_METHOD_NO_TIME_2_ESTIMATES
        allow(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds)
        expect(@competitor.time_points(@unofficials)).to be_nil
      end
    end

    context "when 300 time points for all competitors in the series" do
      it "should be 300" do
        @competitor.series.points_method = Series::POINTS_METHOD_300_TIME_2_ESTIMATES
        allow(@competitor).to receive(:time_in_seconds).and_return(nil)
        expect(@competitor.time_points(@unofficials)).to eq(300)
      end
    end

    context "no result" do
      before do
        @competitor = build(:competitor, series: @series, age_group: @age_group, no_result_reason: Competitor::DQ)
        @best_time_seconds = 3603.0
        allow(@series).to receive(:comparison_time_in_seconds).with(@age_group, @unofficials).and_return(@best_time_seconds)
      end

      it "should be like normally when the competitor has not the best time" do
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds + 20)
        expect(@competitor.time_points(@unofficials)).to eq(298)
      end

      it "should be nil when competitor's time is better than the best time" do
        # note: when no result, the time really can be better than the best time
        # since such a competitor's time cannot be the best time
        expect(@competitor).to receive(:time_in_seconds).and_return(@best_time_seconds - 1)
        expect(@competitor.time_points(@unofficials)).to be_nil
      end
    end
  end

  describe "#points" do
    context 'when shooting race' do
      before do
        @competitor = build :competitor
        allow(@competitor).to receive(:sport).and_return(Sport.by_key(Sport::ILMALUODIKKO))
        allow(@competitor).to receive(:shooting_score).and_return(150)
      end

      it 'should return nil when no result reason' do
        @competitor.no_result_reason = 'DNF'
        expect(@competitor.points(@unofficials)).to be_nil
      end

      it 'should return the shooting score' do
        expect(@competitor.points).to eql 150
      end
    end

    context 'when 3 sports race' do
      before do
        @unofficials = Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME
        @competitor = build(:competitor)
        allow(@competitor).to receive(:sport).and_return(Sport.by_key(Sport::SKI))
        allow(@competitor).to receive(:shooting_points).and_return(100)
        allow(@competitor).to receive(:estimate_points).and_return(150)
        allow(@competitor).to receive(:time_points).with(@unofficials).and_return(200)
      end

      it 'should return nil when no result reason' do
        @competitor.no_result_reason = 'DNF'
        expect(@competitor.points(@unofficials)).to be_nil
      end

      it "should consider missing shot points as 0" do
        expect(@competitor).to receive(:shooting_points).and_return(nil)
        expect(@competitor.points(@unofficials)).to eq(150 + 200)
      end

      it "should consider missing estimate points as 0" do
        expect(@competitor).to receive(:estimate_points).and_return(nil)
        expect(@competitor.points(@unofficials)).to eq(100 + 200)
      end

      it "should consider missing time points as 0" do
        expect(@competitor).to receive(:time_points).with(@unofficials).and_return(nil)
        expect(@competitor.points(@unofficials)).to eq(100 + 150)
      end

      it "should be sum of sub points when all of them are available" do
        expect(@competitor.points(@unofficials)).to eq(100 + 150 + 200)
      end
    end
  end


  describe '#team_competition_points' do
    let(:qualification_round_score) { 87 }
    let(:points) { 200 }
    let(:competitor) { build :competitor }

    before do
      allow(competitor).to receive(:qualification_round_score).and_return(qualification_round_score)
      allow(competitor).to receive(:points).and_return(points)
    end

    context 'when shooting race' do
      it 'returns qualification round score' do
        expect(competitor.team_competition_points(Sport.by_key Sport::ILMALUODIKKO)).to eql qualification_round_score
      end
    end

    context 'when 3 sports race' do
      it 'returns points' do
        expect(competitor.team_competition_points(Sport.by_key Sport::RUN)).to eql points
      end
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
    let(:series) { build :series }
    let(:competitor) { build :competitor, series: series }

    before do
      allow(competitor).to receive(:sport).and_return(sport)
    end

    context 'for three sports race' do
      let(:sport) { Sport.by_key Sport::RUN }

      context "when competitor has some 'no result reason'" do
        it "should return true" do
          competitor.no_result_reason = Competitor::DNS
          expect(competitor).to be_finished
        end
      end

      context "when competitor has no 'no result reason'" do
        before do
          # no need to have correct estimate
          competitor.start_time = '11:10'
          competitor.arrival_time = '11:20'
          competitor.shooting_score_input = 90
          competitor.estimate1 = 100
          competitor.estimate2 = 110
        end

        context "and competitor has shots and arrival time" do
          context "and competitor has both estimates" do
            it "should return true" do
              expect(competitor).to be_finished
            end
          end

          context "and either estimate is missing" do
            it "should return false" do
              competitor.estimate2 = nil
              expect(competitor).not_to be_finished
              competitor.estimate1 = nil
              competitor.estimate2 = 110
              expect(competitor).not_to be_finished
            end
          end

          context "and 4 estimates for the series" do
            before do
              series.points_method = Series::POINTS_METHOD_NO_TIME_4_ESTIMATES
            end

            context "and 3rd estimate is missing" do
              it "should return false" do
                competitor.estimate3 = nil
                competitor.estimate4 = 110
                expect(competitor).not_to be_finished
              end
            end

            context "and 4th estimate is missing" do
              it "should return false" do
                competitor.estimate3 = 110
                competitor.estimate4 = nil
                expect(competitor).not_to be_finished
              end
            end
          end
        end

        context "and shots result is missing" do
          it "should return false" do
            competitor.shooting_score_input = nil
            expect(competitor).not_to be_finished
          end
        end

        context "and time result is missing" do
          it "should return false" do
            competitor.arrival_time = nil
            expect(competitor).not_to be_finished
          end
        end

        context "and series does not calculate time points and other results are there" do
          it "should return true" do
            series.points_method = Series::POINTS_METHOD_NO_TIME_4_ESTIMATES
            competitor.estimate3 = 110
            competitor.estimate4 = 100
            competitor.arrival_time = nil
            expect(competitor).to be_finished
          end
        end

        context "and series gives 300 time points for all and other results are there" do
          it "should return true" do
            series.points_method = Series::POINTS_METHOD_300_TIME_2_ESTIMATES
            competitor.arrival_time = nil
            expect(competitor).to be_finished
          end
        end
      end
    end

    context 'for shooting race' do
      let(:sport) { Sport.by_key Sport::ILMALUODIKKO }

      context 'when competitor has no result reason' do
        it 'should return true' do
          competitor.no_result_reason = Competitor::DNS
          expect(competitor).to be_finished
        end
      end

      context "when competitor has no 'no result reason'" do
        context 'and has no shots' do
          it 'should return false' do
            expect(competitor).not_to be_finished
          end
        end

        context 'and it has one qualification round shot missing' do
          it 'should return false' do
            competitor.shots = (0..8).map
            expect(competitor).not_to be_finished
          end
        end

        context 'and it has exactly all qualification round shots' do
          it 'should return true' do
            competitor.shots = (0..9).map
            expect(competitor).to be_finished
          end
        end

        context 'and it has one final round shot missing' do
          it 'should return false' do
            competitor.shots = (0..18).map
            expect(competitor).not_to be_finished
          end
        end

        context 'and it has exactly all final round shots' do
          it 'should return true' do
            competitor.shots = (0..19).map
            expect(competitor).to be_finished
          end
        end

        context 'and it has extra round shots' do
          it 'should return true' do
            competitor.shots = (0..20).map
            expect(competitor).to be_finished
          end
        end
      end
    end
  end

  describe "#comparison_time_in_seconds" do
    it "should delegate call to series with own age group and unofficials as parameters" do
      unofficials = Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME
      series = build :series
      age_group = build :age_group
      competitor = build(:competitor, :series => series, :age_group => age_group)
      expect(series).to receive(:comparison_time_in_seconds).with(age_group, unofficials).and_return(12345)
      expect(competitor.comparison_time_in_seconds(unofficials)).to eq(12345)
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
