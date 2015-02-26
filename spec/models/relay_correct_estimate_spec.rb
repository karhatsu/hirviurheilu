require 'spec_helper'

describe RelayCorrectEstimate do
  it "create" do
    create :relay_correct_estimate
  end

  describe "associations" do
    it { is_expected.to belong_to(:relay) }
  end

  describe "validations" do
    describe "distance" do
      it { is_expected.to validate_numericality_of(:distance) }
      it { is_expected.to allow_value(nil).for(:distance) }
      it { is_expected.not_to allow_value(49).for(:distance) }
      it { is_expected.to allow_value(50).for(:distance) }
      it { is_expected.to allow_value(200).for(:distance) }
      it { is_expected.not_to allow_value(201).for(:distance) }
      it { is_expected.not_to allow_value(1.1).for(:distance) }
    end

    describe "leg" do
      it { is_expected.to validate_numericality_of(:leg) }
      it { is_expected.not_to allow_value(0).for(:leg) }
      it { is_expected.to allow_value(1).for(:leg) }
      it { is_expected.not_to allow_value(1.1).for(:leg) }
      it "should not allow bigger leg value than relay legs count" do
        relay = build(:relay, :legs_count => 3)
        ce = build(:relay_correct_estimate, :relay => relay, :leg => 3)
        expect(ce).to be_valid
        ce.leg = 4
        expect(ce).to have(1).errors_on(:leg)
      end

      describe "uniqueness" do
        before do
          create(:relay_correct_estimate)
        end
        it { is_expected.to validate_uniqueness_of(:leg).scoped_to(:relay_id) }
      end
    end
  end
end
