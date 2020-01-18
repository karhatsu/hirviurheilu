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
    results = results + shot_counts_desc if series.walking_series?
    results
  end

  def shooting_race_results
    results = no_result_reason_results
    return results if results
    results = [shooting_score.to_i, hits.to_i, final_round_score.to_i]
    results << (final_round_score || qualification_round_sub_scores.nil? ? 0 : qualification_round_sub_scores[1].to_i)
    results = results + shot_counts_desc + (shots || []).reverse
    results
  end

  private

  def no_result_reason_results
    return [-30000] if no_result_reason == Competitor::DQ
    return [-20000] if no_result_reason == Competitor::DNS
    return [-10000] if no_result_reason == Competitor::DNF
  end

  def shot_counts_desc
    grouped_shots = (shots || []).group_by &:to_i
    shots_counts = []
    10.times do |i|
      shot = 10 - i
      shots_count = (grouped_shots[shot] || []).length
      shots_count = shots_count + (grouped_shots[11] || []).length if shot == 10
      shots_counts << shots_count
    end
    shots_counts
  end
end
