class RacesController < ApplicationController
  before_action :set_races
  before_action :assign_race_by_id, :only => :show
  before_action :set_variant

  def index
    where = 'district_id=?' unless params[:district_id].blank?
    where_params = [params[:district_id]] unless params[:district_id].blank?
    @competitions = Race.where(where, where_params).order('start_date DESC').page(params[:page])
  end

  def show
    @is_race = true
    respond_to do |format|
      format.html
      format.pdf do
        @page_breaks = params[:page_breaks]
        render :pdf => "#{@race.name} - tulokset", :layout => true,
          :margin => pdf_margin, :header => pdf_header("#{@race.name} - Tuloskooste"), :footer => pdf_footer,
          :orientation => 'Landscape', disable_smart_shrinking: true
      end
    end
  end

end
