class Official::OfficialController < ApplicationController
  before_filter :require_user, :check_rights, :set_official
  skip_before_filter :set_competitions

  protected
  def check_rights
    redirect_to root_path unless official_rights
  end

  def check_race(race)
    unless current_user.admin? or current_user.official_for_race?(race)
      flash[:error] = "Et ole kilpailun toimitsija"
      redirect_to official_root_path
    end
  end

  def assign_race_by_id
    @race = Race.find(params[:id])
  end

  def assign_race_by_race_id
    @race = Race.find(params[:race_id])
  end

  def check_assigned_race
    check_race(@race)
  end

  def assign_series_by_series_id
    @series = Series.find(params[:series_id])
  end

  def check_assigned_series
    check_race(@series.race)
  end

  def set_official
    @is_official = true
  end
end
