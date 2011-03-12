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
end
