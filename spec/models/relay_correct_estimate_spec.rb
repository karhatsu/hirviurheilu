require 'spec_helper'

describe RelayCorrectEstimate do
  it "create" do
    FactoryGirl.create :relay_correct_estimate
  end

  describe "associations" do
    it { should belong_to(:relay) }
  end

  describe "validations" do
    describe "distance" do
      it { should validate_numericality_of(:distance) }
      it { should allow_value(nil).for(:distance) }
      it { should_not allow_value(49).for(:distance) }
      it { should allow_value(50).for(:distance) }
      it { should allow_value(200).for(:distance) }
      it { should_not allow_value(201).for(:distance) }
      it { should_not allow_value(1.1).for(:distance) }
    end

    describe "leg" do
      it { should validate_numericality_of(:leg) }
      it { should_not allow_value(0).for(:leg) }
      it { should allow_value(1).for(:leg) }
      it { should_not allow_value(1.1).for(:leg) }
      it "should not allow bigger leg value than relay legs count" do
        relay = FactoryGirl.build(:relay, :legs_count => 3)
        ce = FactoryGirl.build(:relay_correct_estimate, :relay => relay, :leg => 3)
        ce.should be_valid
        ce.leg = 4
        ce.should have(1).errors_on(:leg)
      end

      describe "uniqueness" do
        before do
          FactoryGirl.create(:relay_correct_estimate)
        end
        it { should validate_uniqueness_of(:leg).scoped_to(:relay_id) }
      end
    end
  end
end
