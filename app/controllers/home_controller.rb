class HomeController < ApplicationController
  include HomeHelper

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
    today = today.where(district_id: params[:district_id]) unless params[:district_id].blank?
    today
  end

  def past_competitions
    past_races = Race.past
    past_races = past_races.where(district_id: params[:district_id]) unless params[:district_id].blank?
    past_races
  end

  def future_competitions
    future = Race.future
    future = future.where(district_id: params[:district_id]) unless params[:district_id].blank?
    group_future_races(future)
  end
end
