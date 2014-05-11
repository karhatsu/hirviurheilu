class HomeController < ApplicationController
  before_action :set_variant

  def show
    @is_main_page = true
    all_cups = Cup.includes(:races)
    cup_races = Cup.cup_races(all_cups)
    @past = past_competitions(cup_races, all_cups)
    @ongoing = Race.ongoing
    @future = Race.future
    @announcements = Announcement.active
  end
  
  private
  def past_competitions(cup_races, all_cups)
    (past_non_cup_races(cup_races) + finished_cups(all_cups)).sort { |a,b| b.end_date <=> a.end_date }
  end
  
  def past_non_cup_races(cup_races)
    pick_non_cup_races(Race.past, cup_races)
  end
  
  def finished_cups(all_cups)
    all_cups.select { |cup| cup.end_date and cup.end_date < Date.today }
  end
end
