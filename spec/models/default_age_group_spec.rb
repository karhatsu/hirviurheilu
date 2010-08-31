require 'spec_helper'

describe DefaultAgeGroup do
  specify { Factory.create(:default_age_group) }

  describe "validation" do
    it "should require name" do
      Factory.build(:default_age_group, :name => nil).should have(1).errors_on(:name)
    end

    describe "min_competitors" do
      it "should change nil to 0" do
        ag = Factory.create(:default_age_group, :min_competitors => nil)
        ag.min_competitors.should == 0
      end

      it "should require number" do
        Factory.build(:default_age_group, :min_competitors => 'xxx').
          should have(1).errors_on(:min_competitors)
      end

      it "should require integer" do
        Factory.build(:default_age_group, :min_competitors => 1.1).
          should have(1).errors_on(:min_competitors)
      end

      it "should require non-negative number" do
        Factory.build(:default_age_group, :min_competitors => -1).
          should have(1).errors_on(:min_competitors)
      end
    end
  end
end
