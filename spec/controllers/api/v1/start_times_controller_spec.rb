require 'spec_helper'

describe Api::V1::StartTimesController, type: :api do
  let(:api_times_string) { 'start_times' }
  let(:time_field) { 'start_time' }
  let(:expected_validation_error) { 'Lähtöaika on liian iso (lähtöajat alkavat lukemasta 00:00:00)' }
  let(:invalid_body) { build_invalid_body }

  def build_invalid_body
    ms_since_midnight = calculate_ms_since_midnight 23, 0, 0
    body[:ms_since_midnight] = ms_since_midnight
    body[:checksum] = md5 "#{ms_since_midnight}#{api_secret}"
    body
  end

  it_behaves_like 'times API'
end