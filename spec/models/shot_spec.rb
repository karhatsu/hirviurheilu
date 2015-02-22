require 'spec_helper'

describe Shot do
  it "should create shot with valid attrs" do
    FactoryGirl.create(:shot)
  end

  describe "associations" do
    it { is_expected.to belong_to(:competitor) }
  end

  describe "validation" do
    #it { should validate_presence_of(:competitor) }

    describe "value" do
      it { is_expected.to validate_numericality_of(:value) }
      it { is_expected.to allow_value(nil).for(:value) }
      it { is_expected.not_to allow_value(1.1).for(:value) }
      it { is_expected.not_to allow_value(-1).for(:value) }
      it { is_expected.to allow_value(0).for(:value) }
      it { is_expected.to allow_value(10).for(:value) }
      it { is_expected.not_to allow_value(11).for(:value) }
    end
  end
end
