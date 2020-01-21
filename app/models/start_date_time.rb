module StartDateTime
  def start_date_time(race, start_day, start_time)
    return nil unless start_time && race && race.start_date
    race_start_date = race.start_date
    race_start_time = race.start_time
    time = Time.zone.local(race_start_date.year, race_start_date.month, race_start_date.day,
                           race_start_time.hour, race_start_time.min, race_start_time.sec)
    time = advance_with_start_day(time, start_day)
    advance_with_start_time time, start_time
  end

  private
  def advance_with_start_day(time, start_day)
    time.advance(days: start_day - 1)
  end

  def advance_with_start_time(time, start_time)
    time = time.advance(hours: start_time.hour)
    time = time.advance(minutes: start_time.min)
    time.advance(seconds: start_time.sec)
  end
end
