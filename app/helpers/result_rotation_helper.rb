module ResultRotationHelper
  def next_result_rotation_path(competition)
    competition_path = result_path competition
    paths = result_rotation_competitions_paths competition.race
    index = paths.index competition_path
    return paths[index + 1] if index && index != paths.size - 1
    paths[0] || competition_path
  end

  def result_path(competition)
    return race_series_path locale_for_path, competition.race, competition.id if competition.is_a?(Series)
    return race_team_competition_path locale_for_path, competition.race.id, competition.id if competition.is_a?(TeamCompetition)
    return race_relay_path locale_for_path, competition.race.id, competition.id if competition.is_a?(Relay)
    return race_path locale_for_path, competition.id if competition.is_a?(Race)
    raise ArgumentError.new(competition.inspect)
  end

  def result_rotation_competitions_paths(race)
    return [] if Mode.offline?
    return result_rotation_selected_competitions.split(',') unless result_rotation_selected_competitions.blank?
    competitions = result_rotation_series(race)
    unless competitions.empty? || !result_rotation_team_competitions_cookie
      competitions += result_rotation_team_competitions(race)
    end
    competitions.map {|competition| result_path competition}
  end

  def result_rotation_series(race)
    race_day = race.race_day
    return [] if race_day == 0
    list = []
    race.series.where(['start_day=?', race_day]).each do |s|
      list << s if s.started? && s.has_result_for_some_competitor?
    end
    list
  end

  def result_rotation_team_competitions(race)
    race.team_competitions
  end

  def refresh_counter_min_seconds
    20
  end

  def refresh_counter_default_seconds
    30
  end

  def refresh_counter_auto_scroll
    menu_series && result_rotation_auto_scroll
  end

  def refresh_counter_seconds(seconds=nil)
    return seconds if seconds
    return refresh_counter_default_seconds unless refresh_counter_auto_scroll
    series = menu_series
    return refresh_counter_default_seconds unless series
    [refresh_counter_min_seconds, series.competitors.count].max
  end

  def result_rotation_cookie
    cookies[result_rotation_cookie_name]
  end

  def result_rotation_team_competitions_cookie
    cookies[result_rotation_tc_cookie_name]
  end

  def result_rotation_auto_scroll
    cookies[result_rotation_scroll_cookie_name]
  end

  def result_rotation_selected_competitions
    cookies[result_rotation_selected_competitions_cookie_name]
  end
end