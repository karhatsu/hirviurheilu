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

    it "should trim series names between commas" do
      cup_series = build(:cup_series, :name => 'Cup series', :series_names => '  M, M60  ,M70 ,M80   ')
      expect(cup_series.send(:series_names_as_array)).to eq(['M', 'M60', 'M70', 'M80'])
    end
  end

  describe "#series" do
    before do
      @cup_series_name = 'M'
      @cup = create :cup, include_always_last_race: true
      @cs = create :cup_series, :cup => @cup, :name => @cup_series_name
    end

    it "should return an empty array when no races" do
      expect(@cs.series).to eq([])
    end

    it "should return an empty array when races have no series" do
      @cup.races << create(:race)
      expect(@cs.series).to eq([])
    end

    it "should return all series that have a same name as any given series name" do
      series_name_condition = ['M', 'M50']
      expect(@cs).to receive(:series_names_as_array).at_least(1).times.and_return(series_name_condition)
      race1 = create_race(series_name_condition)
      race2 = create_race(series_name_condition)
      race3 = create_race(series_name_condition)
      unordered_races = double Object
      allow(@cup).to receive(:races).and_return(unordered_races)
      allow(unordered_races).to receive(:order).with(:start_date).and_return([race1, race2, race3])
      series = @cs.series
      expect(series.length).to eq(3)
      expect(series[0].name).to eq(@cup_series_name)
      expect(series[0].race).to eq(race1)
      expect(series[0].last_cup_race).to be_falsey
      expect(series[1].name).to eq(@cup_series_name)
      expect(series[1].race).to eq(race2)
      expect(series[1].last_cup_race).to be_falsey
      expect(series[2].name).to eq(@cup_series_name)
      expect(series[2].race).to eq(race3)
      expect(series[2].last_cup_race).to be_truthy
    end

    def create_race(series_name_condition)
      race = build(:race)
      series = build(:series, :race => race, :name => @cup_series_name)
      all_series = double(Object)
      allow(race).to receive(:series).and_return(all_series)
      allow(all_series).to receive(:where).with(:name => series_name_condition).and_return([series])
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
        series1 = create_series
        series2 = create_series
        series3 = create_series
        @cMM1 = competitor('Mikko', 'Miettinen', series1)
        @cMM2 = competitor('mikko', 'Miettinen', series2)
        @cMM3 = competitor('Mikko', 'miettinen', series3)
        @cTM1 = competitor('Timo', 'Miettinen', series1)
        @cTM3 = competitor('Timo', 'Miettinen', series3)
        @cMT1 = competitor('Mikko', 'Turunen', series1)
        @cAA2 = competitor('Aki', 'Aalto', series2)
        allow(series1).to receive(:competitors).and_return([@cMM1, @cTM1, @cMT1])
        allow(series2).to receive(:competitors).and_return([@cMM2, @cAA2])
        allow(series3).to receive(:competitors).and_return([@cMM3, @cTM3])
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

      def competitor(first_name, last_name, series)
        instance_double(Competitor, first_name: first_name, last_name: last_name, series: series)
      end

      def create_series
        series = instance_double Series, last_cup_race: false
        allow(series).to receive(:last_cup_race=)
        series
      end
    end
  end

  describe "#results" do
    before do
      @cs = build(:cup_series)
    end

    it "should return an empty array when no competitors" do
      allow(@cs).to receive(:cup_competitors).and_return([])
      expect(@cs.results).to eq([])
    end

    it 'should return cup competitors ordered by descending partial points, best single race points, best shot points' do
      cc1 = double(CupCompetitor, points!: 3004, points_array: [1000, 1001, 1003], shots_array: [600, 594, 588])
      cc2 = double(CupCompetitor, points!: 3004, points_array: [1004, 1000, 1000], shots_array: [600, 594, 588])
      cc3 = double(CupCompetitor, points!: 3000, points_array: [nil, nil, 3000], shots_array: [600, 594, 588])
      cc4 = double(CupCompetitor, points!: 3002, points_array: [999, 1001, 1002], shots_array: [600, 594, 588])
      cc5 = double(CupCompetitor, points!: nil, points_array: [nil, nil, nil], shots_array: [600, 594, 588])
      cc6 = double(CupCompetitor, points!: 3002, points_array: [1000, 1000, 1002], shots_array: [600, nil, 587])
      cc7 = double(CupCompetitor, points!: 3002, points_array: [1000, 1000, 1002], shots_array: [600, nil, 588])
      allow(@cs).to receive(:cup_competitors).and_return([cc1, cc2, cc3, cc4, cc5, cc6, cc7])
      expect(@cs.results).to eq([cc2, cc1, cc4, cc7, cc6, cc3, cc5])
    end
  end

  describe '#european_rifle_results' do
    let(:cs) { build :cup_series }
    let(:cc1) { double CupCompetitor, european_rifle_results: [] }
    let(:cc2) { double CupCompetitor, european_rifle_results: [400, 120] }
    let(:cc3) { double CupCompetitor, european_rifle_results: [400, 119] }
    let(:competitors) { [cc1, cc2, cc3] }

    before do
      allow(cs).to receive(:cup_competitors).and_return competitors
    end

    it 'sorts competitors by european_rifle_results arrays' do
      expect(cs.european_rifle_results).to eql [cc2, cc3, cc1]
    end
  end
end
