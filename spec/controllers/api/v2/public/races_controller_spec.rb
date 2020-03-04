require 'spec_helper'

describe Api::V2::Public::RacesController, type: :api do
  context 'when race not found' do
    it 'returns 404' do
      get '/api/v2/public/races/99'
      expect_status_code 404
    end
  end

  context 'when race found' do
    let(:club) { create :club }
    let(:race) { create :race, start_time: '10:30' }
    let(:series) { create :series, race: race }
    let!(:competitor) { create :competitor, series: series, number: 123, club: club }

    before do
      get "/api/v2/public/races/#{race.id}"
    end

    it 'returns 200' do
      expect_status_code 200
    end

    it 'returns race data' do
      json = {
          name: race.name,
          location: race.location,
          start_date: api_date(race.start_date),
          end_date: api_date(race.end_date),
          start_time: '10:30:00',
          organizer: race.organizer,
          sport_name: 'Hirvenhiihto',
          series: [
              {
                  name: series.name,
                  competitors: [
                      {
                          first_name: competitor.first_name,
                          last_name: competitor.last_name,
                          number: competitor.number,
                          start_datetime: competitor.start_datetime,
                          club: {
                              name: club.name
                          }
                      }
                  ]
              }
          ]
      }
      expect_json(json)
    end
  end
end
