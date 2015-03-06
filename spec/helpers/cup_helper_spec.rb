require 'spec_helper'

describe CupHelper do
  describe '#cup_points_print' do
    it 'should print points in case they are available' do
      competitor = double(CupCompetitor)
      expect(competitor).to receive(:points).and_return(2000)
      expect(helper.cup_points_print(competitor)).to eq('2000')
    end

    it 'should print points in brackets if only partial points are available' do
      competitor = double(CupCompetitor)
      expect(competitor).to receive(:points).and_return(nil)
      expect(competitor).to receive(:points!).and_return(1000)
      expect(helper.cup_points_print(competitor)).to eq('(1000)')
    end

    it "should print '-' if no points at all" do
      competitor = double(CupCompetitor)
      expect(competitor).to receive(:points).and_return(nil)
      expect(competitor).to receive(:points!).and_return(nil)
      expect(helper.cup_points_print(competitor)).to eq('-')
    end
  end

  describe '#long_cup_series_name' do
    it 'should be cup series name when no series names' do
      cs = build(:cup_series, :name => 'Series')
      expect(cs).to receive(:has_single_series_with_same_name?).and_return(true)
      expect(helper.long_cup_series_name(cs)).to eq('Series')
    end

    it 'should be cup series name and series names in brackets when given' do
      cs = build(:cup_series, :name => 'Series', :series_names => 'M,M50,M80')
      expect(cs).to receive(:has_single_series_with_same_name?).and_return(false)
      expect(helper.long_cup_series_name(cs)).to eq('Series (M, M50, M80)')
    end
  end
end