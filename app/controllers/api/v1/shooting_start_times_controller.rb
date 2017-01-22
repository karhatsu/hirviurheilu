class Api::V1::ShootingStartTimesController < Api::V1::TimesBaseController
  private

  def time_field
    :shooting_start_time
  end
end
