require 'spec_helper'

describe CupSeries do
  it "create" do
    FactoryGirl.create(:cup_series)
  end
  
  describe "associations" do
    it { should belong_to(:cup) }
  end
  
  describe "validations" do
    it { should validate_presence_of(:name) }
  end
  
  describe "#series" do
    before do
      @cup_series_name = 'M'
      @cup = FactoryGirl.build(:cup)
      @cs = FactoryGirl.build(:cup_series, :cup => @cup, :name => @cup_series_name)
    end

    it "should return an empty array when no races" do
      @cs.series.should == []
    end
    
    it "should return an empty array when races have no series" do
      @cup.stub!(:races).and_return([FactoryGirl.build(:race)])
      @cs.series.should == []
    end
    
    it "should return series that have same name as cup series" do
      race1 = create_race
      race2 = create_race
      race3 = create_race
      @cup.stub!(:races).and_return([race1, race2, race3])
      series = @cs.series
      series.length.should == 3
      series[0].name.should == @cup_series_name
      series[0].race.should == race1
      series[1].name.should == @cup_series_name
      series[1].race.should == race2
      series[2].name.should == @cup_series_name
      series[2].race.should == race3
    end
    
    def create_race
      race = FactoryGirl.build(:race)
      series = FactoryGirl.build(:series, :race => race, :name => @cup_series_name)
      all_series = mock(Object)
      race.stub!(:series).and_return(all_series)
      all_series.stub!(:where).with(:name => @cup_series_name).and_return([series])
      race
    end
  end

  describe "#cup_competitors" do
    before do
      @series1 = FactoryGirl.build(:series)
      @cs = FactoryGirl.build(:cup_series)
    end
    
    context "when no competitors in series" do
      it "should return an empty array" do
        series = mock_model(Series, :competitors => [])
        @cs.stub!(:series).and_return([series])
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
        series1 = mock_model(Series, :competitors => [@cMM1, @cTM1, @cMT1])
        series2 = mock_model(Series, :competitors => [@cMM2, @cAA2])
        series3 = mock_model(Series, :competitors => [@cMM3, @cTM3])
        @cs.stub!(:series).and_return([series1, series2, series3])
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
  
  describe "#ordered_competitors" do
    before do
      @cs = FactoryGirl.build(:cup_series)
    end
    
    it "should return an empty array when no competitors" do
      @cs.stub!(:cup_competitors).and_return([])
      @cs.ordered_competitors.should == []
    end
    
    it "should return cup competitors ordered by descending 1. total points 2. partial points" do
      cc1 = mock(CupCompetitor, :points => 3000, :points! => 3000)
      cc2 = mock(CupCompetitor, :points => 3001, :points! => 3000)
      cc3 = mock(CupCompetitor, :points => nil, :points! => 3000)
      cc4 = mock(CupCompetitor, :points => 2999, :points! => 3000)
      cc5 = mock(CupCompetitor, :points => nil, :points! => nil)
      cc6 = mock(CupCompetitor, :points => nil, :points! => 3001)
      @cs.stub!(:cup_competitors).and_return([cc1, cc2, cc3, cc4, cc5, cc6])
      @cs.ordered_competitors.should == [cc2, cc1, cc4, cc6, cc3, cc5]
    end
  end
end
