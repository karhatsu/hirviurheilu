require 'spec_helper'

describe Cup do
  it "create" do
    FactoryGirl.create(:cup)
  end
  
  describe "associations" do
    it { should have_many(:cup_series) }
  end
  
  describe "validation" do
    it { should validate_presence_of(:name) }
    
    it { should validate_numericality_of(:top_competitions) }
    it { should_not allow_value(nil).for(:top_competitions) }
    it { should_not allow_value(0).for(:top_competitions) }
    it { should allow_value(1).for(:top_competitions) }
    it { should_not allow_value(2.1).for(:top_competitions) }
  end
  
  describe "relations" do
    it { should have_and_belong_to_many(:races) }

    describe "races" do
      it "should be ordered by start date" do
        cup = FactoryGirl.create(:cup)
        cup.races << FactoryGirl.build(:race, :start_date => '2012-04-02')
        cup.races << FactoryGirl.build(:race, :start_date => '2012-03-31')
        cup.races << FactoryGirl.build(:race, :start_date => '2012-04-01')
        cup.races.collect { |r| r.start_date.strftime('%Y-%m-%d') }.
          should == ['2012-03-31', '2012-04-01', '2012-04-02']
      end
    end
  end
  
  describe "#sport" do
    it "should be nil when no races" do
      FactoryGirl.build(:cup).sport.should be_nil
    end
    
    it "should be the sport of the first race" do
      cup = FactoryGirl.build(:cup)
      cup.stub!(:races).and_return([mock_model(Race, :sport => Sport::RUN), mock_model(Race, :sport => Sport::SKI)])
      cup.sport.should == Sport::RUN
    end
  end
  
  describe "#start_date" do
    it "should be nil when no races" do
      FactoryGirl.build(:cup).start_date.should be_nil
    end
    
    it "should be the start date of the first race (since races are ordered by start date)" do
      cup = FactoryGirl.build(:cup)
      race1 = FactoryGirl.build(:race, :start_date => '2012-04-01')
      race2 = FactoryGirl.build(:race, :start_date => '2012-03-31')
      cup.stub!(:races).and_return([race2, race1])
      cup.start_date.strftime('%Y-%m-%d').should == '2012-03-31'
    end
  end
  
  describe "#end_date" do
    it "should be nil when no races" do
      FactoryGirl.build(:cup).end_date.should be_nil
    end
    
    it "should be the end date of the last race (since races are ordered by start date)" do
      cup = FactoryGirl.build(:cup)
      race1 = FactoryGirl.build(:race, :start_date => '2012-04-01', :end_date => '2012-04-02')
      race2 = FactoryGirl.build(:race, :start_date => '2012-03-31', :end_date => '2012-03-31')
      cup.stub!(:races).and_return([race2, race1])
      cup.end_date.strftime('%Y-%m-%d').should == '2012-04-02'
    end
  end
  
  describe "#location" do
    it "should be nil when no races" do
      FactoryGirl.build(:cup).location.should be_nil
    end
    
    context "when each race has different location" do
      it "should be all race locations separated with /" do
        cup = FactoryGirl.build(:cup)
        race1 = FactoryGirl.build(:race, :location => 'Shooting city')
        race2 = FactoryGirl.build(:race, :location => 'Skiing town')
        race3 = FactoryGirl.build(:race, :location => 'Running village')
        cup.stub!(:races).and_return([race1, race2, race3])
        cup.location.should == 'Shooting city / Skiing town / Running village'
      end
    end
    
    context "when each race has the same location" do
      it "should be the location" do
        cup = FactoryGirl.build(:cup)
        race1 = FactoryGirl.build(:race, :location => 'Shooting city')
        race2 = FactoryGirl.build(:race, :location => 'Shooting city')
        cup.stub!(:races).and_return([race1, race2])
        cup.location.should == 'Shooting city'
      end
    end
    
    context "when first and third race has the same location" do
      it "should be the first location / the second location" do
        cup = FactoryGirl.build(:cup)
        race1 = FactoryGirl.build(:race, :location => 'Shooting city')
        race2 = FactoryGirl.build(:race, :location => 'Skiing town')
        race3 = FactoryGirl.build(:race, :location => 'Shooting city')
        cup.stub!(:races).and_return([race1, race2, race3])
        cup.location.should == 'Shooting city / Skiing town'
      end
    end
  end
  
  describe "#create_default_cup_series" do
    context "when no races" do
      it "should do nothing" do
        cup = FactoryGirl.create(:cup)
        cup.create_default_cup_series
      end
    end
  
    context "when races" do
      before do
        race1 = mock_model(Race)
        series1_1 = mock_model(Series, :name => 'M50')
        series1_2 = mock_model(Series, :name => 'M60')
        race1.stub!(:series).and_return([series1_1, series1_2])
        race2 = mock_model(Race)
        series2_1 = mock_model(Series, :name => 'M70')
        series2_2 = mock_model(Series, :name => 'M80')
        race2.stub!(:series).and_return([series2_1, series2_2])
        races = [race1, race2]
        @cup = FactoryGirl.create(:cup)
        @cup.stub!(:races).and_return(races)
      end
    
      it "should create cup series based on series names in the first race" do
        @cup.cup_series.should be_empty
        @cup.create_default_cup_series
        @cup.reload
        cup_series = @cup.cup_series
        cup_series.length.should == 2
        cup_series[0].name.should == 'M50'
        cup_series[1].name.should == 'M60'
      end
    end
    
    context "when already has cup series" do
      it "should raise an exception" do
        cup = FactoryGirl.build(:cup)
        cup.stub!(:cup_series).and_return([mock_model(CupSeries)])
        lambda { cup.create_default_cup_series }.should raise_error
      end
    end
  end
  
  describe ".cup_races" do
    it "should return an empty array when nothing given" do
      Cup.cup_races([]).should == []
    end
    
    it "should return an empty array when cups without races" do
      Cup.cup_races([FactoryGirl.create(:cup), FactoryGirl.create(:cup)]).should == []
    end
    
    it "should return all races that are assigned to cups" do
      cup1 = FactoryGirl.create(:cup)
      race11 = FactoryGirl.build(:race)
      race12 = FactoryGirl.build(:race)
      cup1.races << race11
      cup1.races << race12
      cup2 = FactoryGirl.create(:cup)
      race21 = FactoryGirl.build(:race)
      cup2.races << race21
      Cup.cup_races(Cup.all).should == [race11, race12, race21]
    end
  end
end
