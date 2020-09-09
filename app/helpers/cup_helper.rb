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

  def min_points_to_emphasize(race_count, top_competitions, cup_competitors, is_rifle = false)
    return nil unless race_count > top_competitions
    points = cup_competitors.map { |cc| is_rifle ? cc.european_rifle_score : cc.points }
    sorted_points = points.filter {|p| !p.nil?}.sort {|a, b| b <=> a}
    sorted_points[top_competitions - 1]
  end
end
