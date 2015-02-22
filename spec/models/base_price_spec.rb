require 'spec_helper'

describe BasePrice do
  describe "create" do
    it "should create base price" do
      FactoryGirl.create(:base_price)
    end

    it "should prevent creating two base prices" do
      FactoryGirl.create(:base_price)
      expect(FactoryGirl.build(:base_price)).not_to be_valid
    end

    it "should allow updating the only base price" do
      bp = FactoryGirl.create(:base_price)
      bp.price = 30
      expect(bp.save).to be_truthy
    end
  end

  describe "validations" do
    it { is_expected.to validate_numericality_of(:price) }
    it { is_expected.not_to allow_value(-1).for(:price) }
    it { is_expected.to allow_value(0).for(:price) }
    it { is_expected.not_to allow_value(1.1).for(:price) }
  end

  describe "#self.price" do
    before do
      FactoryGirl.create(:base_price, :price => 17)
    end

    it "should return the base price" do
      expect(BasePrice.price).to eq(17)
    end
  end
end
