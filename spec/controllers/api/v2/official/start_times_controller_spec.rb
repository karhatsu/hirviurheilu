require 'spec_helper'

describe Api::V2::Official::StartTimesController, type: :api do
  let(:time_field) { 'start_time' }
  let(:expected_validation_error) { 'Lähtöaika on liian iso (lähtöajat alkavat lukemasta 00:00:00)' }
  let(:invalid_ms_since_midnight) { calculate_ms_since_midnight 23, 0, 0 }

  it_behaves_like 'times v2 API'
end
