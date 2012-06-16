require 'spec_helper'

describe Price do
  it "create" do
    FactoryGirl.create(:price)
  end

  describe "validations" do
    describe "min_competitors" do
      it { should validate_numericality_of(:min_competitors) }
      it { should_not allow_value(-1).for(:min_competitors) }
      it { should_not allow_value(0).for(:min_competitors) }
      it { should_not allow_value(1.1).for(:min_competitors) }
      it { should allow_value(1).for(:min_competitors) }
    end
    describe "price" do
      it { should validate_numericality_of(:price) }
      it { should_not allow_value(-1).for(:price) }
      it { should allow_value(0).for(:price) }
      it { should allow_value(0.1).for(:price) }
      it { should allow_value(1).for(:price) }
    end
  end
  
  describe "default sort order" do
    before do
      FactoryGirl.create(:price, :min_competitors => 100)
      FactoryGirl.create(:price, :min_competitors => 1)
      FactoryGirl.create(:price, :min_competitors => 50)
    end
    
    it "should be by min competitors" do
      Price.all.collect {|price| price.min_competitors}.should == [1, 50, 100]
    end
  end

  describe "#price_for_competitor_amount" do
    before do
      FactoryGirl.create(:base_price, :price => 20)
      FactoryGirl.create(:price, :min_competitors => 20, :price => 0.5)
      FactoryGirl.create(:price, :min_competitors => 1, :price => 1.5)
      FactoryGirl.create(:price, :min_competitors => 10, :price => 1.0)
    end

    specify { Price.price_for_competitor_amount(1).should == 20 + 1.5 }
    specify { Price.price_for_competitor_amount(9).should == 20 + 9 * 1.5 }
    specify { Price.price_for_competitor_amount(10).should == 20 + 10 * 1 }
    specify { Price.price_for_competitor_amount(19).should == 20 + 19 * 1 }
    specify { Price.price_for_competitor_amount(20).should == 20 + 20 * 0.5 }
    specify { Price.price_for_competitor_amount(100).should == 20 + 100 * 0.5 }
  end

  describe "#max_competitors" do
    before do
      @price3 = FactoryGirl.create(:price, :min_competitors => 20, :price => 0.5)
      @price1 = FactoryGirl.create(:price, :min_competitors => 1, :price => 1.5)
      @price2 = FactoryGirl.create(:price, :min_competitors => 10, :price => 1.0)
    end

    specify { @price1.max_competitors.should == 9 }
    specify { @price2.max_competitors.should == 19 }
    specify { @price3.max_competitors.should == nil }
  end
end
