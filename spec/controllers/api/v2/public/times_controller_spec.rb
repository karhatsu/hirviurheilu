require 'spec_helper'

describe Api::V2::Public::TimesController, type: :api do
  context 'when race not found' do
    it 'returns 404' do
      get '/api/v2/public/races/99/times'
      expect_status_code 404
    end
  end

  context 'when race found' do
    let(:race) { create :race }
    let(:series) { create :series, race: race }
    let(:start_time) { '00:05:30' }
    let(:shooting_start_time) { '00:09:11' }
    let(:shooting_finish_time) { '00:10:55' }
    let(:arrival_time) { '00:20:12' }
    let!(:competitor) { create :competitor, series: series, number: 123, start_time: start_time,
                               arrival_time: arrival_time, shooting_start_time: shooting_start_time,
                               shooting_finish_time: shooting_finish_time }

    before do
      get "/api/v2/public/races/#{race.id}/times"
    end

    it 'returns 200' do
      expect_status_code 200
    end

    it 'returns competitors and their times' do
      json = {
          competitors: [
              {
                  first_name: competitor.first_name,
                  last_name: competitor.last_name,
                  number: competitor.number,
                  start_time: start_time,
                  arrival_time: arrival_time,
                  shooting_start_time: shooting_start_time,
                  shooting_finish_time: shooting_finish_time,
                  series: {
                      name: series.name
                  }
              }
          ]
      }
      expect_json(json)
    end
  end
end
