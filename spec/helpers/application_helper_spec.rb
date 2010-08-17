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
end

