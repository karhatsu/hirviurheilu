module CompetitorResults
  extend ActiveSupport::Concern

  def three_sports_race_results(unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)
    results = no_result_reason_results
    return results if results
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
    results + shot_counts_desc(qualification_round_shots) + reverse_shots(qualification_round_shots&.flatten)
  end

  def nordic_total_results
    results = no_result_reason_results
    return results if results
    [nordic_score.to_i, nordic_extra_score.to_i]
  end

  def nordic_sub_results(sub_sport)
    results = no_result_reason_results
    return results if results
    case sub_sport
    when :trap
      nordic_sub_results_array nordic_trap_score, nordic_trap_extra_shots
    when :shotgun
      nordic_sub_results_array nordic_shotgun_score, nordic_shotgun_extra_shots
    when :rifle_moving
      nordic_sub_results_array nordic_rifle_moving_score, nordic_rifle_moving_extra_shots, 2
    when :rifle_standing
      nordic_sub_results_array nordic_rifle_standing_score, nordic_rifle_standing_extra_shots, 2
    else
      raise "Unknown nordic sport: #{sub_sport}"
    end
  end

  def european_total_results
    results = no_result_reason_results
    return results if results
    [european_score.to_i, european_rifle_score.to_i, european_rifle4_score.to_i, european_rifle3_score.to_i,
     european_rifle2_score.to_i, european_rifle1_score.to_i, sum_of_european_rifle_tens, european_extra_score.to_i]
  end

  def european_rifle_results
    results = no_result_reason_results
    return results if results
    results = [european_rifle_score.to_i, european_rifle4_score.to_i, european_rifle3_score.to_i,
               european_rifle2_score.to_i, european_rifle1_score.to_i, sum_of_european_rifle_tens]
    results = results + european_rifle_extra_shots if european_rifle_extra_shots
    results
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
    group_and_sum_shots_array all_extra_shots, sport.shots_per_extra_round
  end

  def nordic_sub_results_array(score, extra_shots, extra_shots_count = 1)
    return [score.to_i] + group_and_sum_shots_array(extra_shots, extra_shots_count) if extra_shots
    [score.to_i]
  end

  def group_and_sum_shots_array(shots, shots_count)
    return shots if shots_count == 1
    shots.each_slice(shots_count).to_a.map {|shots| shots.inject(:+)}
  end

  def reverse_shots(shots)
    (shots || []).reverse
  end

  def sum_of_european_rifle_tens
    sum_of_tens(european_rifle1_shots) + sum_of_tens(european_rifle2_shots) + sum_of_tens(european_rifle3_shots) +
        sum_of_tens(european_rifle4_shots)
  end

  def sum_of_tens(shots)
    return 0 unless shots
    shots.count 10
  end
end
