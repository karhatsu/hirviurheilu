module CupHelper
  def cup_score_print(competitor)
    score = competitor.score
    return score.to_s unless score.nil?
    partial_score = competitor.score!
    return "(#{partial_score})" unless partial_score.nil?
    "-"
  end

  def long_cup_series_name(cup_series)
    return cup_series.name if cup_series.has_single_series_with_same_name?
    "#{cup_series.name} (#{cup_series.series_names.split(',').join(', ')})"
  end
end
