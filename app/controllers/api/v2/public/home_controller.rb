class Api::V2::Public::HomeController < Api::V2::ApiBaseController
  include HomeHelper

  def index
    @today = competitions_today
    @yesterday = competitions_yesterday
    @past = past_competitions
    @future = future_competitions
  end

  private

  def competitions_today
    today = Race.today
    today = today.where(sport_key: params[:sport_key]) unless params[:sport_key].blank?
    today = today.where(district_id: params[:district_id]) unless params[:district_id].blank?
    today = today.where(level: params[:level]) unless params[:level].blank?
    today
  end

  def competitions_yesterday
    yesterday = Race.yesterday
    yesterday = yesterday.where(sport_key: params[:sport_key]) unless params[:sport_key].blank?
    yesterday = yesterday.where(district_id: params[:district_id]) unless params[:district_id].blank?
    yesterday = yesterday.where(level: params[:level]) unless params[:level].blank?
    yesterday
  end

  def past_competitions
    past_races = Race.past.limit(11)
    past_races = past_races.where(sport_key: params[:sport_key]) unless params[:sport_key].blank?
    past_races = past_races.where(district_id: params[:district_id]) unless params[:district_id].blank?
    past_races = past_races.where(level: params[:level]) unless params[:level].blank?
    past_races
  end

  def future_competitions
    future = Race.future
    future = future.where(sport_key: params[:sport_key]) unless params[:sport_key].blank?
    future = future.where(district_id: params[:district_id]) unless params[:district_id].blank?
    future = future.where(level: params[:level]) unless params[:level].blank?
    group_future_races(future)
  end
end
