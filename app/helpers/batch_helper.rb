module BatchHelper
  def batch_days_options(race)
    start_date = race.start_date
    race.days_count.times.map { |i| [date_print(start_date.to_date + i), i + 1] }
  end

  def batch_time(race, batch)
    if race.sport.nordic?
      times = [nordic_sub_sport_time(:trap, batch.time)]
      times << nordic_sub_sport_time(:shotgun, batch.time2) if batch.time2
      times << nordic_sub_sport_time(:rifle_moving, batch.time3) if batch.time3
      times << nordic_sub_sport_time(:rifle_standing, batch.time4) if batch.time4
      times.join(' - ')
    elsif race.sport.european?
      times = [european_sub_sport_time(:trap, batch.time)]
      times << european_sub_sport_time(:compak, batch.time2) if batch.time2
      times << european_sub_sport_time(:rifle, batch.time3) if batch.time3
      times.join(' - ')
    elsif race.days_count > 1
      "#{race.start_date.advance(days: batch.day - 1).strftime('%d.%m.%Y')} #{batch.time.strftime('%H:%M')}"
    else
      batch.time.strftime('%H:%M')
    end
  end

  private

  def nordic_sub_sport_time(sub_sport, time)
    "#{t("sport_name.nordic_sub.#{sub_sport}")}: #{time.strftime('%H:%M')}"
  end

  def european_sub_sport_time(sub_sport, time)
    "#{t("sport_name.european_sub.#{sub_sport}")}: #{time.strftime('%H:%M')}"
  end
end
