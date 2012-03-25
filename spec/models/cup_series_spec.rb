require 'spec_helper'

describe CupSeries do
  it "should have name" do
    cs = CupSeries.new('M')
    cs.name.should == 'M'
  end
end
