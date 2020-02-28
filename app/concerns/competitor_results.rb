module CompetitorResults
  extend ActiveSupport::Concern

  def three_sports_race_results(unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, sort_by=Competitor::SORT_BY_POINTS)
    results = no_result_reason_results
    return results if results
    return [shooting_points.to_i] if sort_by == Competitor::SORT_BY_SHOTS
    return [estimate_points.to_i] if sort_by == Competitor::SORT_BY_ESTIMATES
    return [-time_in_seconds.to_i] if sort_by == Competitor::SORT_BY_TIME
    results = [(unofficials == Series::UNOFFICIALS_EXCLUDED && unofficial? ? 0 : 1)]
    results = results + [points(unofficials), shooting_points.to_i]
    results << -time_in_seconds.to_i unless series.walking_series?
    results = results + shot_counts_desc(shots) if series.walking_series?
    results
  end

  def shooting_race_results(competitors)
    results = no_result_reason_results
    return results if results
    max_extra_shots = competitors.map {|competitor| competitor.extra_shots&.length.to_i }.max || 0
    results = [shooting_score.to_i] + extra_round_filled_shots(max_extra_shots) + [hits.to_i, final_round_score.to_i]
    results << (final_round_score || qualification_round_sub_scores.nil? ? 0 : qualification_round_sub_scores[1].to_i)
    results + shot_counts_desc(shots) + reverse_shots(shots)
  end

  def shooting_race_qualification_results
    results = no_result_reason_results
    return results if results
    results = [qualification_round_score.to_i, qualification_round_hits.to_i]
    results << (qualification_round_sub_scores.nil? ? 0 : qualification_round_sub_scores[1].to_i)
    results + shot_counts_desc(qualification_round_shots) + reverse_shots(qualification_round_shots)
  end

  private

  def no_result_reason_results
    return [-30000] if no_result_reason == Competitor::DQ
    return [-20000] if no_result_reason == Competitor::DNS
    return [-10000] if no_result_reason == Competitor::DNF
  end

  def shot_counts_desc(shots)
    grouped_shots = (shots || []).flatten.group_by &:to_i
    shots_counts = []
    10.times do |i|
      shot = 10 - i
      shots_count = (grouped_shots[shot] || []).length
      shots_count = shots_count + (grouped_shots[11] || []).length if shot == 10
      shots_counts << shots_count
    end
    shots_counts
  end

  def extra_round_filled_shots(max_extra_shots)
    return [] if max_extra_shots == 0
    own_shots = (extra_shots || [])
    all_extra_shots = own_shots + Array.new(max_extra_shots - own_shots.length, 0)
    return all_extra_shots if sport.shots_per_extra_round == 1
    all_extra_shots.each_slice(sport.shots_per_extra_round).to_a.map {|shots| shots.inject(:+)}
  end

  def reverse_shots(shots)
    (shots || []).reverse
  end
end
