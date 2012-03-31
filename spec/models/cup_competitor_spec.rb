require 'spec_helper'

describe CupCompetitor do
  before do
    @cup = mock(Cup)
    @cs = mock(CupSeries, :cup => @cup)
    @competitor = mock_model(Competitor, :first_name => 'Mikko', :last_name => 'Miettinen')
    @cc = CupCompetitor.new(@cs, @competitor)
  end
  
  describe "#first_name" do
    it "should be the first name of the first competitor" do
      @cc.first_name.should == @competitor.first_name
    end
  end
  
  describe "#last_name" do
    it "should be the last name of the first competitor" do
      @cc.last_name.should == @competitor.last_name
    end
  end

  describe "other competitors" do
    it "should accept other competitors when their name is the same as the first one's" do
      @cc << valid_competitor
      @cc.competitors.length.should == 2
    end
    
    it "should not accept another competitor when first names differs" do
      lambda { @cc << mock_model(Competitor, :first_name => 'Other',
        :last_name => @competitor.last_name) }.should raise_error
      @cc.competitors.length.should == 1
    end
    
    it "should not accept another competitor when last names differs" do
      lambda { @cc << mock_model(Competitor, :first_name => @competitor.first_name,
        :last_name => 'Other') }.should raise_error
      @cc.competitors.length.should == 1
    end
  end
  
  describe "#points" do
    before do
      @competitor2 = valid_competitor
      @competitor3 = valid_competitor
      @cc << @competitor2
      @cc << @competitor3
      @cup.stub!(:top_competitions).and_return(3)
    end
    
    context "when no points available in any of the competitions" do
      it "should be 0" do
        @competitor.stub!(:points).with(false).and_return(nil)
        @competitor2.stub!(:points).with(false).and_return(nil)
        @competitor3.stub!(:points).with(false).and_return(nil)
        @cc.points.should == 0
      end
    end
    
    context "when points available in the competitions" do
      before do
        @competitor.stub!(:points).with(false).and_return(1000)
        @competitor2.stub!(:points).with(false).and_return(2000)
        @competitor3.stub!(:points).with(false).and_return(3000)
      end
      
      it "should be sum of points in individual competitions when all competitions matter" do
        @cup.stub!(:top_competitions).and_return(3)
        @cc.points.should == 1000 + 2000 + 3000
      end
      
      it "should be sum of top two points in individual competitions when top two of them matter" do
        @cup.stub!(:top_competitions).and_return(2)
        @cc.points.should == 2000 + 3000
      end
    end
  end
  
  def valid_competitor
    mock_model(Competitor, :first_name => @competitor.first_name, :last_name => @competitor.last_name)
  end
end
