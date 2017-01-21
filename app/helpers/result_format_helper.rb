module ResultFormatHelper
  def points_print(competitor, all_competitors=false)
    if competitor.no_result_reason
      return no_result_reason_print(competitor.no_result_reason)
    end
    points = competitor.points(all_competitors)
    return points.to_s if competitor.finished?
    return "(#{points})" if points
    '-'
  end

  def time_points_print(competitor, with_time=false, all_competitors=false)
    return '' if competitor.no_result_reason
    return 300 if competitor.series.time_points_type == Series::TIME_POINTS_TYPE_ALL_300
    return '-' if competitor.time_in_seconds.nil?
    points = competitor.time_points(all_competitors)
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
      points << ", #{competitor.shooting_overtime_penalty}" if competitor.shooting_overtime_penalty
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
    shot_values = competitor.shot_values
    "#{competitor.shots_sum} (#{shot_values.map {|value| value.to_i}.join(', ')})"
  end

  def comparison_time_title_attribute(competitor, all_competitors=false, always_empty=false)
    return '' if always_empty
    comparison_time = competitor.comparison_time_in_seconds(all_competitors)
    return '' unless comparison_time
    "Vertailuaika: #{time_from_seconds(comparison_time, false)}"
  end

  def comparison_and_own_time_title_attribute(competitor)
    time_in_seconds = competitor.time_in_seconds
    return '' unless time_in_seconds
    title = " title='Aika: #{time_from_seconds(time_in_seconds)}"
    comparison_time_in_seconds = competitor.comparison_time_in_seconds(false)
    title << ". Vertailuaika: #{time_from_seconds(comparison_time_in_seconds)}." if comparison_time_in_seconds
    title << "'"
    raw title
  end
end