module TitleHelper
  def series_result_title(series, unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)
    suffix = ''
    suffix = " - #{t(:all_competitors)}" if unofficials == Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME
    return "(#{t('competitors.index.no_competitors')})" if series.competitors.empty?
    return "(#{t('competitors.index.series_has_not_started_yet')})" unless series.started?
    return "#{t(:results)}#{suffix}" if series.race.finished?
    return "#{t('competitors.index.standing')} (#{t('competitors.index.updated')}: #{datetime_print(series.
                                                                              competitors.maximum(:updated_at), true, true, '-', true)})#{suffix}"
  end

  def relay_result_title(relay)
    return "(#{t('relays.show.no_teams')})" if relay.relay_teams.empty?
    return "(#{t('relays.show.relay_has_not_started_yet')})" unless relay.started?
    return t(:results) if relay.finished?
    return "#{t('relays.show.standing')} (#{t('relays.show.updated')}: #{datetime_print(relay.relay_competitors.
                                                      maximum(:updated_at), true, true, '-', true)})"
  end

  def time_title(race)
    t("time_title.#{race.sport_key}")
  end

  def club_title(race)
    return t(:club) if race.club_level == Race::CLUB_LEVEL_SEURA
    return t(:district) if race.club_level == Race::CLUB_LEVEL_PIIRI
    raise "Unknown club level: #{race.club_level}"
  end

  def clubs_title(race)
    return t(:clubs) if race.club_level == Race::CLUB_LEVEL_SEURA
    return t(:districts) if race.club_level == Race::CLUB_LEVEL_PIIRI
    raise "Unknown club level: #{race.club_level}"
  end

  def shots_total_title(competitor)
    shots_sum = competitor.shots_sum
    return '' unless shots_sum
    raw " title='Ammuntatulos: #{shots_sum}'"
  end

  def title_prefix
    env = Rails.env
    if env == 'production'
      return '' if ProductionEnvironment.production?
      return '(Testi) '
    end
    return '(Dev) ' if env == 'development'
    '(Testi) '
  end

  def competitor_title(competitor)
    title = "#{competitor.race.name} - #{competitor.series.name} - #{full_name(competitor)}"
    title << " (#{competitor.age_group.name})" if competitor.age_group
    title
  end

end
