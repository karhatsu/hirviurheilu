require 'spec_helper'

describe Price do
  it "create" do
    create(:price)
  end

  describe "validations" do
    describe "min_competitors" do
      it { is_expected.to validate_numericality_of(:min_competitors) }
      it { is_expected.not_to allow_value(-1).for(:min_competitors) }
      it { is_expected.not_to allow_value(0).for(:min_competitors) }
      it { is_expected.not_to allow_value(1.1).for(:min_competitors) }
      it { is_expected.to allow_value(1).for(:min_competitors) }
    end
    describe "price" do
      it { is_expected.to validate_numericality_of(:price) }
      it { is_expected.not_to allow_value(-1).for(:price) }
      it { is_expected.to allow_value(0).for(:price) }
      it { is_expected.to allow_value(0.1).for(:price) }
      it { is_expected.to allow_value(1).for(:price) }
    end
  end
  
  describe "default sort order" do
    before do
      create(:price, :min_competitors => 100)
      create(:price, :min_competitors => 1)
      create(:price, :min_competitors => 50)
    end
    
    it "should be by min competitors" do
      expect(Price.all.collect {|price| price.min_competitors}).to eq([1, 50, 100])
    end
  end

  describe "#price_for_competitor_amount" do
    before do
      create(:base_price, :price => 20)
      create(:price, :min_competitors => 20, :price => 0.5)
      create(:price, :min_competitors => 1, :price => 1.5)
      create(:price, :min_competitors => 10, :price => 1.0)
    end

    specify { expect(Price.price_for_competitor_amount(1)).to eq(20 + 1.5) }
    specify { expect(Price.price_for_competitor_amount(9)).to eq(20 + 9 * 1.5) }
    specify { expect(Price.price_for_competitor_amount(10)).to eq(20 + 10 * 1) }
    specify { expect(Price.price_for_competitor_amount(19)).to eq(20 + 19 * 1) }
    specify { expect(Price.price_for_competitor_amount(20)).to eq(20 + 20 * 0.5) }
    specify { expect(Price.price_for_competitor_amount(100)).to eq(20 + 100 * 0.5) }
  end

  describe "#max_competitors" do
    before do
      @price3 = create(:price, :min_competitors => 20, :price => 0.5)
      @price1 = create(:price, :min_competitors => 1, :price => 1.5)
      @price2 = create(:price, :min_competitors => 10, :price => 1.0)
    end

    specify { expect(@price1.max_competitors).to eq(9) }
    specify { expect(@price2.max_competitors).to eq(19) }
    specify { expect(@price3.max_competitors).to eq(nil) }
  end
end
