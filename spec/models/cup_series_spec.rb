require 'spec_helper'

describe CupSeries do
  it "create" do
    create(:cup_series)
  end
  
  describe "associations" do
    it { is_expected.to belong_to(:cup) }
  end
  
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
  
  describe "#has_single_series_with_same_name?" do
    it "should return true when series_names is nil" do
      cup_series = build(:cup_series, :series_names => nil)
      expect(cup_series).to have_single_series_with_same_name
    end
    
    it "should return true when series_names is empty string" do
      cup_series = build(:cup_series, :series_names => '')
      expect(cup_series).to have_single_series_with_same_name
    end
    
    it "should return true when series_names is same as cup series name" do
      cup_series = build(:cup_series, :name => 'M', :series_names => 'M')
      expect(cup_series).to have_single_series_with_same_name
    end
    
    it "should return false when series_names differs from cup series name" do
      cup_series = build(:cup_series, :name => 'Men', :series_names => 'M')
      expect(cup_series).not_to have_single_series_with_same_name
    end
  end
  
  describe "#series_names_as_array" do
    it "should return cup series name as an array when series_names is nil" do
      cup_series = build(:cup_series, :name => 'Cup series', :series_names => nil)
      expect(cup_series.send(:series_names_as_array)).to eq(['Cup series'])
    end
    
    it "should return cup series name as an array when series_names is empty string" do
      cup_series = build(:cup_series, :name => 'Cup series', :series_names => '')
      expect(cup_series.send(:series_names_as_array)).to eq(['Cup series'])
    end
    
    it "should return cup series name as an array when series_names is string with spaces" do
      cup_series = build(:cup_series, :name => 'Cup series', :series_names => '  ')
      expect(cup_series.send(:series_names_as_array)).to eq(['Cup series'])
    end
    
    it "should return series_names split by comma when series_names given" do
      cup_series = build(:cup_series, :name => 'Cup series', :series_names => 'M,M60,M70')
      expect(cup_series.send(:series_names_as_array)).to eq(['M', 'M60', 'M70'])
    end
    
    it "should return series_names split by comma when series_names with trailing spaces given" do
      cup_series = build(:cup_series, :name => 'Cup series', :series_names => '  M,M60,M70   ')
      expect(cup_series.send(:series_names_as_array)).to eq(['M', 'M60', 'M70'])
    end
  end
  
  describe "#series" do
    before do
      @cup_series_name = 'M'
      @cup = build(:cup)
      @cs = build(:cup_series, :cup => @cup, :name => @cup_series_name)
    end

    it "should return an empty array when no races" do
      expect(@cs.series).to eq([])
    end
    
    it "should return an empty array when races have no series" do
      allow(@cup).to receive(:races).and_return([build(:race)])
      expect(@cs.series).to eq([])
    end
    
    it "should return all series that have a same name as any given series name" do
      name_condition = ['M', 'M50']
      expect(@cs).to receive(:series_names_as_array).at_least(1).times.and_return(name_condition)
      race1 = create_race(name_condition)
      race2 = create_race(name_condition)
      race3 = create_race(name_condition)
      allow(@cup).to receive(:races).and_return([race1, race2, race3])
      series = @cs.series
      expect(series.length).to eq(3)
      expect(series[0].name).to eq(@cup_series_name)
      expect(series[0].race).to eq(race1)
      expect(series[1].name).to eq(@cup_series_name)
      expect(series[1].race).to eq(race2)
      expect(series[2].name).to eq(@cup_series_name)
      expect(series[2].race).to eq(race3)
    end
    
    def create_race(name_condition)
      race = build(:race)
      series = build(:series, :race => race, :name => @cup_series_name)
      all_series = double(Object)
      allow(race).to receive(:series).and_return(all_series)
      allow(all_series).to receive(:where).with(:name => name_condition).and_return([series])
      race
    end
  end

  describe "#cup_competitors" do
    before do
      @series1 = build(:series)
      @cs = build(:cup_series)
    end
    
    context "when no competitors in series" do
      it "should return an empty array" do
        series = instance_double(Series, :competitors => [])
        allow(@cs).to receive(:series).and_return([series])
        expect(@cs.cup_competitors).to eq([])
      end
    end
    
    context "when competitors in series" do
      before do
        @cMM1 = competitor('Mikko', 'Miettinen')
        @cMM2 = competitor('mikko', 'Miettinen')
        @cMM3 = competitor('Mikko', 'miettinen')
        @cTM1 = competitor('Timo', 'Miettinen')
        @cTM3 = competitor('Timo', 'Miettinen')
        @cMT1 = competitor('Mikko', 'Turunen')
        @cAA2 = competitor('Aki', 'Aalto')
        series1 = instance_double(Series, :competitors => [@cMM1, @cTM1, @cMT1])
        series2 = instance_double(Series, :competitors => [@cMM2, @cAA2])
        series3 = instance_double(Series, :competitors => [@cMM3, @cTM3])
        allow(@cs).to receive(:series).and_return([series1, series2, series3])
      end
      
      it "should return cup competitors created based on competitors' first and last name (case ins.)" do
        cup_competitors = @cs.cup_competitors
        expect(cup_competitors.length).to eq(4)
        expect(cup_competitors[0].competitors[0]).to eq(@cMM1)
        expect(cup_competitors[0].competitors[1]).to eq(@cMM2)
        expect(cup_competitors[0].competitors[2]).to eq(@cMM3)
        expect(cup_competitors[1].competitors[0]).to eq(@cTM1)
        expect(cup_competitors[1].competitors[1]).to eq(@cTM3)
        expect(cup_competitors[2].competitors[0]).to eq(@cMT1)
        expect(cup_competitors[3].competitors[0]).to eq(@cAA2)
      end
      
      def competitor(first_name, last_name)
        instance_double(Competitor, :first_name => first_name, :last_name => last_name)
      end
    end
  end
  
  describe "#ordered_competitors" do
    before do
      @cs = build(:cup_series)
    end
    
    it "should return an empty array when no competitors" do
      allow(@cs).to receive(:cup_competitors).and_return([])
      expect(@cs.ordered_competitors).to eq([])
    end
    
    it "should return cup competitors ordered by descending partial points" do
      cc1 = double(CupCompetitor, :points! => 3003)
      cc2 = double(CupCompetitor, :points! => 3004)
      cc3 = double(CupCompetitor, :points! => 3000)
      cc4 = double(CupCompetitor, :points! => 3002)
      cc5 = double(CupCompetitor, :points! => nil)
      cc6 = double(CupCompetitor, :points! => 3001)
      allow(@cs).to receive(:cup_competitors).and_return([cc1, cc2, cc3, cc4, cc5, cc6])
      expect(@cs.ordered_competitors).to eq([cc2, cc1, cc4, cc6, cc3, cc5])
    end
  end
end
