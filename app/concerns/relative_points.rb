module RelativePoints
  extend ActiveSupport::Concern

  def relative_points(unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, sort_by=Competitor::SORT_BY_POINTS)
    return -1000003 if no_result_reason == Competitor::DQ
    return -1000002 if no_result_reason == Competitor::DNS
    return -1000001 if no_result_reason == Competitor::DNF
    if sport.only_shooting
      only_shooting_relative_points
    else
      three_sports_relative_points unofficials, sort_by
    end
  end

  private

  def three_sports_relative_points(unofficials, sort_by)
    if sort_by == Competitor::SORT_BY_SHOTS
      shooting_points.to_i
    elsif sort_by == Competitor::SORT_BY_ESTIMATES
      estimate_points.to_i
    elsif sort_by == Competitor::SORT_BY_TIME
      return -time_in_seconds.to_i if time_in_seconds
      -1000000
    else
      relative_points = 1000000*points(unofficials).to_i + 1000*shooting_points.to_i
      relative_points = relative_points - time_in_seconds.to_i unless series.walking_series?
      relative_points = relative_points + relative_shooting_points if series.walking_series?
      relative_points = relative_points * 10 unless unofficials != Series::UNOFFICIALS_EXCLUDED || unofficial?
      relative_points
    end
  end

  def only_shooting_relative_points
    relative_points = 10000 * shooting_score + 1000 * hits + 100 * final_round_score
    relative_points = relative_points + 10 * qualification_round_sub_scores[1].to_i if final_round_shots.length == 0
    relative_points + relative_shooting_points + relative_reverse_shooting_points.to_i
  end

  def relative_shooting_points
    return 0 unless shots
    shots.inject(0) {|sum, shot| sum = sum + shot * shot; sum}
  end

  def relative_reverse_shooting_points
    return 0 unless shots
    shots.each_with_index.map {|shot, i| (i + 1) * shot}.inject(:+)
  end
end
