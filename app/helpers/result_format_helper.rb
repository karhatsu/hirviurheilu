module ResultFormatHelper
  def points_print(competitor, unofficials)
    if competitor.no_result_reason
      return no_result_reason_print(competitor.no_result_reason)
    end
    points = competitor.points(unofficials)
    return points.to_s if competitor.finished? && competitor.has_correct_estimates?
    return "(#{points})" if points
    '-'
  end

  def time_points_print(competitor, with_time=false, unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)
    return '' if competitor.no_result_reason
    return 300 if competitor.series.points_method == Series::POINTS_METHOD_300_TIME_2_ESTIMATES
    return '-' if competitor.time_in_seconds.nil?
    points = competitor.time_points(unofficials)
    html = (points == 300 ? "<span class='series_best_time'>" : '')
    html << points.to_s
    html << " (#{time_from_seconds(competitor.time_in_seconds)})" if with_time
    html << (points == 300 ? '</span>' : '')
    raw(html)
  end

  def shot_points_print(competitor, shots_total=false)
    return '' if competitor.no_result_reason
    return '-' if competitor.shots_sum.nil?
    points = competitor.shot_points.to_s
    if shots_total
      points << " (#{competitor.shots_sum}"
      points << "#{competitor.shooting_overtime_penalty}" if competitor.shooting_overtime_penalty
      points << ')'
    end
    points
  end

  def no_result_reason_print(no_result_reason, scope='competitor')
    raw("<span class='explanation' title='#{t(scope + '.' + no_result_reason)}'>#{no_result_reason}</span>")
  end

  def national_record_print(competitor, raw=false)
    if competitor.national_record_passed?
      tag = 'SE'
    elsif competitor.national_record_reached?
      tag = 'SE(sivuaa)'
    else
      return ''
    end
    tag << '?' unless competitor.series.race.finished?
    return tag if raw
    raw("<span class='explanation'><a href=\"#{NATIONAL_RECORD_URL}\">#{tag}</a></span>")
  end

  def relay_time_adjustment_print(adjustment)
    return '' unless adjustment
    return '' if adjustment == 0
    raw("(<span class='adjustment' title=\"Aika sisältää korjausta #{time_from_seconds(adjustment, true)}\">#{time_from_seconds(adjustment, true)}</span>)")
  end

  def shots_list_print(competitor)
    return '-' if competitor.shots_sum.nil?
    return competitor.shots_total_input unless competitor.shots_total_input.nil?
    shots = competitor.shots
    "#{competitor.shots_sum} (#{shots.map {|shot| shot.to_i}.join(', ')})"
  end

  def comparison_time_title_attribute(competitor, unofficials, always_empty=false)
    return '' if always_empty
    comparison_time = competitor.comparison_time_in_seconds(unofficials)
    return '' unless comparison_time
    "Vertailuaika: #{time_from_seconds(comparison_time, false)}"
  end

  def comparison_and_own_time_title_attribute(competitor)
    time_in_seconds = competitor.time_in_seconds
    return '' unless time_in_seconds
    title = " title='Aika: #{time_from_seconds(time_in_seconds)}"
    comparison_time_in_seconds = competitor.comparison_time_in_seconds
    title << ". Vertailuaika: #{time_from_seconds(comparison_time_in_seconds)}." if comparison_time_in_seconds
    title << "'"
    raw title
  end

  def special_series_info(series)
    return nil if series.points_method == Series::POINTS_METHOD_TIME_2_ESTIMATES
    t("points_method_#{series.points_method}.#{series.race.sport.key}")
  end
end