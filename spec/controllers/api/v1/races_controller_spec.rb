require 'spec_helper'

describe Api::V1::RacesController, type: :api do
  context 'when race not found' do
    it 'returns 404' do
      get '/api/v1/races/99'
      expect_status_code 404
    end
  end

  context 'when race found' do
    let(:club) { create :club }
    let(:race) { create :race }
    let(:series) { create :series, race: race }
    let(:competitor) { create :competitor, series: series, number: 123, club: club }

    before do
      competitor
      get "/api/v1/races/#{race.id}"
      json = {
          name: race.name,
          location: race.location,
          start_date: api_date(race.start_date),
          end_date: api_date(race.end_date),
          short_start_time: race.short_start_time,
          organizer: race.organizer,
          sport: {
              name: 'Hirvenhiihto'
          },
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

    it 'returns 200 with race data' do
      expect_status_code 200
    end
  end
end
