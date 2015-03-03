module TimeFormatHelper
  def date_print(time)
    time.strftime('%d.%m.%Y')
  end

  def datetime_print(datetime, hours_and_minutes=false, seconds=false,
                     nil_result='', to_local_zone=false)
    return nil_result if datetime.nil?
    t = date_print(datetime)
    t << " #{time_print(datetime, seconds, nil_result, to_local_zone)}" if hours_and_minutes
    t
  end

  def time_print(time, seconds=false, nil_result='', to_local_zone=false)
    return raw(nil_result) if time.nil?
    format = (seconds ? '%H:%M:%S' : '%H:%M')
    return time.in_time_zone(Time.zone).strftime(format) if to_local_zone
    time.strftime(format)
  end

  def series_start_time_print(series)
    datetime_print(series.start_datetime, true)
  end

  def relay_start_time_print(relay)
    date = relay.race.start_date.to_date + relay.start_day - 1
    "#{date_print date.to_date} #{time_print relay.start_time}"
  end

  def time_from_seconds(seconds, always_signed=false)
    return '-' if seconds.nil?
    if seconds < 0
      time = '-'
      seconds = seconds.abs
    else
      time = ''
      time = '+' if always_signed
    end
    h = seconds.to_i / 3600
    min = (seconds.to_i - h * 3600) / 60
    sec = seconds.to_i % 60
    time << (h >= 1 ? "#{h}:" : '')
    time << "#{min < 10 ? '0' : ''}#{min}:"
    time << "#{sec < 10 ? '0' : ''}#{sec}"
  end

  def race_date_interval(race, time_tag=true)
    date_interval race.start_date, race.end_date, time_tag
  end

  def date_interval(start_date, end_date, time_tag=true)
    interval = ''
    interval << "<time itemprop='startDate' datetime='#{start_date.strftime('%Y-%m-%d')}'>" if time_tag
    interval << start_date.strftime('%d.%m.%Y')
    interval << '</time>' if time_tag
    unless end_date.nil? or start_date == end_date
      interval << " - #{end_date.strftime('%d.%m.%Y')}"
    end
    raw interval
  end
end