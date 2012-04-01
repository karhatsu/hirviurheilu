require 'spec_helper'

describe Cup do
  it "create" do
    Factory.create(:cup)
  end
  
  describe "validation" do
    it { should validate_presence_of(:name) }
    
    it { should validate_numericality_of(:top_competitions) }
    it { should_not allow_value(nil).for(:top_competitions) }
    it { should_not allow_value(0).for(:top_competitions) }
    it { should_not allow_value(1).for(:top_competitions) }
    it { should allow_value(2).for(:top_competitions) }
    it { should_not allow_value(2.1).for(:top_competitions) }
  end
  
  describe "relations" do
    it { should have_and_belong_to_many(:races) }

    describe "races" do
      it "should be ordered by start date" do
        cup = Factory.create(:cup)
        cup.races << Factory.build(:race, :start_date => '2012-04-02')
        cup.races << Factory.build(:race, :start_date => '2012-03-31')
        cup.races << Factory.build(:race, :start_date => '2012-04-01')
        cup.races.collect { |r| r.start_date.strftime('%Y-%m-%d') }.
          should == ['2012-03-31', '2012-04-01', '2012-04-02']
      end
    end
  end
  
  describe "#cup_series" do
    it "should return an empty array when no races" do
      Factory.build(:cup).cup_series.should == []
    end
    
    it "should return an empty array when races have no series" do
      cup = Factory.create(:cup)
      cup.races << Factory.build(:race)
      cup.cup_series.should == []
    end
    
    it "should return series that each race has with same name and exclude others" do
      cup = Factory.create(:cup)
      create_race(cup, 'M', 'N', 'S17')
      create_race(cup, 'M', 'N50', 'N')
      create_race(cup, 'N', 'M70', 'M')
      cup_series = cup.cup_series
      cup_series.length.should == 2
      cup_series[0].name.should == 'M'
      cup_series[1].name.should == 'N'
    end
    
    def create_race(cup, *series_names)
      race = Factory.create(:race)
      series_names.each do |series_name|
        race.series << Factory.build(:series, :race => race, :name => series_name)
      end
      cup.races << race
      race
    end
  end
  
  describe "#find_cup_series" do
    it "should return nil if unknown series name" do
      Factory.build(:cup).find_cup_series('Fooo').should be_nil
    end
    
    it "should return the cup series with given name" do
      cup = Factory.build(:cup)
      cs1 = mock(CupSeries, :name => 'Series 1')
      cs2 = mock(CupSeries, :name => 'Series 2')
      cup.stub!(:cup_series).and_return([cs1, cs2])
      cup.find_cup_series(cs2.name).should == cs2
    end
  end
  
  describe "#sport" do
    it "should be nil when no races" do
      Factory.build(:cup).sport.should be_nil
    end
    
    it "should be the sport of the first race" do
      cup = Factory.build(:cup)
      cup.stub!(:races).and_return([mock_model(Race, :sport => Sport::RUN), mock_model(Race, :sport => Sport::SKI)])
      cup.sport.should == Sport::RUN
    end
  end
  
  describe "#start_date" do
    it "should be nil when no races" do
      Factory.build(:cup).start_date.should be_nil
    end
    
    it "should be the start date of the first race (since races are ordered by start date)" do
      cup = Factory.build(:cup)
      race1 = Factory.build(:race, :start_date => '2012-04-01')
      race2 = Factory.build(:race, :start_date => '2012-03-31')
      cup.stub!(:races).and_return([race2, race1])
      cup.start_date.strftime('%Y-%m-%d').should == '2012-03-31'
    end
  end
  
  describe "#end_date" do
    it "should be nil when no races" do
      Factory.build(:cup).end_date.should be_nil
    end
    
    it "should be the end date of the last race (since races are ordered by start date)" do
      cup = Factory.build(:cup)
      race1 = Factory.build(:race, :start_date => '2012-04-01', :end_date => '2012-04-02')
      race2 = Factory.build(:race, :start_date => '2012-03-31', :end_date => '2012-03-31')
      cup.stub!(:races).and_return([race2, race1])
      cup.end_date.strftime('%Y-%m-%d').should == '2012-04-02'
    end
  end
end
