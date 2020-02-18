module BatchHelper
  def batch_days_tag(race, current_value)
    if race.days_count == 1
      hidden_field_tag :batch_day, 1
    else
      options = []
      start_date = race.start_date
      race.days_count.times do |i|
        options << [date_print(start_date.to_date + i), i + 1]
      end
      select_tag :batch_day, options_for_select(options, current_value)
    end
  end

  def batch_time(race, batch)
    if race.days_count > 1
      "#{race.start_date.advance(days: batch.day - 1).strftime('%d.%m.%Y')} #{batch.time.strftime('%H:%M')}"
    else
      batch.time.strftime('%H:%M')
    end
  end
end
