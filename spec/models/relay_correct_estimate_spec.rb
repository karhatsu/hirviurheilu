require 'spec_helper'

describe RelayCorrectEstimate do
  it "create" do
    Factory.create :relay_correct_estimate
  end

  describe "associations" do
    it { should belong_to(:relay) }
  end

  describe "validations" do
    describe "distance" do
      it { should validate_numericality_of(:distance) }
      it { should_not allow_value(nil).for(:distance) }
      it { should_not allow_value(49).for(:distance) }
      it { should allow_value(50).for(:distance) }
      it { should allow_value(200).for(:distance) }
      it { should_not allow_value(201).for(:distance) }
      it { should_not allow_value(1.1).for(:distance) }
    end
  end
end
