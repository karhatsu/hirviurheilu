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

end
