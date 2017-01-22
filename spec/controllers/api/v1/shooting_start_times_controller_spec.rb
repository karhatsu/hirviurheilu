require 'spec_helper'

describe Api::V1::ShootingStartTimesController, type: :api do
  let(:time_field) { 'shooting_start_time' }
  let(:expected_validation_error) { 'Ammunnan aloitusaika pitää olla lähtöajan jälkeen' }
  let(:invalid_body) { build_invalid_body }

  def build_invalid_body
    ms_since_midnight = calculate_ms_since_midnight race.start_time.hour, 0, 0
    body[:ms_since_midnight] = ms_since_midnight
    body[:checksum] = md5 "#{ms_since_midnight}#{api_secret}"
    body
  end

  it_behaves_like 'times API'
end