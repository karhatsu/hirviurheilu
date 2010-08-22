require 'spec_helper'

describe Shot do
  it "should create shot with valid attrs" do
    Factory.create(:shot)
  end

  describe "validation" do
    it "should require competitor" do
      Factory.build(:shot, :competitor => nil).should have(1).errors_on(:competitor)
    end

    describe "value" do
      it "can be nil" do
        Factory.build(:shot, :value => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:shot, :value => 1.1).
          should have(1).errors_on(:value)
      end

      it "should be non-negative" do
        Factory.build(:shot, :value => -1).
          should have(1).errors_on(:value)
      end

      it "should be at maximum 10" do
        Factory.build(:shot, :value => 11).
          should have(1).errors_on(:value)
      end
    end
  end
end
