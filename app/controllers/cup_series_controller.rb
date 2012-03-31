class CupSeriesController < ApplicationController
  def show
    @is_cup = true
    @is_cup_series = true
    @cup = Cup.where(:id => params[:cup_id]).
      includes([
        :races => [:series => [:competitors => [:shots, :age_group, :club, :series]]]
      ]).first
    @cup_series = @cup.find_cup_series(params[:id])
  end
end