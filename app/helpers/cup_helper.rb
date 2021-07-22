module CupHelper
  def cup_points_print(competitor)
    points = competitor.points
    return points.to_s unless points.nil?
    partial_points = competitor.points!
    return "(#{partial_points})" unless partial_points.nil?
    "-"
  end

  def long_cup_series_name(cup_series)
    return cup_series.name if cup_series.has_single_series_with_same_name?
    "#{cup_series.name} (#{cup_series.series_names.split(',').join(', ')})"
  end
end
