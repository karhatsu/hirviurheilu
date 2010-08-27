class CompetitorsController < ApplicationController
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
  end
end 