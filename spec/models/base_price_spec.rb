require 'spec_helper'

describe BasePrice do
  describe "create" do
    it "should create base price" do
      Factory.create(:base_price)
    end

    it "should prevent creating two base prices" do
      Factory.create(:base_price)
      Factory.build(:base_price).should_not be_valid
    end

    it "should allow updating the only base price" do
      bp = Factory.create(:base_price)
      bp.price = 30
      bp.save.should be_true
    end
  end

  describe "validations" do
    it { should validate_numericality_of(:price) }
    it { should_not allow_value(-1).for(:price) }
    it { should allow_value(0).for(:price) }
    it { should_not allow_value(1.1).for(:price) }
  end
end
