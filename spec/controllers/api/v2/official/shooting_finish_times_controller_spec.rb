require 'spec_helper'

describe Api::V2::Official::ShootingFinishTimesController, type: :api do
  let(:time_field) { 'shooting_finish_time' }
  let(:expected_validation_error) { 'Ammunnan lopetusaika pitää olla lähtöajan jälkeen' }
  let(:invalid_ms_since_midnight) { calculate_ms_since_midnight race.start_time.hour, 0, 0 }

  it_behaves_like 'times v2 API'
end
