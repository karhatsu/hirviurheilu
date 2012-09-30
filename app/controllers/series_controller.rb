class SeriesController < ApplicationController
  def show
    assign_series_by_id
    return unless @series
    respond_to do |format|
      format.json { render :json => @series.to_json(:methods => [:next_start_number, :next_start_time]) }
    end
  end
end
