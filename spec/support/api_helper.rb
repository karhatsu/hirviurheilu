module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def put_request(path, body)
    put path, body.to_json, { 'CONTENT_TYPE' => 'application/json' }
  end

  def expect_status_code(status_code)
    expect(last_response.status).to eq status_code
  end

  def expect_json(json)
    expect(last_response.body).to include_json(json)
  end

  shared_examples_for 'times API' do
    let(:api_secret) { 'really-secret' }
    let(:race_start_time) { '10:00' }
    let(:ms_since_midnight) { calculate_ms_since_midnight(10 + 2, 15, 20) } # 02:15:20
    let(:body) {
      {
          ms_since_midnight: ms_since_midnight,
          checksum: md5("#{ms_since_midnight}#{api_secret}")
      }
    }

    def calculate_ms_since_midnight(hours, minutes, seconds)
      1000 * (seconds + 60 * (minutes + 60 * hours))
    end

    def md5(message)
      Digest::MD5.hexdigest message
    end

    context 'when race not found' do
      it 'returns 404' do
        put_request "/api/v1/races/10/competitors/15/#{api_times_string}", body
        expect_status_code 404
      end
    end

    context 'when race found' do
      let(:race) { create :race, api_secret: api_secret, start_time: race_start_time }

      context 'but competitor not found' do
        it 'returns 404' do
          put_request "/api/v1/races/#{race.id}/competitors/15/#{api_times_string}", body
          expect_status_code 404
        end
      end

      context 'and competitor found' do
        let(:series) { create :series, race: race }
        let(:competitor) { create :competitor, series: series }

        context 'and request is valid' do
          before do
            put_request "/api/v1/races/#{race.id}/competitors/#{competitor.id}/#{api_times_string}", body
          end

          it 'returns 201' do
            expect_status_code 201
          end

          it 'saves start time for the competitor' do
            expect(competitor.reload[time_field].strftime('%H:%M:%S')).to eql '02:15:20'
          end
        end

        context 'but content is invalid' do
          before do
            ms_since_midnight = calculate_ms_since_midnight 23, 0, 0
            body[:ms_since_midnight] = ms_since_midnight
            body[:checksum] = md5 "#{ms_since_midnight}#{api_secret}"
            put_request "/api/v1/races/#{race.id}/competitors/#{competitor.id}/#{api_times_string}", body
          end

          it 'returns 400' do
            expect_status_code 400
          end

          it 'returns validation errors in the body' do
            expect_json({errors: ['Lähtöaika on liian iso (lähtöajat alkavat lukemasta 00:00:00)']})
          end
        end

        context 'but checksum is invalid' do
          before do
            body[:checksum] = 'wrong'
            put_request "/api/v1/races/#{race.id}/competitors/#{competitor.id}/#{api_times_string}", body
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
end

RSpec.configure do |config|
  config.include ApiHelper, type: :api
  config.include Rails.application.routes.url_helpers, type: :api
end
