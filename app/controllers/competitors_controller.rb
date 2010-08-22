class CompetitorsController < ApplicationController
  def index
    @series = Series.find(params[:series_id])
  end

  def show
    @competitor = Competitor.find(params[:id])
  end
end 