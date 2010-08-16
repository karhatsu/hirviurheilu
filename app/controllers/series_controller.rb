class SeriesController < ApplicationController
  def show
    @series = Series.find(params[:id])
  end
end
