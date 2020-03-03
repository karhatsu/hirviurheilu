require 'spec_helper'

describe Api::V1::AuthenticationChecksController, type: :api do
  describe 'GET' do
    let(:api_secret) { 'so-secret-key' }
    let(:race_name) { 'My race' }
    let(:race) { create :race, name: race_name, api_secret: api_secret }

    context 'when race not found' do
      it 'returns 404' do
        make_request "/api/v1/races/#{race.id + 10}/authentication_check", api_secret
        expect_status_code 404
        expect_json({ error: 'race not found' })
      end
    end

    context 'when race found but wrong api key' do
      it 'returns 401' do
        make_request "/api/v1/races/#{race.id}/authentication_check", 'wrong-key'
        expect_status_code 401
      end
    end

    context 'when race found and correct api key' do
      it 'returns 200 with race name' do
        make_request "/api/v1/races/#{race.id}/authentication_check", api_secret
        expect_status_code 200
        expect_json({ race: race_name })
      end
    end

    def make_request(path, api_secret)
      get path, nil, { 'CONTENT_TYPE' => 'application/json', 'HTTP_X_API_SECRET' => api_secret }
    end
  end
end
