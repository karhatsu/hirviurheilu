module HeatHelper
  def heat_days_options(race)
    start_date = race.start_date
    race.days_count.times.map { |i| [date_print(start_date.to_date + i), i + 1] }
  end

  def heat_time(race, heat)
    if race.sport.nordic?
      times = [nordic_sub_sport_time(race, :trap, heat.day, heat.time)]
      times << nordic_sub_sport_time(race, :shotgun, heat.day2, heat.time2) if heat.time2
      times << nordic_sub_sport_time(race, :rifle_moving, heat.day3, heat.time3) if heat.time3
      times << nordic_sub_sport_time(race, :rifle_standing, heat.day4, heat.time4) if heat.time4
      times.join(' - ')
    elsif race.sport.european?
      times = [european_sub_sport_time(race, :trap, heat.day, heat.time)]
      times << european_sub_sport_time(race, :compak, heat.day2, heat.time2) if heat.time2
      times << european_sub_sport_time(race, :rifle, heat.day3, heat.time3) if heat.time3
      times.join(' - ')
    elsif race.days_count > 1
      "#{race.start_date.advance(days: heat.day - 1).strftime('%d.%m')} #{heat.time.strftime('%H:%M')}"
    else
      heat.time.strftime('%H:%M')
    end
  end

  private

  def nordic_sub_sport_time(race, sub_sport, day, time)
    "#{t("sport_name.nordic_sub.#{sub_sport}")}: #{date(race, day)}#{time.strftime('%H:%M')}"
  end

  def european_sub_sport_time(race, sub_sport, day, time)
    "#{t("sport_name.european_sub.#{sub_sport}")}: #{date(race, day)}#{time.strftime('%H:%M')}"
  end

  def date(race, day)
    race.days_count > 1 ? race.start_date.advance(days: day - 1).strftime('%d.%m') + ' ' : ''
  end
end
