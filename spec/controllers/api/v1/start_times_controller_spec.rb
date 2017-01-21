require 'spec_helper'

describe Api::V1::StartTimesController, type: :api do
  let(:race_start_time) { '10:00' }
  let(:body) { {ms_since_midnight: ms_since_midnigh(10 + 2, 15, 20)} } # 02:15:20

  def ms_since_midnigh(hours, minutes, seconds)
    1000 * (seconds + 60 * (minutes + 60 * hours))
  end

  context 'when race not found' do
    it 'returns 404' do
      put_request '/api/v1/races/10/competitors/15/start_times', body
      expect_status_code 404
    end
  end

  context 'when race found' do
    let(:race) { create :race, start_time: race_start_time }

    context 'but competitor not found' do
      it 'returns 404' do
        put_request "/api/v1/races/#{race.id}/competitors/15/start_times", body
        expect_status_code 404
      end
    end

    context 'and competitor found' do
      let(:series) { create :series, race: race }
      let(:competitor) { create :competitor, series: series }

      context 'and request is valid' do
        before do
          put_request "/api/v1/races/#{race.id}/competitors/#{competitor.id}/start_times", body
        end

        it 'returns 201' do
          expect_status_code 201
        end

        it 'saves start time for the competitor' do
          expect(competitor.reload.start_time.strftime('%H:%M:%S')).to eql '02:15:20'
        end
      end

      context 'but content is invalid' do
        before do
          put_request "/api/v1/races/#{race.id}/competitors/#{competitor.id}/start_times",
                      {ms_since_midnight: ms_since_midnigh(23, 0, 0)}
        end

        it 'returns 400' do
          expect_status_code 400
        end

        it 'returns validation errors in the body' do
          expect_json({errors: ['Lähtöaika on liian iso (lähtöajat alkavat lukemasta 00:00:00)']})
        end
      end
    end
  end
end