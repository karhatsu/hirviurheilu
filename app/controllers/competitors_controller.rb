class CompetitorsController < ApplicationController
  before_filter :set_results

  def index
    @series = Series.find(params[:series_id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@series.name}-tulokset", :layout => true
      end
    end
  end

  def show
    @competitor = Competitor.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@competitor.last_name}_#{@competitor.first_name}-tuloskortti",
          :layout => true
      end
    end
  end

  private
  def set_results
    @is_results = true
  end
end 