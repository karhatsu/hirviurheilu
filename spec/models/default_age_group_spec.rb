require 'spec_helper'

describe DefaultAgeGroup do
  it "should take name and min_competitors as init parameters" do
    dag = DefaultAgeGroup.new("Test group", 5)
    dag.name.should == "Test group"
    dag.min_competitors.should == 5
  end
end
