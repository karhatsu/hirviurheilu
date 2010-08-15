require 'spec_helper'

describe Result do
  describe "create" do
    it "should create new result with valid attrs" do
      Factory.create(:result)
    end
  end

  describe "validation" do
    describe "shots_total_input" do
      it "can be nil" do
        Factory.build(:result, :shots_total_input => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :shots_total_input => 1.1).
          should have(1).errors_on(:shots_total_input)
      end

      it "should be non-negative" do
        Factory.build(:result, :shots_total_input => -1).
          should have(1).errors_on(:shots_total_input)
      end

      it "should be at maximum 100" do
        Factory.build(:result, :shots_total_input => 101).
          should have(1).errors_on(:shots_total_input)
      end
    end

    describe "estimate1" do
      it "can be nil" do
        Factory.build(:result, :estimate1 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :estimate1 => 1.1).
          should have(1).errors_on(:estimate1)
      end

      it "should be non-negative" do
        Factory.build(:result, :estimate1 => -1).
          should have(1).errors_on(:estimate1)
      end
    end

    describe "estimate2" do
      it "can be nil" do
        Factory.build(:result, :estimate2 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :estimate2 => 1.1).
          should have(1).errors_on(:estimate2)
      end

      it "should be non-negative" do
        Factory.build(:result, :estimate2 => -1).
          should have(1).errors_on(:estimate2)
      end
    end

    describe "arrival" do
      it "can be nil" do
        Factory.build(:result, :arrival => nil).should be_valid
      end

      it "is valid when at least same as start time" do
        comp = Factory.build(:competitor, :start_time => '14:00')
        Factory.build(:result, :competitor => comp, :arrival => '14:00').
          should be_valid
      end

      it "should not be before competitor's start time" do
        comp = Factory.build(:competitor, :start_time => '14:00')
        Factory.build(:result, :competitor => comp, :arrival => '13:59').
          should have(1).errors_on(:arrival)
      end
    end
  end
end
