class RifleCupSeriesController < CupSeriesController
  def show
    @is_cup = true
    @is_rifle_cup_series = true
    render_show
  end
end
