class Api::V2::Public::RifleCupSeriesController < Api::V2::Public::CupSeriesController
  def show
    @rifle = true
    super
  end
end
