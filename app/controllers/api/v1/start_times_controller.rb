class Api::V1::StartTimesController < Api::V1::TimesBaseController
  private

  def time_field
    :start_time
  end
end