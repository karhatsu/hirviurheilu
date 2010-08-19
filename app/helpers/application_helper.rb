module ApplicationHelper

  def points_print(competitor)
    return competitor.points unless competitor.points.nil?
    return "(#{competitor.points!})" unless competitor.points!.nil?
    "-"
  end

  def time_print(seconds)
    return "" if seconds.nil?
    h = seconds.to_i / 3600
    min = (seconds.to_i - h * 3600) / 60
    sec = seconds.to_i % 60
    time = (h >= 1 ? "#{h}:" : "")
    time << "#{min < 10 ? "0" : ""}#{min}:"
    time << "#{sec < 10 ? "0" : ""}#{sec}"
  end

  def time_points_and_time(competitor)
    return "-" if competitor.time_in_seconds.nil?
    "#{competitor.time_points} (#{time_print(competitor.time_in_seconds)})"
  end

  def shot_points_and_total(competitor)
    return "-" if competitor.shots_sum.nil?
    "#{competitor.shot_points} (#{competitor.shots_sum})"
  end

  def shots_list(competitor)
    return "" if competitor.shots_sum.nil?
    return competitor.shots_total_input unless competitor.shots_total_input.nil?
    shot_values = competitor.shot_values
    list = ""
    shot_values.each_with_index do |v, i|
      list << "," if i > 0
      list << "#{v.to_i}"
    end
    list
  end

  def print_estimate_diff(diff)
    return "" if diff.nil?
    d = ""
    d << "+" if diff > 0
    d << "#{diff}"
  end

  def estimate_diffs(competitor)
    return "" if competitor.estimate1.nil? and competitor.estimate2.nil?
    diff1 = competitor.estimate_diff1_m
    diff2 = competitor.estimate_diff2_m
    diffs = ""
    if diff1.nil?
      diffs << "-"
    else
      diffs << "+" if diff1 > 0
      diffs << "#{diff1}m"
    end
    diffs << "/"
    if diff2.nil?
      diffs << "-"
    else
      diffs << "+" if diff2 > 0
      diffs << "#{diff2}m"
    end
    diffs
  end

  def estimate_points_and_diffs(competitor)
    return "-" if competitor.estimate_points.nil?
    "#{competitor.estimate_points} (#{estimate_diffs(competitor)})"
  end

  def full_name(competitor)
    "#{competitor.last_name} #{competitor.first_name}"
  end

  def date_interval(start_date, end_date)
    interval = start_date.strftime('%d.%m.%Y')
    unless end_date.nil? or start_date == end_date
      interval << " - #{end_date.strftime('%d.%m.%Y')}"
    end
    interval
  end

end
