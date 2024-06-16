module TitleHelper
  def main_title
    return [@series.name, @series.race.name, t("sport_name.#{@series.race.sport_key}"), 'Hirviurheilu'].join(' - ') if @series
    return [@relay.name, t('race_sub_menu.relays.other'), @relay.race.name, t("sport_name.#{@relay.race.sport_key}"), 'Hirviurheilu'].join(' - ') if @relay && !@relay.new_record?
    return [@tc.name, t('race_sub_menu.team_competitions.other'), @tc.race.name, t("sport_name.#{@tc.race.sport_key}"), 'Hirviurheilu'].join(' - ') if @tc && !@tc.new_record?
    return [@cup.name, 'Hirviurheilu'].join(' - ') if @cup && !@cup.new_record?
    return [@race.name, t("sport_name.#{@race.sport_key}"), 'Hirviurheilu'].join(' - ') if @race && !@race.new_record?
    t('home.show.main_title')
  end

  def series_result_title(series, unofficials_rule=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)
    suffix = ''
    suffix = " - #{t(:all_competitors)}" if unofficials_rule == Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME
    competitors = series.sport.european? ? series.competitors.where('only_rifle=?', false) : series.competitors
    return "(#{t('competitors.index.no_competitors')})" if competitors.empty?
    return "(#{t('competitors.index.series_has_not_started_yet')})" unless series.started?
    return "#{t(:results)}#{suffix}" if series.finished? || series.race.finished?
    return "#{t('competitors.index.standing')} (#{t('competitors.index.updated')}: #{datetime_print(competitors.maximum(:updated_at), true, true, '-', true)})#{suffix}"
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

  def title_prefix
    env = Rails.env
    if env == 'production'
      return '' if ProductionEnvironment.production?
      return '(Testi) '
    end
    return '(Dev) ' if env == 'development'
    '(Testi) '
  end
end
