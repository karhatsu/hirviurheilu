class HomeController < ApplicationController
  include HomeHelper

  before_action :set_sports

  def show
    @is_main_page = true
    @today = competitions_today
    @past = past_competitions
    @future = future_competitions
    @announcements = Announcement.active.front_page
  end

  private

  def competitions_today
    today = Race.today
    today = today.where(sport_key: params[:sport_key]) unless params[:sport_key].blank?
    today = today.where(district_id: params[:district_id]) unless params[:district_id].blank?
    today
  end

  def past_competitions
    past_races = Race.past
    past_races = past_races.where(sport_key: params[:sport_key]) unless params[:sport_key].blank?
    past_races = past_races.where(district_id: params[:district_id]) unless params[:district_id].blank?
    past_races
  end

  def future_competitions
    future = Race.future
    future = future.where(sport_key: params[:sport_key]) unless params[:sport_key].blank?
    future = future.where(district_id: params[:district_id]) unless params[:district_id].blank?
    group_future_races(future)
  end

  def set_sports
    sport_keys = [Sport::RUN, Sport::SKI, Sport::ILMAHIRVI, Sport::ILMALUODIKKO]
    @sports = sport_keys.map{|key| [t("sport_name.#{key}"), key]}
  end
end
