class SeriesController < ApplicationController
  before_action :assign_series_by_id, only: :show
  before_action :set_races

  def show
    @is_results = true
    use_react
    respond_to do |format|
      format.html { render layout: true, html: '' }
      format.pdf {
        orientation = @series.sport.shooting? && !@series.sport.european? ? 'Portrait' : 'Landscape'
        render pdf: "#{@series.name}-tulokset", layout: true, margin: pdf_margin,
               header: pdf_header("#{@series.race.name} - #{@series.name}\n"), footer: pdf_footer,
               orientation: orientation, disable_smart_shrinking: true
      }
    end
  end
end
