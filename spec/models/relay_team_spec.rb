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
end
