require 'spec_helper'

describe Shot do
  it "should create shot with valid attrs" do
    Factory.create(:shot)
  end

  describe "associations" do
    it { should belong_to(:competitor) }
  end

  describe "validation" do
    #it { should validate_presence_of(:competitor) }

    describe "value" do
      it { should validate_numericality_of(:value) }
      it { should allow_value(nil).for(:value) }
      it { should_not allow_value(1.1).for(:value) }
      it { should_not allow_value(-1).for(:value) }
      it { should allow_value(0).for(:value) }
      it { should allow_value(10).for(:value) }
      it { should_not allow_value(11).for(:value) }
    end
  end
end
