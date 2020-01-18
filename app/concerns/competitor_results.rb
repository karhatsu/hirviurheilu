module CompetitorResults
  extend ActiveSupport::Concern

  def three_sports_race_results(unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, sort_by=Competitor::SORT_BY_POINTS)
    return [-30000] if no_result_reason == Competitor::DQ
    return [-20000] if no_result_reason == Competitor::DNS
    return [-10000] if no_result_reason == Competitor::DNF
    return [shooting_points.to_i] if sort_by == Competitor::SORT_BY_SHOTS
    return [estimate_points.to_i] if sort_by == Competitor::SORT_BY_ESTIMATES
    return [-time_in_seconds.to_i] if sort_by == Competitor::SORT_BY_TIME
    results = [(unofficials == Series::UNOFFICIALS_EXCLUDED && unofficial? ? 0 : 1)]
    results = results + [points(unofficials), shooting_points.to_i]
    results << -time_in_seconds.to_i unless series.walking_series?
    results = results + shot_counts_desc if series.walking_series?
    results
  end

  private

  def shot_counts_desc
    grouped_shots = (shots || []).group_by &:to_i
    shots_counts = []
    10.times do |i|
      shots_counts << (grouped_shots[10 - i] || []).length
    end
    shots_counts
  end
end
