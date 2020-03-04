class Api::V2::Official::ShootingFinishTimesController < Api::V2::Official::TimesBaseController
  private

  def time_field
    :shooting_finish_time
  end
end
