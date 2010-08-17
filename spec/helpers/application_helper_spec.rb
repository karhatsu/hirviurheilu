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
end

