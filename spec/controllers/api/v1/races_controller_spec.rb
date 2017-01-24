require 'spec_helper'

describe Api::V1::RacesController, type: :api do
  context 'when race not found' do
    it 'returns 404' do
      get '/api/v1/races/99'
      expect_status_code 404
    end
  end

  context 'when race found' do
    let(:race) { create :race }

    before do
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
          }
      }
      expect_json(json)
    end

    it 'returns 200 with race data' do
      expect_status_code 200
    end
  end
end
