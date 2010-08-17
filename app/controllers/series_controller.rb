class SeriesController < ApplicationController
  def show
    @series = Series.find(params[:id])
  end

  def start_list
    @series = Series.find(params[:id])
  end
end
