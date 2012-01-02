class CompetitorsController < ApplicationController
  before_filter :assign_series_by_series_id, :only => :index
  before_filter :set_races, :set_results

  def index
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@series.name}-tulokset", :layout => true,
          :margin => { :top => 20, :bottom => 20 },
          :header => {
            :right => "#{@series.race.name} - #{@series.name}\n",
            :spacing => 10,
            :font_size => 10
          },
          :footer => {
            :center => 'www.hirviurheilu.com',
            :spacing => 10,
            :line => true }
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