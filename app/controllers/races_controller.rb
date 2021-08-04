class RacesController < ApplicationController
  before_action :set_races
  before_action :assign_race_by_id, :only => :show

  def index
    use_react
    render layout: true, html: ''
  end

  def show
    @is_race = true
    use_react
    respond_to do |format|
      format.html { render layout: true, html: '' }
      format.pdf do
        @page_breaks = params[:page_breaks]
        orientation = @race.sport.shooting? && !@race.sport.european? ? 'Portrait' : 'Landscape'
        render pdf: "#{@race.name} - tulokset", layout: true,
               margin: pdf_margin, header: pdf_header("#{@race.name} - Tuloskooste"), footer: pdf_footer,
               orientation: orientation, disable_smart_shrinking: true
      end
    end
  end

end
