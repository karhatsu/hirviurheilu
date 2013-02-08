class HomeController < ApplicationController
  def show
    @is_main_page = true
    all_cups = Cup.includes(:races)
    cup_races = Cup.cup_races(all_cups)
    @past = past_competitions(cup_races, all_cups)
    @ongoing = ongoing_competitions(cup_races, all_cups)
    @future = future_competitions(cup_races, all_cups)
    @announcements = Announcement.all
  end
  
  private
  def past_competitions(cup_races, all_cups)
    (past_non_cup_races(cup_races) + finished_cups(all_cups)).sort { |a,b| b.end_date <=> a.end_date }
  end
  
  def ongoing_competitions(cup_races, all_cups)
    ongoing_non_cup_races(cup_races) + ongoing_cups(all_cups)
  end
  
  def future_competitions(cup_races, all_cups)
    (future_non_cup_races(cup_races) + future_cups(all_cups)).sort { |a,b| a.start_date <=> b.start_date }
  end
  
  def past_non_cup_races(cup_races)
    pick_non_cup_races(Race.past, cup_races)
  end
  
  def ongoing_non_cup_races(cup_races)
    pick_non_cup_races(Race.ongoing, cup_races)
  end
  
  def future_non_cup_races(cup_races)
    pick_non_cup_races(Race.future, cup_races)
  end
  
  def finished_cups(all_cups)
    all_cups.select { |cup| cup.end_date and cup.end_date < Date.today }
  end
  
  def ongoing_cups(all_cups)
    all_cups.select { |cup| cup.start_date and cup.end_date and cup.start_date <= Date.today and cup.end_date >= Date.today }
  end
  
  def future_cups(all_cups)
    all_cups.select { |cup| cup.start_date and cup.start_date > Date.today }
  end
end
