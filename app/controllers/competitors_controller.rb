class CompetitorsController < ApplicationController
  before_action :assign_series_by_series_id, :only => :index
  before_action :assign_competitor_by_id, :only => :show
  before_action :set_races, :set_results
  before_action :set_variant, only: :index

  def index
    respond_to do |format|
      format.html { redirect_to race_series_path(@series.race, @series), status: 301 }
      format.pdf { redirect_to race_series_path(@series.race, @series, format: :pdf), status: 301 }
    end
  end

  def show
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