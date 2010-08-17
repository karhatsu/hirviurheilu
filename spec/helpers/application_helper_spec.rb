require 'spec_helper'

describe ApplicationHelper do
  describe "points_print" do
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
end

