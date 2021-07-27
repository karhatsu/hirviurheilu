class MediaController < ApplicationController
  before_action :assign_competition, :set_media_menu, :set_competitors_count

  def new
    use_react
    render layout: true, html: ''
  end

  def create
    if @competitors_count <= 0
      flash[:error] = t('media.show.invalid_competitor_count')
      render :new
    else
      redirect_to cup_medium_path(@cup, competitors_count: @competitors_count, show_race_points: params[:show_race_points]) if params[:cup_id]
    end
  end

  def show
    @cup = Cup.where(id: params[:cup_id]).includes([:cup_series, races: [series: [competitors: [:age_group, :club, :series]]]]).first if params[:cup_id]
  end

  private
  def set_media_menu
    @is_races = true if params[:race_id]
    @is_cup = true if params[:cup_id]
    @is_media = true
  end

  def assign_competition
    if params[:race_id]
      request.variant = :race
      assign_race_by_race_id
    elsif params[:cup_id]
      request.variant = :cup
      assign_cup_by_cup_id
    else
      raise 'Unknown parent model for media controller'
    end
  end

  def set_competitors_count
    @competitors_count = (params[:competitors_count] || 3).to_i
  end
end
