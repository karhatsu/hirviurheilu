class HomeController < ApplicationController
  before_action :set_variant

  def show
    @is_main_page = true
    all_cups = Cup.includes(:races)
    @past = past_competitions(all_cups)
    @future = group_future_races
    @announcements = Announcement.active.front_page
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

  def group_future_races
    future_races = Race.future
    return {} if future_races.empty?
    race_groups = {today: [], tomorrow: [], this_week: [], next_week: [], this_month: [], next_month: [], later: []}
    future_races.each do |race|
      if race.start_date == Date.today || race.end_date == Date.today
        race_groups[:today] << race
      elsif race.start_date == Date.tomorrow
        race_groups[:tomorrow] << race
      elsif race.start_date <= Date.today.end_of_week
        race_groups[:this_week] << race
      elsif race.start_date <= (Date.today + 1.week).end_of_week
        race_groups[:next_week] << race
      elsif race.start_date <= Date.today.end_of_month
        race_groups[:this_month] << race
      elsif race.start_date <= (Date.today + 1.month).end_of_month
        race_groups[:next_month] << race
      else
        race_groups[:later] << race
      end
    end
    race_groups
  end
end
