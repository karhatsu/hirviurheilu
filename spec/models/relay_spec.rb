require 'spec_helper'

describe Relay do
  it "create" do
    Factory.create(:relay)
  end
  
  describe "associations" do
    it { should belong_to(:race) }
    it { should have_many(:relay_teams) }
    it { should have_many(:relay_correct_estimates) }
    it { should have_many(:relay_competitors).through(:relay_teams) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should allow_value(nil).for(:start_time) }

    describe "start_day" do
      it { should validate_numericality_of(:start_day) }
      it { should_not allow_value(0).for(:start_day) }
      it { should allow_value(1).for(:start_day) }
      it { should_not allow_value(1.1).for(:start_day) }

      before do
        race = Factory.build(:race)
        race.stub!(:days_count).and_return(2)
        @relay = Factory.build(:relay, :race => race, :start_day => 3)
      end

      it "should not be bigger than race days count" do
        @relay.should have(1).errors_on(:start_day)
      end
    end

    describe "legs_count" do
      it { should_not allow_value(nil).for(:legs_count) }
      it { should_not allow_value(0).for(:legs_count) }
      it { should_not allow_value(1).for(:legs_count) }
      it { should allow_value(2).for(:legs_count) }
      it { should_not allow_value(2.1).for(:legs_count) }

      it "should not be allowed to change after create" do
        relay = Factory.create(:relay, :legs_count => 5)
        relay.legs_count = 4
        relay.save
        relay.reload
        relay.legs_count.should == 5
      end
    end
  end

  describe "teams" do
    before do
      @relay = Factory.create(:relay)
      @relay.relay_teams << Factory.build(:relay_team, :relay => @relay, :number => 3)
      @relay.relay_teams << Factory.build(:relay_team, :relay => @relay, :number => 1)
      @relay.relay_teams << Factory.build(:relay_team, :relay => @relay, :number => 2)
      @relay.reload
    end

    it "should be ordered by number" do
      @relay.relay_teams[0].number.should == 1
      @relay.relay_teams[1].number.should == 2
      @relay.relay_teams[2].number.should == 3
    end
  end

  describe "correct estimates" do
    before do
      @relay = Factory.create(:relay)
      @relay.relay_correct_estimates << Factory.build(:relay_correct_estimate,
        :relay => @relay, :leg => 3)
      @relay.relay_correct_estimates << Factory.build(:relay_correct_estimate,
        :relay => @relay, :leg => 1)
      @relay.relay_correct_estimates << Factory.build(:relay_correct_estimate,
        :relay => @relay, :leg => 2)
      @relay.reload
    end

    it "should be ordered by leg" do
      @relay.relay_correct_estimates[0].leg.should == 1
      @relay.relay_correct_estimates[1].leg.should == 2
      @relay.relay_correct_estimates[2].leg.should == 3
    end
  end

  describe "#correct_estimate" do
    before do
      @relay = Factory.create(:relay)
    end

    it "should return nil if no correct estimates at all" do
      @relay.correct_estimate(1).should be_nil
    end

    it "should return nil if no correct estimate for this leg" do
      @relay.relay_correct_estimates << Factory.build(:relay_correct_estimate,
        :relay => @relay, :leg => 1)
      @relay.correct_estimate(2).should be_nil
    end

    it "should return the distance of correct estimate for the given leg" do
      @relay.relay_correct_estimates << Factory.build(:relay_correct_estimate,
        :relay => @relay, :leg => 2, :distance => 111)
      @relay.correct_estimate(2).should == 111
    end
  end

  describe "results" do
    before do
      @relay = Factory.create(:relay, :legs_count => 3, :start_time => '12:00')
    end

    context "when no teams" do
      describe "#results" do
        it "should return empty array" do
          @relay.results.should == []
        end
      end

      describe "#leg_results" do
        it "should return empty array" do
          @relay.leg_results(1).should == []
        end
      end
    end

    context "when teams" do
      before do
        @team2 = create_team(2)
        @team1 = create_team(1)
        @team3 = create_team(3)
        create_competitor @team1, 1, '12:13:16'
        create_competitor @team2, 1, '12:13:15'
        create_competitor @team3, 1, '12:13:14'
        create_competitor @team1, 2, '12:24:15'
        create_competitor @team2, 2, '12:24:14'
        create_competitor @team3, 2, '12:24:16'
        create_competitor @team1, 3, '12:35:14'
        create_competitor @team2, 3, '12:35:15'
        create_competitor @team3, 3, '12:35:16'
      end

      describe "#results" do
        it "should return the teams based on the fastest arrival time of the " +
            "competitors for the last leg" do
          @relay.results.should == [@team1, @team2, @team3]
        end
      end

      describe "#leg_results" do
        it "should return the teams based on the fastest arrival time of the " +
            "competitors for the given leg" do
          @relay.leg_results(1).should == [@team3, @team2, @team1]
          @relay.leg_results(2).should == [@team2, @team1, @team3]
          @relay.leg_results(3).should == [@team1, @team2, @team3]
        end
      end

      def create_team(number)
        Factory.create(:relay_team, :relay => @relay, :name => "Team #{number}",
          :number => number)
      end

      def create_competitor(team, leg, arrival_time)
        Factory.create(:relay_competitor, :relay_team => team, :leg => leg,
          :arrival_time => arrival_time)
      end
    end
  end

  describe "#finish_errors" do
    before do
      @relay = Factory.create(:relay, :start_time => '12:00', :legs_count => 2)
      team1 = Factory.create(:relay_team, :relay => @relay, :number => 1)
      team2 = Factory.create(:relay_team, :relay => @relay, :number => 2)
      Factory.create(:relay_competitor, :relay_team => team1, :leg => 1,
        :estimate => 100, :misses => 1, :arrival_time => '12:15')
      Factory.create(:relay_competitor, :relay_team => team1, :leg => 2,
        :estimate => 100, :misses => 1, :arrival_time => '12:30')
      Factory.create(:relay_competitor, :relay_team => team2, :leg => 1,
        :estimate => 100, :misses => 1, :arrival_time => '12:15')
      Factory.create(:relay_competitor, :relay_team => team2, :leg => 2,
        :estimate => 100, :misses => 1, :arrival_time => '12:30')
      Factory.create(:relay_correct_estimate, :relay => @relay, :distance => 90, :leg => 1)
      Factory.create(:relay_correct_estimate, :relay => @relay, :distance => 90, :leg => 2)
    end

    context "when all the necessary data is there" do
      it "should return an empty array" do
        @relay.reload
        @relay.finish_errors.should be_empty
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
        @relay.stub!(:relay_teams).and_return([])
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
        @relay.stub!(:relay_correct_estimates).and_return([])
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
      @relay.finish_errors.should_not be_empty
    end
  end

  describe "#finish" do
    before do
      @relay = Factory.create(:relay)
    end

    context "when the relay can be finished" do
      it "should mark the race as finished and return true" do
        @relay.should_receive(:finish_errors).and_return([])
        @relay.finish.should be_true
        @relay.should have(0).errors
        @relay.reload
        @relay.should be_finished
      end
    end

    context "when the relay cannot be finished" do
      it "should not mark the race as finished and return false" do
        @relay.should_receive(:finish_errors).and_return(['error'])
        @relay.finish.should be_false
        @relay.should have(1).errors
        @relay.reload
        @relay.should_not be_finished
      end
    end
  end

  describe "#finish!" do
    before do
      @relay = Factory.build(:relay)
    end

    it "should return true when finishing the relay succeeds" do
      @relay.should_receive(:finish).and_return(true)
      @relay.finish!.should be_true
    end

    it "should raise exception if finishing the relay fails" do
      @relay.should_receive(:finish).and_return(false)
      lambda { @relay.finish! }.should raise_error
    end
  end
end
