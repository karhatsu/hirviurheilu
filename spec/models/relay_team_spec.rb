require 'spec_helper'

describe RelayTeam do
  it "create" do
    Factory.create(:relay_team)
  end

  describe "associations" do
    it { should belong_to(:relay) }
    it { should have_many(:relay_competitors) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }

    describe "number" do
      it { should validate_numericality_of(:number) }
      it { should_not allow_value(0).for(:number) }
      it { should allow_value(1).for(:number) }
      it { should_not allow_value(1.1).for(:number) }

      describe "uniqueness" do
        before do
          Factory.create(:relay_team)
        end
        it { should validate_uniqueness_of(:number).scoped_to(:relay_id) }
      end
    end
  end

  describe "competitors" do
    before do
      @team = Factory.create(:relay_team)
      @team.relay_competitors << Factory.build(:relay_competitor,
        :relay_team => @team, :leg => 3)
      @team.relay_competitors << Factory.build(:relay_competitor,
        :relay_team => @team, :leg => 1)
      @team.relay_competitors << Factory.build(:relay_competitor,
        :relay_team => @team, :leg => 2)
      @team.reload
    end

    it "should be ordered by leg number" do
      @team.relay_competitors[0].leg.should == 1
      @team.relay_competitors[1].leg.should == 2
      @team.relay_competitors[2].leg.should == 3
    end
  end
end
