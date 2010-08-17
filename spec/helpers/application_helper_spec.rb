require 'spec_helper'

describe ApplicationHelper do
  describe "#points_print" do
    it "should print points in case they are available" do
      competitor = mock_model(Competitor, :points => 145)
      helper.points_print(competitor).should == 145
    end

    it "should print points in brackets if only partial points are available" do
      competitor = mock_model(Competitor, :points => nil, :points! => 100)
      helper.points_print(competitor).should == "(100)"
    end

    it "should print - if no points at all" do
      competitor = mock_model(Competitor, :points => nil, :points! => nil)
      helper.points_print(competitor).should == "-"
    end
  end

  describe "#time_print" do
    it "should return empty string when nil given" do
      helper.time_print(nil).should == ""
    end

    it "should return seconds when less than 60" do
      helper.time_print(59).should == "00:59"
    end

    it "should return minutes and seconds when more than 60" do
      helper.time_print(60).should == "01:00"
      helper.time_print(61).should == "01:01"
      helper.time_print(131).should == "02:11"
    end

    it "should return hours, minutes and seconds when at least 1 hour" do
      helper.time_print(3600).should == "1:00:00"
      helper.time_print(3601).should == "1:00:01"
    end

    it "should convert decimal seconds to integer" do
      helper.time_print(60.0).should == "01:00"
      helper.time_print(61.1).should == "01:01"
      helper.time_print(131.2).should == "02:11"
      helper.time_print(3601.6).should == "1:00:01"
    end
  end

  describe "#shot_points_and_total" do
    it "should return dash when no shots sum" do
      competitor = mock_model(Competitor, :shots_sum => nil)
      helper.shot_points_and_total(competitor).should == "-"
    end

    it "should return shot points and sum in brackets" do
      competitor = mock_model(Competitor, :shot_points => 480, :shots_sum => 80)
      helper.shot_points_and_total(competitor).should == "480 (80)"
    end
  end

  describe "#shots_list" do
    it "should return empty string when no shots sum" do
      competitor = mock_model(Competitor, :shots_sum => nil)
      helper.shots_list(competitor).should == ""
    end

    it "should return input total if such is given" do
      competitor = mock_model(Competitor, :shots_sum => 45, :shots_total_input => 45)
      helper.shots_list(competitor).should == 45
    end

    it "should return comma separated list if individual shots defined" do
      shots = [10, 1, 9, 5, 5, nil, nil, 6, 4, 0]
      competitor = mock_model(Competitor, :shots_sum => 50,
        :shots_total_input => nil, :shot_values => shots)
      helper.shots_list(competitor).should == "10,1,9,5,5,0,0,6,4,0"
    end
  end

  describe "#estimate_diffs" do
    it "should return empty string when no estimates" do
      competitor = mock_model(Competitor, :estimate1 => nil, :estimate2 => nil)
      helper.estimate_diffs(competitor).should == ""
    end

    it "should return first and dash when first is available" do
      competitor = mock_model(Competitor, :estimate1 => 50, :estimate2 => nil,
        :estimate_diff1_m => 10, :estimate_diff2_m => nil)
      helper.estimate_diffs(competitor).should == "+10m/-"
    end

    it "should return dash and second when second is available" do
      competitor = mock_model(Competitor, :estimate1 => nil, :estimate2 => 60,
        :estimate_diff1_m => nil, :estimate_diff2_m => -5)
      helper.estimate_diffs(competitor).should == "-/-5m"
    end

    it "should return both when both are available" do
      competitor = mock_model(Competitor, :estimate1 => 120, :estimate2 => 60,
        :estimate_diff1_m => -5, :estimate_diff2_m => 14)
      helper.estimate_diffs(competitor).should == "-5m/+14m"
    end
  end

  describe "#estimate_points_and_diffs" do
    it "should return dash if no estimate points" do
      competitor = mock_model(Competitor, :estimate_points => nil)
      helper.estimate_points_and_diffs(competitor).should == "-"
    end

    it "should return points and diffs when points available" do
      competitor = mock_model(Competitor, :estimate_points => 189)
      helper.should_receive(:estimate_diffs).with(competitor).and_return("3m")
      helper.estimate_points_and_diffs(competitor).should == "189 (3m)"
    end
  end

  describe "#time_points_and_time" do
    it "should return dash when no time" do
      competitor = mock_model(Competitor, :time_in_seconds => nil)
      helper.time_points_and_time(competitor).should == "-"
    end

    it "should return shot points and sum in brackets" do
      competitor = mock_model(Competitor, :time_points => 270, :time_in_seconds => 2680)
      helper.should_receive(:time_print).with(2680).and_return("45:23")
      helper.time_points_and_time(competitor).should == "270 (45:23)"
    end
  end
end

