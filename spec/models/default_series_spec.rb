require 'spec_helper'

describe DefaultSeries do
  describe "#initialize" do
    it "should accept name and no default age groups" do
      ds = DefaultSeries.new('Test series')
      expect(ds.name).to eq('Test series')
    end
    
    it "should accept name and one age group with name and min_competitors" do
      ds = DefaultSeries.new('Series with age group', ['Age group', 5])
      expect(ds.name).to eq('Series with age group')
      expect(ds.default_age_groups[0].name).to eq('Age group')
      expect(ds.default_age_groups[0].min_competitors).to eq(5)
    end
    
    it "should accept name and multiple age groups with name and min_competitors" do
      ds = DefaultSeries.new('Series with age group', ['Age group', 5], ['Another age group', 1])
      expect(ds.name).to eq('Series with age group')
      expect(ds.default_age_groups.length).to eq(2)
      expect(ds.default_age_groups[1].name).to eq('Another age group')
      expect(ds.default_age_groups[1].min_competitors).to eq(1)
    end
  end
  
  describe ".all" do
    it "should contain DefaultSeries objects" do
      DefaultSeries.all.each do |ds|
        expect(ds).to be_a(DefaultSeries)
      end
    end
    
    it "should have S15 with T15,0/P15,0 as first series" do
      ds = DefaultSeries.all.first
      expect(ds.name).to eq('S15')
      expect(ds.default_age_groups[0].name).to eq('T15')
      expect(ds.default_age_groups[0].min_competitors).to eq(0)
      expect(ds.default_age_groups[1].name).to eq('P15')
      expect(ds.default_age_groups[1].min_competitors).to eq(0)
    end
    
    it "should have N50 with several age groups as last series" do
      ds = DefaultSeries.all.last
      expect(ds.name).to eq('N50')
      expect(ds.default_age_groups.length).to eq(7)
    end
  end
end
