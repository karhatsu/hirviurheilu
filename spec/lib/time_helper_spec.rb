require 'spec_helper'
require 'time_helper.rb'

describe TimeHelper do
  include TimeHelper

  describe "#seconds_for_day" do
    it "should return the sum of seconds for given day no matter what the day is" do
      time = Time.utc(2006, 6, 12, 13, 55, 27)
      seconds_for_day(time).should == 3600 * 13 + 60 * 55 + 27
      time = Time.utc(2012, 1, 30, 9, 5, 56)
      seconds_for_day(time).should == 3600 * 9 + 60 * 5 + 56
    end
  end
end

