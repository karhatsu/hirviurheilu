require 'spec_helper'

describe Api::V2::Official::ShotsController, type: :api do
  describe 'PUT' do
    let(:api_secret) { 'very-secret-key' }
    let(:race) { create :race, sport_key: Sport::ILMALUODIKKO, api_secret: api_secret }
    let(:series) { create :series, race: race }
    let!(:competitor) { create :competitor, series: series, number: 99 }
    let(:default_value) { 9 }
    let(:body) { { value: default_value } }

    context 'when race has no API secret' do
      let(:race2) { create :race }

      before do
        race2.update_column :api_secret, ''
      end

      it 'returns 500' do
        make_request "/api/v2/official/races/#{race2.id}/competitors/#{competitor.number}/shots/1", body
        expect_status_code 401
      end
    end

    context 'when race not found' do
      it 'returns 404' do
        make_request "/api/v2/official/races/#{race.id + 10}/competitors/#{competitor.number}/shots/1", body
        expect_error 404, 'race not found'
      end
    end

    context 'when race found but wrong api key' do
      it 'returns 401' do
        make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/shots/1", body, 'wrong-key'
        expect_status_code 401
      end
    end

    context 'when race found and correct api key' do
      context 'but shot number is 0' do
        it 'returns 400' do
          make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/shots/0", body
          expect_error 400, 'invalid shot number'
        end
      end

      context 'but shot number is too big' do
        it 'returns 400' do
          make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/shots/#{race.sport.max_shots_count + 1}", body
          expect_error 400, 'invalid shot number'
        end
      end

      context 'but no shot value given' do
        it 'returns 400' do
          make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/shots/1", {}
          expect_error 400, 'invalid shot value'
        end
      end

      context 'but invalid shot value given' do
        it 'returns 400' do
          make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/shots/1", { value: 'foobar' }
          expect_error 400, 'invalid shot value'
        end
      end

      context 'but too big shot value given' do
        it 'returns 400' do
          make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/shots/1", { value: race.sport.max_shot + 1 }
          expect_error 400, 'invalid shot value'
        end
      end

      context 'but competitor not found by the given number' do
        it 'returns 404' do
          make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number + 1}/shots/1", body
          expect_error 404, 'competitor not found'
        end
      end

      context 'and first shot sent' do
        before do
          make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/shots/1", body
        end

        it 'returns 204 and saves the shot' do
          expect_success [default_value]
        end

        context 'and second shot sent' do
          let(:second_shot) { race.sport.max_shot }
          before do
            make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/shots/2", { value: second_shot }
          end

          it 'returns 204 and saves the shot' do
            expect_success [default_value, second_shot]
          end

          context 'and fourth shot sent before the third one' do
            let(:fourth_shot) { 8 }
            before do
              make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/shots/4", { value: fourth_shot }
            end

            it 'returns 204 and saves the 4th shot and 3rd shot as 0' do
              expect_success [default_value, second_shot, 0, fourth_shot]
            end

            context 'and third shot comes after that' do
              let(:third_shot) { 1 }
              before do
                make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/shots/3", { value: third_shot }
              end

              it 'returns 204 and saves the 3rd but also keeps the 4th shot' do
                expect_success [default_value, second_shot, third_shot, fourth_shot]
              end
            end
          end
        end

        context 'and the same shot is sent again with different value' do
          before do
            make_request "/api/v2/official/races/#{race.id}/competitors/#{competitor.number}/shots/1", { value: 2 }
          end

          it 'overrides the existing value' do
            expect_success [2]
          end
        end
      end
    end

    def make_request(path, body, api_secret_header = api_secret)
      put path, body.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => api_secret_header }
    end

    def expect_error(status, error_message)
      expect_status_code status
      expect_json({ errors: [error_message] })
    end

    def expect_success(shots)
      expect_status_code 200
      expect_json({ shots: shots })
      expect(competitor.reload.shots).to eql shots
    end
  end
end
