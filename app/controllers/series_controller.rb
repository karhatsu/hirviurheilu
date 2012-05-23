class SeriesController < ApplicationController
  def show
    @series = Series.find(params[:id])
    respond_to do |format|
      format.json { render :json => @series.to_json(:methods => [:next_start_number, :next_start_time]) }
    end
  end
end
