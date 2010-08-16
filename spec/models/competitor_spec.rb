require 'spec_helper'

describe Competitor do
  describe "create" do
    it "should create competitor with valid attrs" do
      Factory.create(:competitor)
    end
  end

  describe "validation" do
    it "should require first_name" do
      Factory.build(:competitor, :first_name => nil).
        should have(1).errors_on(:first_name)
    end

    it "should require last_name" do
      Factory.build(:competitor, :last_name => nil).
        should have(1).errors_on(:last_name)
    end

    describe "year_of_birth" do
      it "should be mandatory" do
        Factory.build(:competitor, :year_of_birth => nil).
          should have(1).errors_on(:year_of_birth)
      end

      it "should be integer, not string" do
        Factory.build(:competitor, :year_of_birth => 'xyz').
          should have(1).errors_on(:year_of_birth)
      end

      it "should be integer, not decimal" do
        Factory.build(:competitor, :year_of_birth => 23.5).
          should have(1).errors_on(:year_of_birth)
      end

      it "should be greater than 1900" do
        Factory.build(:competitor, :year_of_birth => 1899).
          should have(1).errors_on(:year_of_birth)
      end

      it "should be less than 2100" do
        Factory.build(:competitor, :year_of_birth => 2101).
          should have(1).errors_on(:year_of_birth)
      end
    end

    describe "shot1" do
      it "can be nil" do
        Factory.build(:competitor, :shot1 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shot1 => 1.1).
          should have(1).errors_on(:shot1)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shot1 => -1).
          should have(1).errors_on(:shot1)
      end

      it "should be at maximum 10" do
        Factory.build(:competitor, :shot1 => 11).
          should have(1).errors_on(:shot1)
      end
    end

    describe "shot2" do
      it "can be nil" do
        Factory.build(:competitor, :shot2 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shot2 => 1.1).
          should have(1).errors_on(:shot2)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shot2 => -1).
          should have(1).errors_on(:shot2)
      end

      it "should be at maximum 10" do
        Factory.build(:competitor, :shot2 => 11).
          should have(1).errors_on(:shot2)
      end
    end

    describe "shot3" do
      it "can be nil" do
        Factory.build(:competitor, :shot3 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shot3 => 1.1).
          should have(1).errors_on(:shot3)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shot3 => -1).
          should have(1).errors_on(:shot3)
      end

      it "should be at maximum 10" do
        Factory.build(:competitor, :shot3 => 11).
          should have(1).errors_on(:shot3)
      end
    end

    describe "shot4" do
      it "can be nil" do
        Factory.build(:competitor, :shot4 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shot4 => 1.1).
          should have(1).errors_on(:shot4)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shot4 => -1).
          should have(1).errors_on(:shot4)
      end

      it "should be at maximum 10" do
        Factory.build(:competitor, :shot4 => 11).
          should have(1).errors_on(:shot4)
      end
    end

    describe "shot5" do
      it "can be nil" do
        Factory.build(:competitor, :shot5 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shot5 => 1.1).
          should have(1).errors_on(:shot5)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shot5 => -1).
          should have(1).errors_on(:shot5)
      end

      it "should be at maximum 10" do
        Factory.build(:competitor, :shot5 => 11).
          should have(1).errors_on(:shot5)
      end
    end

    describe "shot6" do
      it "can be nil" do
        Factory.build(:competitor, :shot6 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shot6 => 1.1).
          should have(1).errors_on(:shot6)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shot6 => -1).
          should have(1).errors_on(:shot6)
      end

      it "should be at maximum 10" do
        Factory.build(:competitor, :shot6 => 11).
          should have(1).errors_on(:shot6)
      end
    end

    describe "shot7" do
      it "can be nil" do
        Factory.build(:competitor, :shot7 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shot7 => 1.1).
          should have(1).errors_on(:shot7)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shot7 => -1).
          should have(1).errors_on(:shot7)
      end

      it "should be at maximum 10" do
        Factory.build(:competitor, :shot7 => 11).
          should have(1).errors_on(:shot7)
      end
    end

    describe "shot8" do
      it "can be nil" do
        Factory.build(:competitor, :shot8 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shot8 => 1.1).
          should have(1).errors_on(:shot8)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shot8 => -1).
          should have(1).errors_on(:shot8)
      end

      it "should be at maximum 10" do
        Factory.build(:competitor, :shot8 => 11).
          should have(1).errors_on(:shot8)
      end
    end

    describe "shot9" do
      it "can be nil" do
        Factory.build(:competitor, :shot9 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shot9 => 1.1).
          should have(1).errors_on(:shot9)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shot9 => -1).
          should have(1).errors_on(:shot9)
      end

      it "should be at maximum 10" do
        Factory.build(:competitor, :shot9 => 11).
          should have(1).errors_on(:shot9)
      end
    end

    describe "shot10" do
      it "can be nil" do
        Factory.build(:competitor, :shot10 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shot10 => 1.1).
          should have(1).errors_on(:shot10)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shot10 => -1).
          should have(1).errors_on(:shot10)
      end

      it "should be at maximum 10" do
        Factory.build(:competitor, :shot10 => 11).
          should have(1).errors_on(:shot10)
      end
    end

    describe "shots_total_input" do
      it "can be nil" do
        Factory.build(:competitor, :shots_total_input => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shots_total_input => 1.1).
          should have(1).errors_on(:shots_total_input)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shots_total_input => -1).
          should have(1).errors_on(:shots_total_input)
      end

      it "should be at maximum 100" do
        Factory.build(:competitor, :shots_total_input => 101).
          should have(1).errors_on(:shots_total_input)
      end
    end

    describe "estimate1" do
      it "can be nil" do
        Factory.build(:competitor, :estimate1 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :estimate1 => 1.1).
          should have(1).errors_on(:estimate1)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :estimate1 => -1).
          should have(1).errors_on(:estimate1)
      end
    end

    describe "estimate2" do
      it "can be nil" do
        Factory.build(:competitor, :estimate2 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :estimate2 => 1.1).
          should have(1).errors_on(:estimate2)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :estimate2 => -1).
          should have(1).errors_on(:estimate2)
      end
    end

    describe "arrival_time" do
      it "can be nil" do
        Factory.build(:competitor, :arrival_time => nil).should be_valid
      end

      it "is valid when at least same as start time" do
        Factory.build(:competitor, :start_time => '14:00', :arrival_time => '14:00').
          should be_valid
      end

      it "should not be before competitor's start time" do
        Factory.build(:competitor, :start_time => '14:00', :arrival_time => '13:59').
          should have(1).errors_on(:arrival_time)
      end
    end
  end

  describe "shots_sum" do
    it "should return nil when everything is nil" do
      Factory.build(:competitor).shots_sum.should be_nil
    end

    it "should be shots_total_input when it is given" do
      Factory.build(:competitor, :shots_total_input => 55).shots_sum.should == 55
    end

    it "should be sum of defined individual shots if no input sum" do
      Factory.build(:competitor, :shots_total_input => nil,
        :shot1 => 8, :shot2 => 9).shots_sum.should == 17
    end

    it "should be sum of all individual shots if no input sum and all defined" do
      Factory.build(:competitor, :shots_total_input => nil,
        :shot1 => 8, :shot2 => 9, :shot3 => 0, :shot4 => 5, :shot5 => 10,
        :shot6 => 8, :shot7 => 9, :shot8 => 0, :shot9 => 5, :shot10 => 10).
        shots_sum.should == 64
    end
  end

  describe "shot_points" do
    it "should be nil if shots not defined" do
      competitor = Factory.build(:competitor)
      competitor.should_receive(:shots_sum).and_return(nil)
      competitor.shot_points.should be_nil
    end

    it "should be 6 times shots_sum" do
      competitor = Factory.build(:competitor)
      competitor.should_receive(:shots_sum).and_return(50)
      competitor.shot_points.should == 300
    end
  end

  describe "estimate_points" do
    before do
      @competitor = Factory.build(:competitor, :estimate1 => 88, :estimate2 => 145)
    end

    it "should be nil if estimate1 is missing" do
      competitor = Factory.build(:competitor, :estimate1 => nil, :estimate2 => 145)
      competitor.estimate_points(1, 2).should be_nil
    end

    it "should be nil if estimate2 is missing" do
      competitor = Factory.build(:competitor, :estimate1 => 88, :estimate2 => nil)
      competitor.estimate_points(1, 2).should be_nil
    end

    it "should be 300 when perfect estimates" do
      @competitor.estimate_points(88, 145).should == 300
    end

    it "should be 298 when the first is 1 meter too low" do
      @competitor.estimate_points(89, 145).should == 298
    end

    it "should be 298 when the second is 1 meter too low" do
      @competitor.estimate_points(88, 146).should == 298
    end

    it "should be 298 when the first is 1 meter too high" do
      @competitor.estimate_points(87, 145).should == 298
    end

    it "should be 298 when the second is 1 meter too high" do
      @competitor.estimate_points(88, 144).should == 298
    end

    it "should never be negative" do
      @competitor.estimate_points(111111, 222222).should == 0
    end
  end

  describe "time_in_seconds" do
    it "should be nil when start time not known yet" do
      Factory.build(:competitor, :start_time => nil).time_in_seconds.should be_nil
    end

    it "should be nil when arrival time is not known yet" do
      Factory.build(:competitor, :start_time => '14:00', :arrival_time => nil).
        time_in_seconds.should be_nil
    end

    it "should be difference of arrival and start times" do
      Factory.build(:competitor, :start_time => '13:58:02', :arrival_time => '15:02:04').
        time_in_seconds.should == 64 * 60 + 2
    end
  end

  describe "time_points" do
    before do
      @competitor = Factory.build(:competitor)
      @best_time_seconds = 3600
    end

    it "should be nil when time cannot be calculated yet" do
      @competitor.should_receive(:time_in_seconds).and_return(nil)
      @competitor.time_points(@best_time_seconds).should == nil
    end

    it "should be 300 when this competitor has the best time" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds)
      @competitor.time_points(@best_time_seconds).should == 300
    end

    it "should be 300 when this competitor was five seconds slower than the best" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 5)
      @competitor.time_points(@best_time_seconds).should == 300
    end

    it "should 299 when this competitor was six seconds slower than the best" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 6)
      @competitor.time_points(@best_time_seconds).should == 299
    end

    it "should 299 when this competitor was 11 seconds slower than the best" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 11)
      @competitor.time_points(@best_time_seconds).should == 299
    end

    it "should 298 when this competitor was 12 seconds slower than the best" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 12)
      @competitor.time_points(@best_time_seconds).should == 298
    end

    it "should never be negative" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 100000)
      @competitor.time_points(@best_time_seconds).should == 0
    end
  end

end
