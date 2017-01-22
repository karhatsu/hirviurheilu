class Api::V1::ArrivalTimesController < Api::V1::TimesBaseController
  private

  def time_field
    :arrival_time
  end
end
