class Api::V2::Official::ShootingStartTimesController < Api::V2::Official::TimesBaseController
  private

  def time_field
    :shooting_start_time
  end
end
