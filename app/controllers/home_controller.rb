class HomeController < ApplicationController
  include HomeHelper
  before_action :set_variant

  def show
    @is_main_page = true
    all_cups = Cup.joins(races: :cups).includes(races: :cups)
    all_cups = all_cups.where('races.district_id=?', params[:district_id]) unless params[:district_id].blank?
    @today = Race.today
    @today = @today.where(district_id: params[:district_id]) unless params[:district_id].blank?
    @past = past_competitions(all_cups)
    @future = Race.future
    @future = @future.where(district_id: params[:district_id]) unless params[:district_id].blank?
    @future = group_future_races(@future)
    @announcements = Announcement.active.front_page
  end

  private

  def past_competitions(all_cups)
    finished_cups = all_cups.select { |cup| cup.end_date && cup.end_date < Date.today }
    finished_cups_race_ids = finished_cups.each { |cup| cup.races.map(&:id) }.flatten

    past_races = Race.past
    past_races = past_races.where('id NOT IN(?)', finished_cups_race_ids) if finished_cups_race_ids.length > 0
    past_races = past_races.where(district_id: params[:district_id]) unless params[:district_id].blank?

    (past_races + finished_cups).sort { |a,b| [b.end_date, a.name] <=> [a.end_date, b.name] }
  end
end
