class HomeController < ApplicationController
  include HomeHelper
  before_action :set_variant

  def show
    @is_main_page = true
    all_cups = Cup.joins(:races)
    all_cups = all_cups.where('races.district_id=?', params[:district_id]) if params[:district_id]
    @today = Race.today
    @today = @today.where(district_id: params[:district_id]) if params[:district_id]
    @past = past_competitions(all_cups)
    @future = Race.future
    @future = @future.where(district_id: params[:district_id]) if params[:district_id]
    @future = group_future_races(@future)
    @announcements = Announcement.active.front_page
  end
  
  private
  def past_competitions(all_cups)
    (past_races_without_finished_cups + finished_cups(all_cups)).sort { |a,b| [b.end_date, a.name] <=> [a.end_date, b.name] }
  end
  
  def past_races_without_finished_cups
    past_races = Race.past.includes(cups: [:cups_races, :races])
    past_races = past_races.where(district_id: params[:district_id]) if params[:district_id]
    past_races.select { |race| race.cups.first.nil? || race.cups.first.end_date >= Date.today }
  end

  def finished_cups(all_cups)
    all_cups.select { |cup| cup.end_date and cup.end_date < Date.today }
  end
end
