class Official::OfficialController < ApplicationController
  before_action :require_user, :check_rights, :set_official

  protected
  def check_rights
    redirect_to root_path unless official_rights
  end

  def check_race(race, require_full_rights=true)
    return if current_user.admin?
    unless own_race?(race)
      flash[:error] = "Et ole kilpailun toimitsija"
      redirect_to official_root_path
      return
    end
    if require_full_rights and !current_user.has_full_rights_for_race?(race)
      redirect_to official_limited_race_competitors_path(race)
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

  def check_cup(cup)
    unless own_cup?(cup)
      flash[:error] = "Et ole cup-kilpailun toimitsija"
      redirect_to official_root_path
    end
  end

  def check_assigned_cup
    check_cup(@cup)
  end

  def require_three_sports_race
    race = @race || @series.race
    redirect_to official_race_path(race) if race.sport.shooting?
  end

  def set_official
    @is_official = true
  end

  def set_relays
    @is_relays = true
  end

  def collect_age_groups(series)
    @age_groups = {}
    series.each do |s|
      @age_groups[s.id] = s.age_groups_with_main_series
    end
  end
end
