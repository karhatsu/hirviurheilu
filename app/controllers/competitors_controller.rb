class CompetitorsController < ApplicationController
  before_action :assign_series_by_series_id, :only => :index
  before_action :assign_competitor_by_id, :only => :show
  before_action :set_races, :set_results

  def index
    respond_to do |format|
      format.html { redirect_to race_series_path(@series.race, @series), status: 301 }
      format.pdf { redirect_to race_series_path(@series.race, @series, format: :pdf), status: 301 }
    end
  end

  def show
    series = @competitor.series
    redirect_to race_series_path(series.race, series), status: 301
  end

  private
  def set_results
    @is_results = true
  end
end
