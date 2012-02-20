require 'spec_helper'

describe AgeGroup do
  it "should create age_group with valid attrs" do
    Factory.create(:age_group)
  end

  describe "validation" do
    it "should require name" do
      Factory.build(:age_group, :name => nil).should have(1).errors_on(:name)
    end

    describe "min_competitors" do
      it "should change nil to 0" do
        ag = Factory.create(:age_group, :min_competitors => nil)
        ag.min_competitors.should == 0
      end

      it "should require number" do
        Factory.build(:age_group, :min_competitors => 'xxx').
          should have(1).errors_on(:min_competitors)
      end

      it "should require integer" do
        Factory.build(:age_group, :min_competitors => 1.1).
          should have(1).errors_on(:min_competitors)
      end

      it "should require non-negative number" do
        Factory.build(:age_group, :min_competitors => -1).
          should have(1).errors_on(:min_competitors)
      end
    end
  end

end
