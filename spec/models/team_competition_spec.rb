require 'spec_helper'

describe TeamCompetition do
  it "create" do
    Factory.create(:team_competition)
  end

  describe "associations" do
    it { should belong_to(:race) }
    it { should have_and_belong_to_many(:series) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }

    describe "team_competitor_count" do
      it { should validate_numericality_of(:team_competitor_count) }
      it { should_not allow_value(nil).for(:team_competitor_count) }
      it { should_not allow_value(0).for(:team_competitor_count) }
      it { should_not allow_value(1).for(:team_competitor_count) }
      it { should allow_value(2).for(:team_competitor_count) }
      it { should_not allow_value(2.1).for(:team_competitor_count) }
    end
  end
end
