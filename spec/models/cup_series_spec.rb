require 'spec_helper'

describe CupSeries do
  before do
    @series1 = mock_model(Series, :name => 'M')
    @cs = CupSeries.new(@series1)
  end
  
  describe "#name" do
    it "should be the name of the first series" do
      @cs.name.should == @series1.name
    end
  end

  describe "other series" do
    it "should accept other series when their name is the same as the first one's" do
      @cs << mock_model(Series, :name => 'M')
      @cs.series.length.should == 2
    end
    
    it "should not accept other series with another name than the first" do
      lambda { @cs << mock_model(Series, :name => 'M50') }.should raise_error
      @cs.series.length.should == 1
    end
  end
end
