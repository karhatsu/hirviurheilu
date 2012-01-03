class CompetitorsController < ApplicationController
  before_filter :assign_series_by_series_id, :only => :index
  before_filter :set_races, :set_results

  def index
    respond_to do |format|
      format.html
      format.pdf do
        title = 
        render :pdf => "#{@series.name}-tulokset", :layout => true, :margin => pdf_margin,
          :header => pdf_header("#{@series.race.name} - #{@series.name}\n"), :footer => pdf_footer
      end
    end
  end

  def show
    @competitor = Competitor.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@competitor.last_name}_#{@competitor.first_name}-tuloskortti",
          :layout => true, :margin => pdf_margin, :header => pdf_header(nil), :footer => pdf_footer
      end
    end
  end

  private
  def set_results
    @is_results = true
  end
end 