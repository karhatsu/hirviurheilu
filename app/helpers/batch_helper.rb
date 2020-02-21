module BatchHelper
  def batch_days_options(race)
    start_date = race.start_date
    race.days_count.times.map { |i| [date_print(start_date.to_date + i), i + 1] }
  end

  def batch_time(race, batch)
    if race.days_count > 1
      "#{race.start_date.advance(days: batch.day - 1).strftime('%d.%m.%Y')} #{batch.time.strftime('%H:%M')}"
    else
      batch.time.strftime('%H:%M')
    end
  end
end
