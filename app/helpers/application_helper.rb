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
    (h >= 1 ? "#{h}:" : "") + "#{min < 10 ? "0" : ""}#{min}:#{sec < 10 ? "0" : ""}#{sec}"
  end

end
