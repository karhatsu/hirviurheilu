class Official::OfficialController < ApplicationController
  before_filter :require_user, :check_rights, :set_official

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

  def check_assigned_race
    check_race(@race)
  end

  def check_assigned_series
    check_race(@series.race)
  end

  def check_assigned_relay
    check_race(@relay.race)
  end

  def set_official
    @is_official = true
  end

  def set_relays
    @is_relays = true
  end
end
