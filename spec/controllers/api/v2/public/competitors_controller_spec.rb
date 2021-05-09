require 'spec_helper'

describe Api::V2::Public::CompetitorsController, type: :api do
  let(:competitor_number) { 135 }

  context 'when race not found' do
    it 'returns 404' do
      get "/api/v2/public/races/99/competitors/#{competitor_number}"
      expect_status_code 404
    end
  end

  context 'when race found' do
    let(:race) { create :race }
    let(:series) { create :series, race: race }
    let(:shots) { [10, 9, 1, 8, 0, 10, 10] }
    let(:extra_shots) { [10, 9] }
    let!(:competitor) { create :competitor, series: series, number: competitor_number, shots: shots, extra_shots: extra_shots }

    describe 'but unknown competitor number' do
      it 'returns 404' do
        get "/api/v2/public/races/#{race.id}/competitors/#{competitor_number * 10}"
        expect_status_code 404
      end
    end

    describe 'and known competitor number' do
      before do
        get "/api/v2/public/races/#{race.id}/competitors/#{competitor_number}"
      end

      it 'returns 200' do
        expect_status_code 200
      end

      it 'returns competitor' do
        json = {
          first_name: competitor.first_name,
          last_name: competitor.last_name,
          number: competitor_number,
          shots: shots,
          extra_shots: extra_shots,
          series: {
            name: series.name
          }
        }
        expect_json(json)
      end
    end
  end
end
