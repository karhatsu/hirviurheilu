require 'spec_helper'

describe DefaultSeries do
  describe "#initialize" do
    it "should accept name and no default age groups" do
      ds = DefaultSeries.new('Test series')
      ds.name.should == 'Test series'
    end
    
    it "should accept name and one age group with name and min_competitors" do
      ds = DefaultSeries.new('Series with age group', ['Age group', 5])
      ds.name.should == 'Series with age group'
      ds.default_age_groups[0].name.should == 'Age group'
      ds.default_age_groups[0].min_competitors.should == 5
    end
    
    it "should accept name and multiple age groups with name and min_competitors" do
      ds = DefaultSeries.new('Series with age group', ['Age group', 5], ['Another age group', 1])
      ds.name.should == 'Series with age group'
      ds.default_age_groups.length.should == 2
      ds.default_age_groups[1].name.should == 'Another age group'
      ds.default_age_groups[1].min_competitors.should == 1
    end
  end
  
  describe ".all" do
    it "should contain DefaultSeries objects" do
      DefaultSeries.all.each do |ds|
        ds.should be_a(DefaultSeries)
      end
    end
    
    it "should have S16 with T16,0/P16,0 as first series" do
      ds = DefaultSeries.all.first
      ds.name.should == 'S16'
      ds.default_age_groups[0].name.should == 'T16'
      ds.default_age_groups[0].min_competitors.should == 0
      ds.default_age_groups[1].name.should == 'P16'
      ds.default_age_groups[1].min_competitors.should == 0
    end
    
    it "should have N40 with several age groups as last series" do
      ds = DefaultSeries.all.last
      ds.name.should == 'N40'
      ds.default_age_groups.length.should == 8
    end
  end
end
