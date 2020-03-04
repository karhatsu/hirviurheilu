shared_examples_for 'times v1 API' do
  let(:api_secret) { 'really-secret' }
  let(:race_start_time) { '10:00' }
  let(:ms_since_midnight) { calculate_ms_since_midnight(10 + 2, 15, 20) } # 02:15:20
  let(:body) {
    {
        ms_since_midnight: ms_since_midnight,
        checksum: md5("#{ms_since_midnight}#{api_secret}")
    }
  }

  def md5(message)
    Digest::MD5.hexdigest message
  end

  context 'when race not found' do
    it 'returns 404' do
      put_request "/api/v1/races/10/competitors/15/#{time_field}", body
      expect_status_code 404
    end
  end

  context 'when race found' do
    let(:race) { create :race, api_secret: api_secret, start_time: race_start_time }

    context 'but competitor not found' do
      it 'returns 404' do
        put_request "/api/v1/races/#{race.id}/competitors/15/#{time_field}", body
        expect_status_code 404
      end
    end

    context 'and competitor found' do
      let(:series) { create :series, race: race }
      let(:competitor) { create :competitor, series: series, start_time: '01:00:00', number: 123 }

      context 'but race has no api secret defined' do
        before do
          race.update_attribute :api_secret, ''
          put_request "/api/v1/races/#{race.id}/competitors/#{competitor.number}/#{time_field}", body
        end

        it 'returns 500' do
          expect_status_code 500
        end

        it 'returns error' do
          expect_json({errors: ['Race not configured for API usage']})
        end
      end

      context 'and request is valid' do
        before do
          put_request "/api/v1/races/#{race.id}/competitors/#{competitor.number}/#{time_field}", body
        end

        it 'returns 201' do
          expect_status_code 201
        end

        it 'saves start time for the competitor' do
          expect(competitor.reload[time_field].strftime('%H:%M:%S')).to eql '02:15:20'
        end
      end

      context 'but content is missing' do
        before do
          body[:ms_since_midnight] = nil
          put_request "/api/v1/races/#{race.id}/competitors/#{competitor.number}/#{time_field}", body
        end

        it 'returns 400' do
          expect_status_code 400
        end

        it 'returns validation errors in the body' do
          expect_json({errors: ['ms_since_midnight missing']})
        end
      end

      context 'but content is invalid for the competitor' do
        before do
          put_request "/api/v1/races/#{race.id}/competitors/#{competitor.number}/#{time_field}", build_invalid_body
        end

        it 'returns 400' do
          expect_status_code 400
        end

        it 'returns validation errors in the body' do
          expect_json({errors: [expected_validation_error]})
        end
      end

      context 'but checksum is invalid' do
        before do
          body[:checksum] = 'wrong'
          put_request "/api/v1/races/#{race.id}/competitors/#{competitor.number}/#{time_field}", body
        end

        it 'returns 400' do
          expect_status_code 400
        end

        it 'returns hash error in the body' do
          expect_json({errors: ['Invalid checksum']})
        end
      end
    end
  end
end

shared_examples_for 'times v2 API' do
  let(:api_secret) { 'really-secret' }
  let(:race_start_time) { '10:00' }
  let(:race) { create :race, api_secret: api_secret, start_time: race_start_time }
  let(:series) { create :series, race: race }
  let(:competitor) { create :competitor, series: series, start_time: '01:00:00', number: 123 }
  let(:ms_since_midnight) { calculate_ms_since_midnight(10 + 2, 15, 20) } # 02:15:20
  let(:body) {
    {
        ms_since_midnight: ms_since_midnight
    }
  }

  context 'when race not found' do
    it 'returns 404' do
      send_request "/api/v1/races/10/competitors/15/#{time_field}", body, api_secret
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

        it 'returns 201' do
          expect_status_code 201
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
