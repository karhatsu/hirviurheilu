class SeriesController < ApplicationController
  def change_series
    redirect_to series_competitors_path(params[:series_id])
  end
end
