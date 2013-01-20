class SeriesController < ApplicationController
  def show
    respond_to do |format|
      format.html {
        redirect_to(series_competitors_path(params[:id]))
      }
      format.json {
        assign_series_by_id
        render :json => @series.to_json(:methods => [:next_start_number, :next_start_time])
      }
      format.js {
        @series = Series.find(params[:id]) #TODO: includes
        render 'videos/show_series'
      }
    end
  end
end
