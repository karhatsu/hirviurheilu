require 'spec_helper'

describe Relay do
  it "create" do
    FactoryGirl.create(:relay)
  end
  
  describe "associations" do
    it { is_expected.to belong_to(:race) }
    it { is_expected.to have_many(:relay_teams) }
    it { is_expected.to have_many(:relay_correct_estimates) }
    it { is_expected.to have_many(:relay_competitors).through(:relay_teams) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to allow_value(nil).for(:start_time) }

    describe "start_day" do
      it { is_expected.to validate_numericality_of(:start_day) }
      it { is_expected.not_to allow_value(0).for(:start_day) }
      it { is_expected.to allow_value(1).for(:start_day) }
      it { is_expected.not_to allow_value(1.1).for(:start_day) }

      before do
        race = FactoryGirl.build(:race)
        allow(race).to receive(:days_count).and_return(2)
        @relay = FactoryGirl.build(:relay, :race => race, :start_day => 3)
      end

      it "should not be bigger than race days count" do
        expect(@relay).to have(1).errors_on(:start_day)
      end
    end

    describe "legs_count" do
      it { is_expected.not_to allow_value(nil).for(:legs_count) }
      it { is_expected.not_to allow_value(0).for(:legs_count) }
      it { is_expected.not_to allow_value(1).for(:legs_count) }
      it { is_expected.to allow_value(2).for(:legs_count) }
      it { is_expected.not_to allow_value(2.1).for(:legs_count) }

      it "should not be allowed to change after create" do
        relay = FactoryGirl.create(:relay, :legs_count => 5)
        relay.legs_count = 4
        relay.save
        relay.reload
        expect(relay.legs_count).to eq(5)
      end
    end
  end

  describe "teams" do
    before do
      @relay = FactoryGirl.create(:relay)
      @relay.relay_teams << FactoryGirl.build(:relay_team, :relay => @relay, :number => 3)
      @relay.relay_teams << FactoryGirl.build(:relay_team, :relay => @relay, :number => 1)
      @relay.relay_teams << FactoryGirl.build(:relay_team, :relay => @relay, :number => 2)
      @relay.reload
    end

    it "should be ordered by number" do
      expect(@relay.relay_teams[0].number).to eq(1)
      expect(@relay.relay_teams[1].number).to eq(2)
      expect(@relay.relay_teams[2].number).to eq(3)
    end
  end

  describe "correct estimates" do
    before do
      @relay = FactoryGirl.create(:relay)
      @relay.relay_correct_estimates << FactoryGirl.build(:relay_correct_estimate,
        :relay => @relay, :leg => 3)
      @relay.relay_correct_estimates << FactoryGirl.build(:relay_correct_estimate,
        :relay => @relay, :leg => 1)
      @relay.relay_correct_estimates << FactoryGirl.build(:relay_correct_estimate,
        :relay => @relay, :leg => 2)
      @relay.reload
    end

    it "should be ordered by leg" do
      expect(@relay.relay_correct_estimates[0].leg).to eq(1)
      expect(@relay.relay_correct_estimates[1].leg).to eq(2)
      expect(@relay.relay_correct_estimates[2].leg).to eq(3)
    end
  end

  describe "#correct_estimate" do
    before do
      @relay = FactoryGirl.create(:relay)
    end

    it "should return nil if no correct estimates at all" do
      expect(@relay.correct_estimate(1)).to be_nil
    end

    it "should return nil if no correct estimate for this leg" do
      @relay.relay_correct_estimates << FactoryGirl.build(:relay_correct_estimate,
        :relay => @relay, :leg => 1)
      expect(@relay.correct_estimate(2)).to be_nil
    end

    it "should return the distance of correct estimate for the given leg" do
      @relay.relay_correct_estimates << FactoryGirl.build(:relay_correct_estimate,
        :relay => @relay, :leg => 2, :distance => 111)
      expect(@relay.correct_estimate(2)).to eq(111)
    end
  end

  describe "results" do
    before do
      @relay = FactoryGirl.create(:relay, :legs_count => 3, :start_time => '12:00')
    end

    context "when no teams" do
      describe "#results" do
        it "should return empty array" do
          expect(@relay.results).to eq([])
        end
      end

      describe "#leg_results" do
        it "should return empty array" do
          expect(@relay.leg_results(1)).to eq([])
        end
      end
    end

    context "when teams" do
      before do
        @team2 = create_team(2)
        @team1 = create_team(1)
        @team3 = create_team(3)
        @team4 = create_team(4)
        @team5 = create_team(5)
        @team6 = create_team(6)
        @team_DNS = create_team(7, RelayTeam::DNS)
        @team_DNF = create_team(8, RelayTeam::DNF)
        @team_DQ = create_team(9, RelayTeam::DQ)
        create_competitor @team1, 1, '12:13:16'
        create_competitor @team2, 1, '12:13:15'
        create_competitor @team3, 1, '12:13:15'
        create_competitor @team4, 1, '12:13:13'
        create_competitor @team5, 1, '12:13:12'
        create_competitor @team6, 1, '12:13:11'
        create_competitor @team_DNS, 1, nil
        create_competitor @team_DNF, 1, '12:12:00'
        create_competitor @team_DQ, 1, '12:11:59'
        create_competitor @team1, 2, '12:24:15'
        create_competitor @team2, 2, '12:24:14'
        create_competitor @team3, 2, '12:24:17'
        create_competitor @team4, 2, nil
        create_competitor @team5, 2, '12:24:15'
        create_competitor @team6, 2, '12:24:15'
        create_competitor @team_DNS, 2, nil
        create_competitor @team_DNF, 2, '12:24:16'
        create_competitor @team_DQ, 2, nil
        create_competitor @team1, 3, '12:35:14'
        create_competitor @team2, 3, nil
        create_competitor @team3, 3, '12:35:16'
        create_competitor @team4, 3, nil
        create_competitor @team5, 3, '12:35:16'
        create_competitor @team6, 3, '12:35:16'
        create_competitor @team_DNS, 3, nil
        create_competitor @team_DNF, 3, nil
        create_competitor @team_DQ, 3, nil
        
        @finish_order = [@team1, @team6, @team5, @team3, @team2, @team4, @team_DNF, @team_DNS, @team_DQ]
      end

      describe "#results" do
        it "should return the teams sorted so that DNF/DNS/DQ teams go to bottom, " +
            "teams with least full time are best, " +
            "previous leg times are used if two teams have same time, " +
            "and team number is used everything else is same" do
          expect(@relay.results).to eq(@finish_order)
        end
      end

      describe "#leg_results" do
        it "should return the teams sorted in a same way as in full results " +
          "except that DNF/DNS/DQ does not matter for non-last leg" do
          expect(@relay.leg_results(1)).to eq(
            [@team_DQ, @team_DNF, @team6, @team5, @team4, @team2, @team3, @team1, @team_DNS]
          )
          expect(@relay.leg_results('2')).to eq(
            [@team2, @team6, @team5, @team1, @team_DNF, @team3, @team_DQ, @team4, @team_DNS]
          )
          expect(@relay.leg_results(3)).to eq(@finish_order)
        end
      end

      def create_team(number, no_result_reason=nil)
        FactoryGirl.create(:relay_team, :relay => @relay, :name => "Team #{number}",
          :number => number, :no_result_reason => no_result_reason)
      end

      def create_competitor(team, leg, arrival_time)
        FactoryGirl.create(:relay_competitor, :relay_team => team, :leg => leg,
          :arrival_time => arrival_time)
      end
    end
  end

  describe "#finish_errors" do
    before do
      @relay = FactoryGirl.create(:relay, :start_time => '12:00', :legs_count => 2)
      team1 = FactoryGirl.create(:relay_team, :relay => @relay, :number => 1)
      team2 = FactoryGirl.create(:relay_team, :relay => @relay, :number => 2)
      team3 = FactoryGirl.create(:relay_team, :relay => @relay, :number => 3,
        :no_result_reason => RelayTeam::DNS)
      team4 = FactoryGirl.create(:relay_team, :relay => @relay, :number => 4,
        :no_result_reason => RelayTeam::DNF)
      FactoryGirl.create(:relay_competitor, :relay_team => team1, :leg => 1,
        :estimate => 100, :misses => 1, :arrival_time => '12:15')
      FactoryGirl.create(:relay_competitor, :relay_team => team1, :leg => 2,
        :estimate => 100, :misses => 1, :arrival_time => '12:30')
      FactoryGirl.create(:relay_competitor, :relay_team => team2, :leg => 1,
        :estimate => 100, :misses => 1, :arrival_time => '12:15')
      FactoryGirl.create(:relay_competitor, :relay_team => team2, :leg => 2,
        :estimate => 100, :misses => 1, :arrival_time => '12:30')
      FactoryGirl.create(:relay_competitor, :relay_team => team3, :leg => 1)
      FactoryGirl.create(:relay_competitor, :relay_team => team3, :leg => 2)
      FactoryGirl.create(:relay_competitor, :relay_team => team4, :leg => 1,
        :estimate => 100, :arrival_time => '12:15')
      FactoryGirl.create(:relay_competitor, :relay_team => team4, :leg => 2,
        :estimate => 100, :misses => 1)
      FactoryGirl.create(:relay_correct_estimate, :relay => @relay, :distance => 90, :leg => 1)
      FactoryGirl.create(:relay_correct_estimate, :relay => @relay, :distance => 90, :leg => 2)
    end

    context "when all the necessary data is there" do
      it "should return an empty array" do
        @relay.reload
        expect(@relay.finish_errors).to be_empty
      end
    end

    context "when relay start time is missing" do
      it "should return an array with error" do
        @relay.start_time = nil
        @relay.save!
        confirm_cannot_finish
      end
    end

    context "when no teams" do
      it "should return an array with error" do
        allow(@relay).to receive(:relay_teams).and_return([])
        confirm_cannot_finish
      end
    end

    context "when some competitor is missing arrival time" do
      it "should return an array with error" do
        competitor = @relay.relay_teams[1].relay_competitors[1]
        competitor.arrival_time = nil
        competitor.save!
        confirm_cannot_finish
      end
    end

    context "when some competitor is missing misses" do
      it "should return an array with error" do
        competitor = @relay.relay_teams[1].relay_competitors[1]
        competitor.misses = nil
        competitor.save!
        confirm_cannot_finish
      end
    end

    context "when some competitor is missing estimate" do
      it "should return an array with error" do
        competitor = @relay.relay_teams[1].relay_competitors[1]
        competitor.estimate = nil
        competitor.save!
        confirm_cannot_finish
      end
    end

    context "when no correct estimates at all" do
      it "should return an array with error" do
        allow(@relay).to receive(:relay_correct_estimates).and_return([])
        confirm_cannot_finish
      end
    end

    context "when correct estimates is missing" do
      it "should return an array with error" do
        ce = @relay.relay_correct_estimates[1]
        ce.distance = nil
        ce.save!
        confirm_cannot_finish
      end
    end

    def confirm_cannot_finish
      @relay.reload
      expect(@relay.finish_errors).not_to be_empty
    end
  end

  describe "#finish" do
    before do
      @relay = FactoryGirl.create(:relay)
    end

    context "when the relay can be finished" do
      it "should mark the race as finished and return true" do
        expect(@relay).to receive(:finish_errors).and_return([])
        expect(@relay.finish).to be_truthy
        expect(@relay.errors.size).to eq(0)
        @relay.reload
        expect(@relay).to be_finished
      end
    end

    context "when the relay cannot be finished" do
      it "should not mark the race as finished and return false" do
        expect(@relay).to receive(:finish_errors).and_return(['error'])
        expect(@relay.finish).to be_falsey
        expect(@relay.errors.size).to eq(1)
        @relay.reload
        expect(@relay).not_to be_finished
      end
    end
  end

  describe "#finish!" do
    before do
      @relay = FactoryGirl.build(:relay)
    end

    it "should return true when finishing the relay succeeds" do
      expect(@relay).to receive(:finish).and_return(true)
      expect(@relay.finish!).to be_truthy
    end

    it "should raise exception if finishing the relay fails" do
      expect(@relay).to receive(:finish).and_return(false)
      expect { @relay.finish! }.to raise_error
    end
  end

  describe "#active?" do
    before do
      @race = FactoryGirl.build(:race, :start_date => Date.today,
        :end_date => Date.today + 1)
      @relay = FactoryGirl.build(:relay, :race => @race, :start_day => 1,
        :start_time => (Time.now - 10).strftime('%H:%M:%S'), :finished => false)
    end

    it "should return true when the relay is today and started but not finished yet" do
      expect(@relay).to be_active
    end

    it "should return true when the relay was yesterday but is not finished yet" do
      @race.start_date = Date.today - 1
      @relay.start_time = (Time.now + 100).strftime('%H:%M:%S') # time shouldn't matter
      expect(@relay).to be_active
    end

    it "should return false when no start time defined" do
      @relay.start_time = nil
      expect(@relay).not_to be_active
    end

    it "should return false when the race is not today" do
      @race.start_date = Date.today + 1
      expect(@relay).not_to be_active
    end

    it "should return false when the relay is not today" do
      @relay.start_day = 2
      expect(@relay).not_to be_active
    end

    it "should return false when the relay is today but has not started yet" do
      @relay.start_time = (Time.now + 100).strftime('%H:%M:%S')
      expect(@relay).not_to be_active
    end

    it "should return false when the relay is finished" do
      @relay.finished = true
      expect(@relay).not_to be_active
    end
  end
  
  describe "#start_datetime" do
    it "should return nil when no start time" do
      expect(FactoryGirl.build(:relay, :start_time => nil).start_datetime).to be_nil
    end
    
    it "should return nil when no race" do
      expect(FactoryGirl.build(:relay, :race => nil, :start_time => '13:45:31').start_datetime).to be_nil
    end
    
    it "should return nil when no race start date" do
      race = FactoryGirl.build(:race, :start_date => nil)
      expect(FactoryGirl.build(:relay, :race => race, :start_time => '13:45:31').start_datetime).to be_nil
    end
    
    context "when race date and start time available" do
      before do
        @race = FactoryGirl.build(:race, :start_date => '2011-06-30')
        @relay = FactoryGirl.build(:relay, :race => @race, :start_time => '13:45:31')
      end
      
      it "should return the compination of race date and start time when both available" do
        expect(@relay.start_datetime.strftime('%d.%m.%Y %H:%M:%S')).to eq('30.06.2011 13:45:31')
      end
      
      it "should return the object with local zone" do
        original_zone = Time.zone
        Time.zone = 'Hawaii'
        expect(@relay.start_datetime.zone).to eq('HST')
        Time.zone = original_zone # must reset back to original!
      end
      
      it "should return the correct date when relay start day is not 1" do
        @race.end_date = '2011-07-02'
        @relay.start_day = 3
        expect(@relay.start_datetime.strftime('%d.%m.%Y %H:%M:%S')).to eq('02.07.2011 13:45:31')
      end
    end
  end
end
