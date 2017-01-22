require 'spec_helper'

describe Api::V1::ArrivalTimesController, type: :api do
  let(:time_field) { 'arrival_time' }
  let(:expected_validation_error) { 'Saapumisaika pitää olla lähtöajan jälkeen' }
  let(:invalid_body) { build_invalid_body }

  def build_invalid_body
    ms_since_midnight = calculate_ms_since_midnight race.start_time.hour, 0, 0
    body[:ms_since_midnight] = ms_since_midnight
    body[:checksum] = md5 "#{ms_since_midnight}#{api_secret}"
    body
  end

  it_behaves_like 'times API'
end