module HomeHelper
  def group_future_races(future_races)
    return {} if future_races.empty?
    race_groups = {tomorrow: [], day_after_tomorrow: [], this_week: [], next_week: [], this_month: [], next_month: [], later: []}
    future_races.each do |race|
      if race.start_date == Date.tomorrow
        race_groups[:tomorrow] << race
      elsif race.start_date == Date.tomorrow + 1.day
        race_groups[:day_after_tomorrow] << race
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
    race_groups.select {|key, group| !group.empty?}
  end
end