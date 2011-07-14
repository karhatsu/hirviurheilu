require 'spec_helper'

describe CorrectEstimate do
  it "create" do
    Factory.create(:correct_estimate)
  end

  describe "associations" do
    it { should belong_to(:race) }
  end

  describe "validations" do
    #it { should validate_presence_of(:race) }

    describe "min_number" do
      it { should validate_numericality_of(:min_number) }
      it { should_not allow_value(nil).for(:min_number) }
      it { should_not allow_value(-1).for(:min_number) }
      it { should_not allow_value(0).for(:min_number) }
      it { should_not allow_value(1.1).for(:min_number) }
    end

    describe "max_number" do
      it { should validate_numericality_of(:max_number) }
      it { should allow_value(nil).for(:max_number) } # note!
      it { should_not allow_value(-1).for(:max_number) }
      it { should_not allow_value(0).for(:max_number) }
      it { should_not allow_value(1.1).for(:max_number) }
    end

    describe "distance1" do
      it { should validate_numericality_of(:distance1) }
      it { should_not allow_value(nil).for(:distance1) }
      it { should_not allow_value(49).for(:distance1) }
      it { should allow_value(50).for(:distance1) }
      it { should allow_value(200).for(:distance1) }
      it { should_not allow_value(201).for(:distance1) }
      it { should_not allow_value(1.1).for(:distance1) }
    end

    describe "distance2" do
      it { should validate_numericality_of(:distance2) }
      it { should_not allow_value(nil).for(:distance2) }
      it { should_not allow_value(49).for(:distance2) }
      it { should allow_value(50).for(:distance2) }
      it { should allow_value(200).for(:distance2) }
      it { should_not allow_value(201).for(:distance2) }
      it { should_not allow_value(1.1).for(:distance2) }
    end

    describe "distance3" do
      it { should validate_numericality_of(:distance3) }
      it { should allow_value(nil).for(:distance3) } # note!
      it { should_not allow_value(49).for(:distance3) }
      it { should allow_value(50).for(:distance3) }
      it { should allow_value(200).for(:distance3) }
      it { should_not allow_value(201).for(:distance3) }
      it { should_not allow_value(1.1).for(:distance3) }
    end

    describe "distance4" do
      it { should validate_numericality_of(:distance4) }
      it { should allow_value(nil).for(:distance4) } # note!
      it { should_not allow_value(49).for(:distance4) }
      it { should allow_value(50).for(:distance4) }
      it { should allow_value(200).for(:distance4) }
      it { should_not allow_value(201).for(:distance4) }
      it { should_not allow_value(1.1).for(:distance4) }
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

  describe "#for_number_in_race" do
    before do
      another_race = Factory.create(:race)
      another_race.correct_estimates << Factory.build(:correct_estimate,
        :race => another_race, :min_number => 1)
      @race = Factory.create(:race)
    end

    it "should return nil if nothing found" do
      CorrectEstimate.for_number_in_race(10, @race).should be_nil
    end

    context "when correct estimate defined" do
      before do
        @ce1 = Factory.build(:correct_estimate,
          :race => @race, :min_number => 5, :max_number => 7)
        @ce2 = Factory.build(:correct_estimate,
          :race => @race, :min_number => 9, :max_number => 11)
        @ce3 = Factory.build(:correct_estimate,
          :race => @race, :min_number => 14, :max_number => nil)
        @race.correct_estimates << @ce1
        @race.correct_estimates << @ce2
        @race.correct_estimates << @ce3
      end

      it "should return the correct estimates (case middle)" do
        CorrectEstimate.for_number_in_race(6, @race).should == @ce1
        CorrectEstimate.for_number_in_race(10, @race).should == @ce2
      end

      it "should return the correct estimates (case lower bound)" do
        CorrectEstimate.for_number_in_race(5, @race).should == @ce1
        CorrectEstimate.for_number_in_race(9, @race).should == @ce2
        CorrectEstimate.for_number_in_race(14, @race).should == @ce3
      end

      it "should return the correct estimates (case upper bound)" do
        CorrectEstimate.for_number_in_race(7, @race).should == @ce1
        CorrectEstimate.for_number_in_race(11, @race).should == @ce2
      end

      it "should return the correct estimates (case nil max number)" do
        CorrectEstimate.for_number_in_race(15, @race).should == @ce3
      end
    end
  end
end
