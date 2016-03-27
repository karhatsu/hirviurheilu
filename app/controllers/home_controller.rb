class HomeController < ApplicationController
  include HomeHelper
  before_action :set_variant

  def show
    @is_main_page = true
    all_cups = Cup.includes(:races)
    @past = past_competitions(all_cups)
    @future = group_future_races(Race.future)
    @announcements = Announcement.active.front_page
  end
  
  private
  def past_competitions(all_cups)
    (past_races_without_finished_cups + finished_cups(all_cups)).sort { |a,b| [b.end_date, a.name] <=> [a.end_date, b.name] }
  end
  
  def past_races_without_finished_cups
    Race.past.includes(cups: [:cups_races, :races]).select { |race| race.cups.first.nil? || race.cups.first.end_date >= Date.today }
  end

  def finished_cups(all_cups)
    all_cups.select { |cup| cup.end_date and cup.end_date < Date.today }
  end
end
