require 'spec_helper'

describe RelayCompetitor do
  it "create" do
    Factory.create(:relay_competitor)
  end

  describe "associations" do
    it { should belong_to(:relay_team) }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    describe "leg" do
      it { should validate_numericality_of(:leg) }
      it { should_not allow_value(0).for(:leg) }
      it { should allow_value(1).for(:leg) }
      it { should_not allow_value(1.1).for(:leg) }
      it "should not allow bigger leg value than relay legs count" do
        relay = Factory.build(:relay, :legs => 3)
        team = Factory.build(:relay_team, :relay => relay)
        competitor = Factory.build(:relay_competitor, :relay_team => team, :leg => 3)
        competitor.should be_valid
        competitor.leg = 4
        competitor.should have(1).errors_on(:leg)
      end
    end

    describe "misses" do
      it { should validate_numericality_of(:misses) }
      it { should allow_value(nil).for(:misses) }
      it { should_not allow_value(0).for(:misses) }
      it { should allow_value(1).for(:misses) }
      it { should_not allow_value(1.1).for(:misses) }
      it { should allow_value(5).for(:misses) }
      it { should_not allow_value(6).for(:misses) }
    end
  end
end
