module EstimatesHelper
  def print_estimate_diff(diff)
    return '-' if diff.nil?
    d = ''
    d += '+' if diff > 0
    d += "#{diff}"
  end

  def estimate_diffs(competitor)
    if competitor.series.estimates == 4
      return '' if competitor.estimate1.nil? and competitor.estimate2.nil? and
          competitor.estimate3.nil? and competitor.estimate4.nil?
    else
      return '' if competitor.estimate1.nil? and competitor.estimate2.nil?
    end
    diffs = estimate_diff_with_sign_and_symbol(competitor.estimate_diff1_m)
    diffs += '/'
    diffs += estimate_diff_with_sign_and_symbol(competitor.estimate_diff2_m)
    if competitor.series.estimates == 4
      diffs += '/'
      diffs += estimate_diff_with_sign_and_symbol(competitor.estimate_diff3_m)
      diffs += '/'
      diffs += estimate_diff_with_sign_and_symbol(competitor.estimate_diff4_m)
    end
    diffs
  end

  def estimate_diff_with_sign_and_symbol(diff)
    return '-' if diff.nil?
    "#{diff > 0 ? '+' : ''}#{diff}m"
  end

  def estimate_points_print(race, competitor)
    return '' if competitor.no_result_reason
    return '-' if competitor.estimate_points.nil?
    return "#{competitor.estimate_points} (#{estimate_diffs competitor})" if race.show_correct_distances?
    competitor.estimate_points
  end

  def correct_estimate(competitor, i, not_available_str)
    raise "Unknown index for correct estimate: #{i}" if i < 1 or i > 4
    return not_available_str unless competitor.series.race.show_correct_distances?
    if i == 1
      correct = competitor.correct_estimate1
    elsif i == 2
      correct = competitor.correct_estimate2
    elsif i == 3
      correct = competitor.correct_estimate3
    else
      correct = competitor.correct_estimate4
    end
    return not_available_str unless correct
    correct
  end

  def correct_estimate_range(ce)
    return "#{ce.min_number}-" unless ce.max_number
    return "#{ce.min_number}" unless ce.min_number != ce.max_number
    "#{ce.min_number}-#{ce.max_number}"
  end
end
