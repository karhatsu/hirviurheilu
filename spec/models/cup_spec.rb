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
end
