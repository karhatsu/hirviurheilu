class Api::V2::Official::StartTimesController < Api::V2::Official::TimesBaseController
  private

  def time_field
    :start_time
  end
end
