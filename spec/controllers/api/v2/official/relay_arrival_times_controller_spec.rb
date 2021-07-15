require 'spec_helper'

describe Api::V2::Official::RelayArrivalTimesController, type: :api do
  let(:api_secret) { 'really-secret-123' }
  let(:relay_start_time) { '10:00' }
  let(:relative_time) { '02:15:20' }
  let(:real_time) { '12:15:20' }
  let(:legs_count) { 3 }
  let(:race) { create :race, api_secret: api_secret }
  let(:relay) { create :relay, race: race, legs_count: legs_count, start_time: relay_start_time }
  let(:relay_team) { create :relay_team, relay: relay, number: 5 }
  let!(:relay_competitor_1) { create :relay_competitor, relay_team: relay_team, leg: 1 }
  let!(:relay_competitor_2) { create :relay_competitor, relay_team: relay_team, leg: 2 }
  let!(:relay_competitor_3) { create :relay_competitor, relay_team: relay_team, leg: 3 }
  let(:body) {
    {
      ms_since_midnight: calculate_ms_since_midnight(12, 15, 20)
    }
  }

  context 'when race not found' do
    it 'returns 404' do
      send_request "/api/v2/official/races/10/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/1/arrival_time", body, api_secret
      expect_status_code 404
    end
  end

  context 'when race has no api secret' do
    before do
      race.update_attribute :api_secret, ''
      send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/1/arrival_time", body, api_secret
    end

    it 'returns 401' do
      expect_status_code 401
    end
  end

  context 'when api secret is invalid' do
    it 'returns 401' do
      send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/1/arrival_time", body, 'not-correct'
      expect_status_code 401
    end
  end

  context 'when relay not found' do
    it 'returns 404' do
      send_request "/api/v2/official/races/#{race.id}/relays/999/relay_teams/#{relay_team.number}/legs/1/arrival_time", body, api_secret
      expect_status_code 404
      expect_json({errors: ['relay not found']})
    end
  end

  context 'when relay team not found' do
    it 'returns 404' do
      send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number + 1}/legs/1/arrival_time", body, api_secret
      expect_status_code 404
      expect_json({errors: ['relay team not found']})
    end
  end

  context 'when leg is invalid' do
    it 'returns 404' do
      send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/0/arrival_time", body, api_secret
      expect_status_code 400
      expect_json({errors: ['invalid leg number']})
    end
  end

  context 'when leg is too big' do
    it 'returns 404' do
      send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/#{legs_count + 1}/arrival_time", body, api_secret
      expect_status_code 400
      expect_json({errors: ['invalid leg number']})
    end
  end

  context 'when content is missing' do
    before do
      body[:ms_since_midnight] = nil
      send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/1/arrival_time", body, api_secret
    end

    it 'returns 400' do
      expect_status_code 400
      expect_json({errors: ['ms_since_midnight missing']})
    end
  end

  context 'when relay is missing start time' do
    before do
      relay.update_attribute :start_time, nil
      send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/1/arrival_time", body, api_secret
    end

    it 'returns 400' do
      expect_status_code 400
      expect_json({errors: ['cannot use api for relay that has no start time']})
    end
  end

  context 'when given time is less than relay start time' do
    before do
      ms_since_midnight = calculate_ms_since_midnight 9, 59, 59
      send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/1/arrival_time", { ms_since_midnight: ms_since_midnight }, api_secret
    end

    it 'returns 400' do
      expect_status_code 400
      expect_json({errors: ['ms_since_midnight cannot be before relay start']})
    end
  end

  context 'when valid request for leg number 1' do
    before do
      send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/1/arrival_time", body, api_secret
    end

    it 'returns 200 with relative time' do
      expect_status_code 200
      expect_json({ relative_time: relative_time })
    end

    it 'saves arrival time for the relay competitor' do
      expect(relay_competitor_1.reload.arrival_time.strftime('%H:%M:%S')).to eql '02:15:20'
    end

    context 'and invalid request for the leg number 2' do
      before do
        send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/2/arrival_time", body, api_secret
      end

      it 'returns 400' do
        expect_status_code 400
        expect_json({errors: ['Saapumisaika pitää olla lähtöajan jälkeen']})
      end
    end

    context 'and valid request for the leg number 2' do
      before do
        body = { ms_since_midnight: calculate_ms_since_midnight(12, 30, 21) }
        send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/2/arrival_time", body, api_secret
      end

      it 'returns 200 with relative time' do
        expect_status_code 200
        expect_json({ relative_time: '02:30:21' })
      end

      it 'saves arrival time for the relay competitor' do
        expect(relay_competitor_2.reload.arrival_time.strftime('%H:%M:%S')).to eql '02:30:21'
      end

      context 'and valid request for the leg number 2' do
        before do
          body = { ms_since_midnight: calculate_ms_since_midnight(13, 00, 59) }
          send_request "/api/v2/official/races/#{race.id}/relays/#{relay.id}/relay_teams/#{relay_team.number}/legs/3/arrival_time", body, api_secret
        end

        it 'returns 200 with relative time' do
          expect_status_code 200
          expect_json({ relative_time: '03:00:59' })
        end

        it 'saves arrival time for the relay competitor' do
          expect(relay_competitor_3.reload.arrival_time.strftime('%H:%M:%S')).to eql '03:00:59'
        end
      end
    end
  end

  def send_request(path, body, api_secret)
    put path, body.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => api_secret }
  end
end
