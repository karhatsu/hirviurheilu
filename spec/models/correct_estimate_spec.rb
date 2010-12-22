require 'spec_helper'

describe CorrectEstimate do
  it "create" do
    Factory.create(:correct_estimate)
  end

  describe "validations" do
    it { should validate_presence_of(:race) }

    describe "min_number" do
      it { should validate_numericality_of(:min_number) }
      it { should_not allow_value(nil).for(:min_number) }
      it { should_not allow_value(-1).for(:min_number) }
      it { should_not allow_value(0).for(:min_number) }
      it { should_not allow_value(1.1).for(:min_number) }
    end

    describe "min_number" do
      it { should validate_numericality_of(:max_number) }
      it { should allow_value(nil).for(:max_number) } # note!
      it { should_not allow_value(-1).for(:max_number) }
      it { should_not allow_value(0).for(:max_number) }
      it { should_not allow_value(1.1).for(:max_number) }
    end

    describe "min_number" do
      it { should validate_numericality_of(:distance1) }
      it { should_not allow_value(nil).for(:distance1) }
      it { should_not allow_value(-1).for(:distance1) }
      it { should_not allow_value(0).for(:distance1) }
      it { should_not allow_value(1.1).for(:distance1) }
    end

    describe "min_number" do
      it { should validate_numericality_of(:distance2) }
      it { should_not allow_value(nil).for(:distance2) }
      it { should_not allow_value(-1).for(:distance2) }
      it { should_not allow_value(0).for(:distance2) }
      it { should_not allow_value(1.1).for(:distance2) }
    end

    describe "overlapping numbers" do
      before do
        @race1 = Factory.create(:race)
        @race2 = Factory.create(:race)
        @ce = Factory.create(:correct_estimate, :race => @race1, :min_number => 5,
          :max_number => 10)
      end

      it "should allow same numbers for different race" do
        Factory.create(:correct_estimate, :race => @race2, :min_number => 5,
          :max_number => 10)
      end

      it "should prevent overlapping numbers for same race" do
        Factory.build(:correct_estimate, :race => @race1, :min_number => 1,
          :max_number => 5).should_not be_valid
        Factory.build(:correct_estimate, :race => @race1, :min_number => 10,
          :max_number => 15).should_not be_valid
        Factory.create(:correct_estimate, :race => @race1, :min_number => 15,
          :max_number => 20)
        Factory.build(:correct_estimate, :race => @race1, :min_number => 11,
          :max_number => 14).should be_valid
        Factory.build(:correct_estimate, :race => @race1, :min_number => 11,
          :max_number => 15).should_not be_valid
      end

      describe "saving max_number=nil" do
        it "should prevent overlapping min number" do
          Factory.build(:correct_estimate, :race => @race1, :min_number => 4,
            :max_number => nil).should_not be_valid
          Factory.build(:correct_estimate, :race => @race1, :min_number => 10,
            :max_number => nil).should_not be_valid
        end
      end

      describe "existing max_number=nil" do
        before do
          @ce_nil = Factory.create(:correct_estimate, :race => @race1, :min_number => 50,
            :max_number => nil)
        end

        it "should allow another nil for different race" do
          Factory.create(:correct_estimate, :race => @race2, :min_number => 50,
            :max_number => nil)
        end

        it "should prevent another nil for same race" do
          Factory.build(:correct_estimate, :race => @race1, :min_number => 100,
            :max_number => nil).should have(1).errors_on(:max_number)
        end

        it "should allow updating numbers" do
          @ce_nil.min_number = 51
          @ce_nil.should be_valid
        end
      end

      it "should allow updating numbers" do
        @ce.min_number = 6
        @ce.should be_valid
      end
    end
  end
end
