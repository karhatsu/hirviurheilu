class HomeController < ApplicationController
  before_action :set_variant

  def show
    @is_main_page = true
    all_cups = Cup.includes(:races)
    @past = past_competitions(all_cups)
    @ongoing = Race.ongoing
    @future = Race.future
    @announcements = Announcement.active
  end
  
  private
  def past_competitions(all_cups)
    (past_races_without_finished_cups + finished_cups(all_cups)).sort { |a,b| b.end_date <=> a.end_date }
  end
  
  def past_races_without_finished_cups
    Race.past.includes(cups: [:cups_races, :races]).select { |race| race.cups.first.nil? || race.cups.first.end_date >= Date.today }
  end

  def finished_cups(all_cups)
    all_cups.select { |cup| cup.end_date and cup.end_date < Date.today }
  end
end
