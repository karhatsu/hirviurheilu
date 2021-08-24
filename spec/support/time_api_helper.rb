shared_examples_for 'times v2 API' do
  let(:api_secret) { 'really-secret' }
  let(:race_start_time) { '10:00' }
  let(:relative_time) { '02:15:20' }
  let(:real_time) { '12:15:20' }
  let(:ms_since_midnight) { calculate_ms_since_midnight(12, 15, 20) }
  let(:race) { create :race, api_secret: api_secret, start_time: race_start_time }
  let(:series) { create :series, race: race }
  let(:competitor) { create :competitor, series: series, start_time: '01:00:00', number: 123 }
  let(:body) {
    {
        ms_since_midnight: ms_since_midnight
    }
  }

  context 'when race not found' do
    it 'returns 404' do
      send_request "/api/v2/official/races/10/competitors/#{competitor.number}/#{time_field}", body, api_secret
      expect_status_code 404
    end
  end

  context 'when race has no api secret' do
    before do
      race.update_attribute :api_secret, ''
      send_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/#{time_field}", body, api_secret
    end

    it 'returns 401' do
      expect_status_code 401
    end
  end

  context 'when api secret is invalid' do
    it 'returns 401' do
      send_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/#{time_field}", body, 'not-correct'
      expect_status_code 401
    end
  end

  context 'when race found' do
    context 'but competitor not found' do
      it 'returns 404' do
        send_request "/api/v2/official/races/#{race.id}/competitors/15/#{time_field}", body, api_secret
        expect_status_code 404
        expect_json({errors: ['competitor not found']})
      end
    end

    context 'and competitor found' do
      context 'and request is valid' do
        before do
          send_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/#{time_field}", body, api_secret
        end

        it 'returns 200 with absolute and relative time' do
          expect_status_code 200
          expect_json({ real_time: real_time, relative_time: relative_time })
        end

        it 'saves start time for the competitor' do
          expect(competitor.reload[time_field].strftime('%H:%M:%S')).to eql '02:15:20'
        end
      end

      context 'but content is missing' do
        before do
          body[:ms_since_midnight] = nil
          send_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/#{time_field}", body, api_secret
        end

        it 'returns 400' do
          expect_status_code 400
          expect_json({errors: ['ms_since_midnight missing']})
        end
      end

      context 'but content is invalid for the competitor' do
        before do
          send_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/#{time_field}", build_invalid_body, api_secret
        end

        it 'returns 400' do
          expect_status_code 400
          expect_json({errors: [expected_validation_error]})
        end
      end

      context 'and given time is less than race start time' do
        before do
          ms_since_midnight = calculate_ms_since_midnight 9, 59, 59
          send_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/#{time_field}", { ms_since_midnight: ms_since_midnight }, api_secret
        end

        it 'returns 400' do
          expect_status_code 400
          expect_json({errors: ['ms_since_midnight cannot be before race start']})
        end
      end
    end
  end

  def build_invalid_body
    body[:ms_since_midnight] = invalid_ms_since_midnight
    body
  end

  def send_request(path, body, api_secret)
    put path, body.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => api_secret }
  end
end

def calculate_ms_since_midnight(hours, minutes, seconds)
  1000 * (seconds + 60 * (minutes + 60 * hours))
end
