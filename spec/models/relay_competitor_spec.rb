require 'spec_helper'

describe RelayCompetitor do
  it "create" do
    create(:relay_competitor)
  end

  describe "associations" do
    it { is_expected.to belong_to(:relay_team) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    describe "leg" do
      it { is_expected.to validate_numericality_of(:leg) }
      it { is_expected.not_to allow_value(0).for(:leg) }
      it { is_expected.to allow_value(1).for(:leg) }
      it { is_expected.not_to allow_value(1.1).for(:leg) }
      it "should not allow bigger leg value than relay legs count" do
        relay = build(:relay, :legs_count => 3)
        team = build(:relay_team, :relay => relay)
        competitor = build(:relay_competitor, :relay_team => team, :leg => 3)
        expect(competitor).to be_valid
        competitor.leg = 4
        expect(competitor).to have(1).errors_on(:leg)
      end

      describe "uniqueness" do
        before do
          create(:relay_competitor)
        end
        it { is_expected.to validate_uniqueness_of(:leg).scoped_to(:relay_team_id) }
      end
    end

    describe "misses" do
      it { is_expected.to validate_numericality_of(:misses) }
      it { is_expected.to allow_value(nil).for(:misses) }
      it { is_expected.to allow_value(0).for(:misses) }
      it { is_expected.to allow_value(1).for(:misses) }
      it { is_expected.not_to allow_value(1.1).for(:misses) }
      it { is_expected.to allow_value(5).for(:misses) }
      it { is_expected.not_to allow_value(6).for(:misses) }
    end

    describe "estimate" do
      it { is_expected.to allow_value(nil).for(:estimate) }
      it { is_expected.not_to allow_value(1.1).for(:estimate) }
      it { is_expected.not_to allow_value(-1).for(:estimate) }
      it { is_expected.not_to allow_value(0).for(:estimate) }
      it { is_expected.to allow_value(1).for(:estimate) }
    end

    describe "adjustment" do
      it { is_expected.to allow_value(nil).for(:adjustment) }
      it { is_expected.to allow_value(-1).for(:adjustment) }
      it { is_expected.to allow_value(0).for(:adjustment) }
      it { is_expected.to allow_value(1).for(:adjustment) }
      it { is_expected.not_to allow_value(1.1).for(:adjustment) }
    end

    describe "arrival_time" do
      it { is_expected.to allow_value(nil).for(:arrival_time) }

      describe "compared to start time" do
        before do
          @relay = build(:relay, :start_time => '14:00')
          @team = build(:relay_team, :relay => @relay)
        end

        it "can be nil" do
          expect(build(:relay_competitor, :relay_team => @team, :leg => 1,
            :arrival_time => nil)).to be_valid
        end

        it "should not be before start time" do
          create(:relay_competitor, :relay_team => @team, :leg => 1, :arrival_time => '00:10:00')
          expect(build(:relay_competitor, :relay_team => @team, :leg => 2, :arrival_time => '00:09:59')).
              to have(1).errors_on(:arrival_time)
        end

        it "should not be same as start time" do
          expect(build(:relay_competitor, :relay_team => @team, :leg => 1,
            :arrival_time => '00:00')).to have(1).errors_on(:arrival_time)
        end

        it "is valid when later than start time" do
          expect(build(:relay_competitor, :relay_team => @team, :leg => 1,
            :arrival_time => '00:01')).to be_valid
        end
      end

      describe "compared to the next competitor's arrival time" do
        it "cannot be later than the next one's arrival time" do
          relay = create(:relay, :start_time => '14:00')
          team = create(:relay_team, :relay => relay)
          comp1 = create(:relay_competitor, :relay_team => team, :leg => 1,
            :arrival_time => '00:10:00')
          create(:relay_competitor, :relay_team => team, :leg => 2,
            :arrival_time => '00:20:00')
          comp1.arrival_time = '00:20:01'
          expect(comp1).to have(1).errors_on(:arrival_time)
        end
      end
    end

    it_should_behave_like 'integer', :estimate_penalties_adjustment
    it_should_behave_like 'integer', :shooting_penalties_adjustment
  end

  describe "#previous_competitor" do
    before do
      @team = create(:relay_team)
      @c1 = create(:relay_competitor, :relay_team => @team, :leg => 1)
      @c2 = create(:relay_competitor, :relay_team => @team, :leg => 2)
      @c3 = create(:relay_competitor, :relay_team => @team, :leg => 3)
      @team.reload
    end

    it "should return nil for the first competitor" do
      expect(@c1.previous_competitor).to be_nil
    end

    it "should return the first competitor for the second competitor" do
      expect(@c2.previous_competitor).to eq(@c1)
    end

    it "should return the second competitor for the third competitor" do
      expect(@c3.previous_competitor).to eq(@c2)
    end
  end

  describe "#next_competitor" do
    before do
      @team = create(:relay_team)
      @c1 = create(:relay_competitor, :relay_team => @team, :leg => 1)
      @c2 = create(:relay_competitor, :relay_team => @team, :leg => 2)
      @c3 = create(:relay_competitor, :relay_team => @team, :leg => 3)
      @team.reload
    end

    it "should return the second competitor for the first competitor" do
      expect(@c1.next_competitor).to eq(@c2)
    end

    it "should return the third competitor for the second competitor" do
      expect(@c2.next_competitor).to eq(@c3)
    end

    it "should return nil for the last competitor" do
      expect(@c3.next_competitor).to be_nil
    end
  end

  describe "set start time in save" do
    before do
      @relay = create(:relay, :start_time => '10:30')
      @team = create(:relay_team, :relay => @relay)
      @c1 = build(:relay_competitor, :relay_team => @team, :leg => 1)
      @c2 = build(:relay_competitor, :relay_team => @team, :leg => 2)
    end

    context "when first competitor is saved" do
      it "should set 00:00 as competitor start time" do
        @c1.save!
        expect(@c1.start_time.strftime('%H:%M:%S')).to eq('00:00:00')
      end
    end

    context "when non-first competitor is saved" do
      it "should set the previous competitor arrival time as start time" do
        @c1.arrival_time = '10:45:13'
        @c1.save!
        @c2.save!
        expect(@c2.start_time.strftime('%H:%M:%S')).to eq('10:45:13')
        @c1.arrival_time = '11:01:02'
        @c1.save!
        @c2.save!
        expect(@c2.start_time.strftime('%H:%M:%S')).to eq('11:01:02')
      end
    end
  end

  describe "set start time for next competitor in update" do
    before do
      @relay = create(:relay, :start_time => '10:30', :legs_count => 2)
      @team = create(:relay_team, :relay => @relay)
      @c1 = create(:relay_competitor, :relay_team => @team, :leg => 1)
      @c2 = create(:relay_competitor, :relay_team => @team, :leg => 2)
      @c1.arrival_time = '10:53:29'
    end

    context "when non-last competitor" do
      it "should set the arrival time for the next competitor's start time" do
        @c1.save!
        @c2.reload
        expect(@c2.start_time.strftime('%H:%M:%S')).to eq('10:53:29')
      end
    end

    context "when the last competitor" do
      it "should not fail" do
        @c1.save!
        @c2.arrival_time = '11:10:07'
        @c2.save!
      end
    end
  end

  describe "#estimate_penalties" do
    before do
      @relay = create(:relay)
      team = create(:relay_team, :relay => @relay)
      @comp = create(:relay_competitor, :relay_team => team, :leg => 2,
        :estimate => 100)
      allow(@relay).to receive(:correct_estimate).with(2).and_return(100)
    end

    context "when estimate is nil" do
      it "should be nil" do
        @comp.estimate = nil
        expect(@comp.estimate_penalties).to be_nil
      end
    end

    context "when the correct estimate for the same leg is nil" do
      it "should be nil" do
        allow(@relay).to receive(:correct_estimate).with(2).and_return(nil)
        expect(@comp.estimate_penalties).to be_nil
      end
    end

    context "when correct estimate and estimate available" do
      it "should be 0 when perfect estimate" do
        expect(@comp.estimate_penalties).to eq(0)
      end

      it "should be 0 when estimate 1-5 meters too high" do
        @comp.estimate = 105
        expect(@comp.estimate_penalties).to eq(0)
      end

      it "should be 0 when estimate 1-5 meters too low" do
        @comp.estimate = 95
        expect(@comp.estimate_penalties).to eq(0)
      end

      it "should be 1 when estimate 6-10 meters too high" do
        @comp.estimate = 106
        expect(@comp.estimate_penalties).to eq(1)
        @comp.estimate = 110
        expect(@comp.estimate_penalties).to eq(1)
      end

      it "should be 1 when estimate 6-10 meters too low" do
        @comp.estimate = 94
        expect(@comp.estimate_penalties).to eq(1)
        @comp.estimate = 90
        expect(@comp.estimate_penalties).to eq(1)
      end

      it "should be 4 when estimate 21-25 meters too high" do
        @comp.estimate = 121
        expect(@comp.estimate_penalties).to eq(4)
        @comp.estimate = 125
        expect(@comp.estimate_penalties).to eq(4)
      end

      it "should be 4 when estimate 21-25 meters too low" do
        @comp.estimate = 79
        expect(@comp.estimate_penalties).to eq(4)
        @comp.estimate = 75
        expect(@comp.estimate_penalties).to eq(4)
      end

      it "should be 5 when estimate 26-30 meters too high" do
        @comp.estimate = 126
        expect(@comp.estimate_penalties).to eq(5)
        @comp.estimate = 130
        expect(@comp.estimate_penalties).to eq(5)
      end

      it "should be 5 when estimate 26-30 meters too low" do
        @comp.estimate = 74
        expect(@comp.estimate_penalties).to eq(5)
        @comp.estimate = 70
        expect(@comp.estimate_penalties).to eq(5)
      end

      it "should be 5 when estimate at least 31 meters too high" do
        @comp.estimate = 131
        expect(@comp.estimate_penalties).to eq(5)
      end

      it "should be 5 when estimate at least 31 meters too low" do
        @comp.estimate = 69
        expect(@comp.estimate_penalties).to eq(5)
      end
    end
  end

  describe "#time_in_seconds" do
    it "should be nil when start time not known yet" do
      expect(build(:relay_competitor, :start_time => nil).time_in_seconds).to be_nil
    end

    it "should be nil when arrival time is not known yet" do
      expect(build(:relay_competitor, :start_time => '14:00', :arrival_time => nil).
        time_in_seconds).to be_nil
    end

    it "should be difference of arrival and start times when no adjustment" do
      expect(build(:relay_competitor, :start_time => '13:58:02', :arrival_time => '15:02:04').
        time_in_seconds).to eq(64 * 60 + 2)
    end
    it "should be difference of arrival and start times added with adjustment" do
      expect(build(:relay_competitor, :start_time => '13:58:02', :arrival_time => '15:02:04', :adjustment => 15).
        time_in_seconds).to eq(64 * 60 + 2 + 15)
    end
    it "should be difference of arrival and start times added with negative adjustment" do
      expect(build(:relay_competitor, :start_time => '13:58:02', :arrival_time => '15:02:04', :adjustment => -15).
        time_in_seconds).to eq(64 * 60 + 2 + -15)
    end

    describe 'with penalty seconds' do
      let(:relay) { create :relay, estimate_penalty_seconds: 40, shooting_penalty_seconds: 60 }
      let(:relay_team) { create :relay_team, relay: relay }
      let(:competitor) { build :relay_competitor, relay_team: relay_team, leg: 1,
                               start_time: '00:20:02', arrival_time: '00:40:07', misses: 2, estimate: 100 }

      before do
        create :relay_correct_estimate, relay: relay, leg: 1, distance: 121 # 4 penalties
      end

      context 'when they are not wanted' do
        it 'does not add anything to the arrival time' do
          expect(competitor.time_in_seconds(false)).to eq(20 * 60 + 5)
        end
      end

      context 'when they are wanted' do
        it 'add penalties seconds to the arrival time' do
          expect(competitor.time_in_seconds(true)).to eq(20 * 60 + 5 + 40 * 4 + 60 * 2)
        end
      end

      context 'when they are wanted but are not defined' do
        it 'does not crash' do
          relay.estimate_penalty_seconds = nil
          relay.shooting_penalty_seconds = nil
          expect(competitor.time_in_seconds(true)).to eq(20 * 60 + 5)
        end
      end
    end
  end
end
