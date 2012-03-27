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
  
  describe "#cup_competitors" do
    context "when no competitors in series" do
      it "should return an empty array" do
        @series1.stub!(:competitors).and_return([])
        @cs.cup_competitors.should == []
      end
    end
    
    context "when competitors in series" do
      before do
        @cMM1 = competitor('Mikko', 'Miettinen')
        @cMM2 = competitor('Mikko', 'Miettinen')
        @cMM3 = competitor('Mikko', 'Miettinen')
        @cTM1 = competitor('Timo', 'Miettinen')
        @cTM3 = competitor('Timo', 'Miettinen')
        @cMT1 = competitor('Mikko', 'Turunen')
        @cAA2 = competitor('Aki', 'Aalto')
        @series1.stub!(:competitors).and_return([@cMM1, @cTM1, @cMT1])
        @cs << mock_model(Series, :name => @series1.name, :competitors => [@cMM2, @cAA2])
        @cs << mock_model(Series, :name => @series1.name, :competitors => [@cMM3, @cTM3])
      end
      
      it "should return cup competitors created based on competitors' first and last name" do
        cup_competitors = @cs.cup_competitors
        cup_competitors.length.should == 4
        cup_competitors[0].competitors[0].should == @cMM1
        cup_competitors[0].competitors[1].should == @cMM2
        cup_competitors[0].competitors[2].should == @cMM3
        cup_competitors[1].competitors[0].should == @cTM1
        cup_competitors[1].competitors[1].should == @cTM3
        cup_competitors[2].competitors[0].should == @cMT1
        cup_competitors[3].competitors[0].should == @cAA2
      end
      
      def competitor(first_name, last_name)
        mock_model(Competitor, :first_name => first_name, :last_name => last_name)
      end
    end
  end
end
