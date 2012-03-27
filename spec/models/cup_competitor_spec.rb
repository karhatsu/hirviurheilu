require 'spec_helper'

describe CupCompetitor do
  before do
    @competitor = mock_model(Competitor, :first_name => 'Mikko', :last_name => 'Miettinen')
    @cc = CupCompetitor.new(@competitor)
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
      @cc << mock_model(Competitor, :first_name => @competitor.first_name, :last_name => @competitor.last_name)
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
end
