class StartListsController < ApplicationController
  before_action :set_races
  before_action :assign_race_by_race_id, :only => :index
  before_action :assign_series_by_series_id, :only => :show

  def index
    respond_to do |format|
      format.pdf do
        where_condition = "number >= 0 and competitors.start_time is not null"
        where_condition << " and club_id=#{params[:club_id].to_i}" unless params[:club_id].blank?
        @competitors = @race.competitors.except(:order).where(where_condition).order('start_time, number').includes(:series, :club, :age_group)
        render :pdf => "#{@race.name}-lahtoajat", :layout => true,
          :margin => pdf_margin, :header => pdf_header("#{t :start_list} - #{t :all_competitors}"),
          :footer => pdf_footer, disable_smart_shrinking: true
      end
    end
  end

  def show
    return redirect_to(race_series_start_list_path(@series.race, @series), status: 301) if params[:race_id].blank?
    use_react
    @is_start_list = true
    respond_to do |format|
      format.html { render layout: true, html: '' }
      format.pdf do
        render :pdf => "#{@series.name}-lahtolista", :layout => true,
          :margin => pdf_margin, :header => pdf_header("#{t :start_list} - #{@series.name}"),
          :footer => pdf_footer, disable_smart_shrinking: true
      end
    end
  end
end
