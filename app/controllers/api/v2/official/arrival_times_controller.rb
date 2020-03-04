class Api::V2::Official::ArrivalTimesController < Api::V2::Official::TimesBaseController
  private

  def time_field
    :arrival_time
  end
end
