module ResultFormatHelper
  def points_print(competitor, unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)
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
    html = (points == 300 ? "<span class='series-best-time'>" : '')
    html << points.to_s
    html << " (#{time_from_seconds(competitor.time_in_seconds)})" if with_time
    html << (points == 300 ? '</span>' : '')
    raw(html)
  end

  def shooting_points_print(competitor, shots_total=false, individual_shots=false)
    return '' if competitor.no_result_reason
    return '-' if competitor.shooting_score.nil?
    points = competitor.shooting_points.to_s
    if shots_total
      points << " (#{competitor.shooting_score}"
      points << "#{competitor.shooting_overtime_penalty}" if competitor.shooting_overtime_penalty
      points << " / #{competitor.shots.join(', ')}" if individual_shots && competitor.shots
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

  def relay_time_adjustment_print(source)
    adjustment = source.adjustment.to_i
    estimate_adjustment = source.estimate_adjustment.to_i
    shooting_adjustment = source.shooting_adjustment.to_i
    return '' if adjustment == 0 && estimate_adjustment == 0 && shooting_adjustment == 0
    title = []
    title << "Aika sisältää arviokorjausta #{time_from_seconds(estimate_adjustment, true)}." if estimate_adjustment != 0
    title << "Aika sisältää ammuntakorjausta #{time_from_seconds(shooting_adjustment, true)}." if shooting_adjustment != 0
    title << "Aika sisältää muuta korjausta #{time_from_seconds(adjustment, true)}." if adjustment != 0
    total_adjustment = adjustment + estimate_adjustment + shooting_adjustment
    raw("(<span class='adjustment' title=\"#{title.join(' ')}\">#{time_from_seconds(total_adjustment, true)}</span>)")
  end

  def competitor_shots_print(competitor)
    return '-' if competitor.shooting_score.nil?
    return competitor.shooting_score_input unless competitor.shooting_score_input.nil?
    shots = competitor.shots
    "#{competitor.shooting_score} (#{shots.map {|shot| shot.to_i}.join(', ')})"
  end

  def shots_print(shots)
    shots.map{|shot| shot == 11 ? '10*' : shot}.join(', ')
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
    t("points_method_#{series.points_method}.#{series.race.sport_key}")
  end

  def relay_time_print(relay, team, leg=nil)
    team_time = time_from_seconds team.time_in_seconds(leg)
    return "#{time_from_seconds team.time_in_seconds(leg, true)} (#{team_time})" if relay.penalty_seconds?
    team_time
  end

  def relay_leg_time_print(relay, competitor)
    leg_time = time_from_seconds competitor.time_in_seconds
    return "#{time_from_seconds competitor.time_in_seconds(true)} (#{leg_time})" if relay.penalty_seconds?
    leg_time
  end
end
