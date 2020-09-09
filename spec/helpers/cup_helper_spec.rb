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

  describe '#min_points_to_emphasize' do
    let(:cup_competitors) { [] }

    context 'when race count is less than top competitions count' do
      before do
        cup_competitors << build_cup_competitor(500)
      end

      it 'returns nil' do
        expect(helper.min_points_to_emphasize(1, 2, cup_competitors)).to be_nil
      end
    end

    context 'when race count equals top competitions count' do
      before do
        cup_competitors << build_cup_competitor(500)
        cup_competitors << build_cup_competitor(501)
      end

      it 'returns nil' do
        expect(helper.min_points_to_emphasize(2, 2, cup_competitors)).to be_nil
      end
    end

    context 'when race count is bigger than top competitions count' do
      let(:race_count) { 3 }
      let(:top_competitions) { 2 }

      context 'but not enough competitor results compared to min competitions' do
        before do
          cup_competitors << build_cup_competitor(500)
          cup_competitors << build_cup_competitor(nil)
        end

        it 'returns nil' do
          expect(helper.min_points_to_emphasize(race_count, top_competitions, cup_competitors)).to be_nil
        end
      end

      context 'when enough cup competitor results compared to min competitions' do
        before do
          cup_competitors << build_cup_competitor(449)
          cup_competitors << build_cup_competitor(500)
          cup_competitors << build_cup_competitor(450)
        end

        it 'returns the smallest points that are counted to the total result' do
          expect(helper.min_points_to_emphasize(race_count, top_competitions, cup_competitors)).to eql 450
        end
      end

      context 'when rifle' do
        let(:race_count) { 4 }
        let(:top_competitions) { 3 }

        before do
          cup_competitors << build_cup_competitor(261, true)
          cup_competitors << build_cup_competitor(259, true)
          cup_competitors << build_cup_competitor(258, true)
          cup_competitors << build_cup_competitor(nil, true)
          cup_competitors << build_cup_competitor(260, true)
        end

        it 'does the selection using rifle score' do
          expect(helper.min_points_to_emphasize(race_count, top_competitions, cup_competitors, true)).to eql 259
        end
      end
    end

    def build_cup_competitor(points, rifle = false)
      competitor = double CupCompetitor
      if rifle
        allow(competitor).to receive(:european_rifle_score).and_return(points)
      else
        allow(competitor).to receive(:points).and_return(points)
      end
      competitor
    end
  end
end
