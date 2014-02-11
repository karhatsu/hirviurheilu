module StartDateTime
  def start_date_time(race, start_day, start_time)
    return nil unless start_time and race and race.start_date
    time = Time.zone.local(race.start_date.year, race.start_date.month,
                           race.start_date.day, race.start_time.hour, race.start_time.min, race.start_time.sec)
    time = advance_with_start_day(time, start_day)
    advance_with_start_time time, start_time
  end

  private
  def advance_with_start_day(time, start_day)
    time.advance(days: start_day - 1)
  end

  def advance_with_start_time(time, start_time)
    time = time.advance(:hours => start_time.hour)
    time = time.advance(:minutes => start_time.min)
    time.advance(:seconds => start_time.sec)
  end
end