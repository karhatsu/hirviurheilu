require 'spec_helper'

describe BasePrice do
  describe "create" do
    it "should create base price" do
      FactoryGirl.create(:base_price)
    end

    it "should prevent creating two base prices" do
      FactoryGirl.create(:base_price)
      FactoryGirl.build(:base_price).should_not be_valid
    end

    it "should allow updating the only base price" do
      bp = FactoryGirl.create(:base_price)
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

  describe "#self.price" do
    before do
      FactoryGirl.create(:base_price, :price => 17)
    end

    it "should return the base price" do
      BasePrice.price.should == 17
    end
  end
end
