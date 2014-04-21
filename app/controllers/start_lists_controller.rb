# encoding:UTF-8
class StartListsController < ApplicationController
  before_action :set_races
  before_action :assign_race_by_race_id, :only => :index
  before_action :assign_series_by_series_id, :only => :show

  def index
    respond_to do |format|
      format.pdf do
        render :pdf => "#{@race.name}-lahtoajat", :layout => true,
          :margin => pdf_margin, :header => pdf_header("#{t :start_list} - #{t :all_competitors}"),
          :footer => pdf_footer
      end
    end
  end

  def show
    @is_start_list = true
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@series.name}-lahtolista", :layout => true,
          :margin => pdf_margin, :header => pdf_header("#{t :start_list} - #{@series.name}"),
          :footer => pdf_footer
      end
    end
  end
end
