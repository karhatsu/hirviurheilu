class SeriesController < ApplicationController
  before_action :assign_series_by_id, only: :show
  before_action :set_races

  def show
    @is_results = true
    respond_to do |format|
      format.html
      format.json {
        assign_series_by_id
        render :json => @series.to_json(:methods => [:next_start_number, :next_start_time])
      }
      format.pdf {
        orientation = @series.sport.shooting? && !@series.sport.european? ? 'Portrait' : 'Landscape'
        render pdf: "#{@series.name}-tulokset", layout: true, margin: pdf_margin,
               header: pdf_header("#{@series.race.name} - #{@series.name}\n"), footer: pdf_footer,
               orientation: orientation, disable_smart_shrinking: true
      }
    end
  end
end
