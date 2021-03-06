require 'spec_helper'

describe CorrectEstimate do
  it "create" do
    create(:correct_estimate)
  end

  describe "associations" do
    it { is_expected.to belong_to(:race) }
  end

  describe "validations" do
    #it { should validate_presence_of(:race) }

    it_should_behave_like 'non-negative integer', :min_number, false
    it_should_behave_like 'non-negative integer', :max_number, true

    describe "distance1" do
      it { is_expected.to validate_numericality_of(:distance1) }
      it { is_expected.not_to allow_value(nil).for(:distance1) }
      it { is_expected.not_to allow_value(49).for(:distance1) }
      it { is_expected.to allow_value(50).for(:distance1) }
      it { is_expected.to allow_value(200).for(:distance1) }
      it { is_expected.not_to allow_value(201).for(:distance1) }
      it { is_expected.not_to allow_value(1.1).for(:distance1) }
    end

    describe "distance2" do
      it { is_expected.to validate_numericality_of(:distance2) }
      it { is_expected.not_to allow_value(nil).for(:distance2) }
      it { is_expected.not_to allow_value(49).for(:distance2) }
      it { is_expected.to allow_value(50).for(:distance2) }
      it { is_expected.to allow_value(200).for(:distance2) }
      it { is_expected.not_to allow_value(201).for(:distance2) }
      it { is_expected.not_to allow_value(1.1).for(:distance2) }
    end

    describe "distance3" do
      it { is_expected.to validate_numericality_of(:distance3) }
      it { is_expected.to allow_value(nil).for(:distance3) } # note!
      it { is_expected.not_to allow_value(49).for(:distance3) }
      it { is_expected.to allow_value(50).for(:distance3) }
      it { is_expected.to allow_value(200).for(:distance3) }
      it { is_expected.not_to allow_value(201).for(:distance3) }
      it { is_expected.not_to allow_value(1.1).for(:distance3) }
    end

    describe "distance4" do
      it { is_expected.to validate_numericality_of(:distance4) }
      it { is_expected.to allow_value(nil).for(:distance4) } # note!
      it { is_expected.not_to allow_value(49).for(:distance4) }
      it { is_expected.to allow_value(50).for(:distance4) }
      it { is_expected.to allow_value(200).for(:distance4) }
      it { is_expected.not_to allow_value(201).for(:distance4) }
      it { is_expected.not_to allow_value(1.1).for(:distance4) }
    end

    describe "overlapping numbers" do
      before do
        @race1 = create(:race)
        @race2 = create(:race)
        @ce = create(:correct_estimate, :race => @race1, :min_number => 5,
          :max_number => 10)
      end

      it "should allow same numbers for different race" do
        create(:correct_estimate, :race => @race2, :min_number => 5,
          :max_number => 10)
      end

      it "should prevent overlapping numbers for same race" do
        expect(build(:correct_estimate, :race => @race1, :min_number => 1,
          :max_number => 5)).not_to be_valid
        expect(build(:correct_estimate, :race => @race1, :min_number => 10,
          :max_number => 15)).not_to be_valid
        create(:correct_estimate, :race => @race1, :min_number => 15,
          :max_number => 20)
        expect(build(:correct_estimate, :race => @race1, :min_number => 11,
          :max_number => 14)).to be_valid
        expect(build(:correct_estimate, :race => @race1, :min_number => 11,
          :max_number => 15)).not_to be_valid
      end

      describe "saving max_number=nil" do
        it "should prevent overlapping min number" do
          expect(build(:correct_estimate, :race => @race1, :min_number => 4,
            :max_number => nil)).not_to be_valid
          expect(build(:correct_estimate, :race => @race1, :min_number => 10,
            :max_number => nil)).not_to be_valid
        end
      end

      describe "existing max_number=nil" do
        before do
          @ce_nil = create(:correct_estimate, :race => @race1, :min_number => 50,
            :max_number => nil)
        end

        it "should allow another nil for different race" do
          create(:correct_estimate, :race => @race2, :min_number => 50,
            :max_number => nil)
        end

        it "should prevent another nil for same race" do
          expect(build(:correct_estimate, :race => @race1, :min_number => 100,
            :max_number => nil)).to have(1).errors_on(:max_number)
        end

        it "should allow updating numbers" do
          @ce_nil.min_number = 51
          expect(@ce_nil).to be_valid
        end
      end

      it "should allow updating numbers" do
        @ce.min_number = 6
        expect(@ce).to be_valid
      end
    end
  end

  describe "#for_number_in_race" do
    before do
      another_race = create(:race)
      another_race.correct_estimates << build(:correct_estimate,
        :race => another_race, :min_number => 1)
      @race = create(:race)
    end

    it "should return nil if nothing found" do
      expect(CorrectEstimate.for_number_in_race(10, @race)).to be_nil
    end

    context "when correct estimate defined" do
      before do
        @ce1 = build(:correct_estimate,
          :race => @race, :min_number => 5, :max_number => 7)
        @ce2 = build(:correct_estimate,
          :race => @race, :min_number => 9, :max_number => 11)
        @ce3 = build(:correct_estimate,
          :race => @race, :min_number => 14, :max_number => nil)
        @race.correct_estimates << @ce1
        @race.correct_estimates << @ce2
        @race.correct_estimates << @ce3
      end

      it "should return the correct estimates (case middle)" do
        expect(CorrectEstimate.for_number_in_race(6, @race)).to eq(@ce1)
        expect(CorrectEstimate.for_number_in_race(10, @race)).to eq(@ce2)
      end

      it "should return the correct estimates (case lower bound)" do
        expect(CorrectEstimate.for_number_in_race(5, @race)).to eq(@ce1)
        expect(CorrectEstimate.for_number_in_race(9, @race)).to eq(@ce2)
        expect(CorrectEstimate.for_number_in_race(14, @race)).to eq(@ce3)
      end

      it "should return the correct estimates (case upper bound)" do
        expect(CorrectEstimate.for_number_in_race(7, @race)).to eq(@ce1)
        expect(CorrectEstimate.for_number_in_race(11, @race)).to eq(@ce2)
      end

      it "should return the correct estimates (case nil max number)" do
        expect(CorrectEstimate.for_number_in_race(15, @race)).to eq(@ce3)
      end
    end
  end
end
