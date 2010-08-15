require 'spec_helper'

describe Result do
  describe "create" do
    it "should create new result with valid attrs" do
      Factory.create(:result)
    end
  end

  describe "validation" do
    describe "shot1" do
      it "can be nil" do
        Factory.build(:result, :shot1 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :shot1 => 1.1).
          should have(1).errors_on(:shot1)
      end

      it "should be non-negative" do
        Factory.build(:result, :shot1 => -1).
          should have(1).errors_on(:shot1)
      end

      it "should be at maximum 10" do
        Factory.build(:result, :shot1 => 11).
          should have(1).errors_on(:shot1)
      end
    end

    describe "shot2" do
      it "can be nil" do
        Factory.build(:result, :shot2 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :shot2 => 1.1).
          should have(1).errors_on(:shot2)
      end

      it "should be non-negative" do
        Factory.build(:result, :shot2 => -1).
          should have(1).errors_on(:shot2)
      end

      it "should be at maximum 10" do
        Factory.build(:result, :shot2 => 11).
          should have(1).errors_on(:shot2)
      end
    end

    describe "shot3" do
      it "can be nil" do
        Factory.build(:result, :shot3 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :shot3 => 1.1).
          should have(1).errors_on(:shot3)
      end

      it "should be non-negative" do
        Factory.build(:result, :shot3 => -1).
          should have(1).errors_on(:shot3)
      end

      it "should be at maximum 10" do
        Factory.build(:result, :shot3 => 11).
          should have(1).errors_on(:shot3)
      end
    end

    describe "shot4" do
      it "can be nil" do
        Factory.build(:result, :shot4 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :shot4 => 1.1).
          should have(1).errors_on(:shot4)
      end

      it "should be non-negative" do
        Factory.build(:result, :shot4 => -1).
          should have(1).errors_on(:shot4)
      end

      it "should be at maximum 10" do
        Factory.build(:result, :shot4 => 11).
          should have(1).errors_on(:shot4)
      end
    end

    describe "shot5" do
      it "can be nil" do
        Factory.build(:result, :shot5 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :shot5 => 1.1).
          should have(1).errors_on(:shot5)
      end

      it "should be non-negative" do
        Factory.build(:result, :shot5 => -1).
          should have(1).errors_on(:shot5)
      end

      it "should be at maximum 10" do
        Factory.build(:result, :shot5 => 11).
          should have(1).errors_on(:shot5)
      end
    end

    describe "shot6" do
      it "can be nil" do
        Factory.build(:result, :shot6 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :shot6 => 1.1).
          should have(1).errors_on(:shot6)
      end

      it "should be non-negative" do
        Factory.build(:result, :shot6 => -1).
          should have(1).errors_on(:shot6)
      end

      it "should be at maximum 10" do
        Factory.build(:result, :shot6 => 11).
          should have(1).errors_on(:shot6)
      end
    end

    describe "shot7" do
      it "can be nil" do
        Factory.build(:result, :shot7 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :shot7 => 1.1).
          should have(1).errors_on(:shot7)
      end

      it "should be non-negative" do
        Factory.build(:result, :shot7 => -1).
          should have(1).errors_on(:shot7)
      end

      it "should be at maximum 10" do
        Factory.build(:result, :shot7 => 11).
          should have(1).errors_on(:shot7)
      end
    end

    describe "shot8" do
      it "can be nil" do
        Factory.build(:result, :shot8 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :shot8 => 1.1).
          should have(1).errors_on(:shot8)
      end

      it "should be non-negative" do
        Factory.build(:result, :shot8 => -1).
          should have(1).errors_on(:shot8)
      end

      it "should be at maximum 10" do
        Factory.build(:result, :shot8 => 11).
          should have(1).errors_on(:shot8)
      end
    end

    describe "shot9" do
      it "can be nil" do
        Factory.build(:result, :shot9 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :shot9 => 1.1).
          should have(1).errors_on(:shot9)
      end

      it "should be non-negative" do
        Factory.build(:result, :shot9 => -1).
          should have(1).errors_on(:shot9)
      end

      it "should be at maximum 10" do
        Factory.build(:result, :shot9 => 11).
          should have(1).errors_on(:shot9)
      end
    end

    describe "shot10" do
      it "can be nil" do
        Factory.build(:result, :shot10 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:result, :shot10 => 1.1).
          should have(1).errors_on(:shot10)
      end

      it "should be non-negative" do
        Factory.build(:result, :shot10 => -1).
          should have(1).errors_on(:shot10)
      end

      it "should be at maximum 10" do
        Factory.build(:result, :shot10 => 11).
          should have(1).errors_on(:shot10)
      end
    end

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

  describe "shots_sum" do
    it "should return 0 when everything is nil" do
      Factory.build(:result).shots_sum.should == 0
    end

    it "should be shots_total_input when it is given" do
      Factory.build(:result, :shots_total_input => 55).shots_sum.should == 55
    end

    it "should be sum of defined individual shots if no input sum" do
      Factory.build(:result, :shots_total_input => nil,
        :shot1 => 8, :shot2 => 9).shots_sum.should == 17
    end

    it "should be sum of all individual shots if no input sum and all defined" do
      Factory.build(:result, :shots_total_input => nil,
        :shot1 => 8, :shot2 => 9, :shot3 => 0, :shot4 => 5, :shot5 => 10,
        :shot6 => 8, :shot7 => 9, :shot8 => 0, :shot9 => 5, :shot10 => 10).
        shots_sum.should == 64
    end
  end

  describe "shot_points" do
    it "should be 6 times shots_sum" do
      result = Factory.build(:result)
      result.should_receive(:shots_sum).and_return(50)
      result.shot_points.should == 300
    end
  end

end
