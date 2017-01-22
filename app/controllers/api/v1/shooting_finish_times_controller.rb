class Api::V1::ShootingFinishTimesController < Api::V1::TimesBaseController
  private

  def time_field
    :shooting_finish_time
  end
end
