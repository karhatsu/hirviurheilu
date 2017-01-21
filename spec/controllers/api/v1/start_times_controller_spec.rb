require 'spec_helper'

describe Api::V1::StartTimesController, type: :api do
  let(:api_times_string) { 'start_times' }
  let(:time_field) { 'start_time' }

  it_behaves_like 'times API'
end