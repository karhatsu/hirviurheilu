class CupSeriesController < ApplicationController
  def show
    @is_cup = true
    @is_cup_series = true
    @cup = Cup.find(params[:cup_id])
    @cup_series = @cup.find_cup_series(params[:id])
  end
end