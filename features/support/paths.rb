module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    locale = I18n.locale == I18n.default_locale ? nil : I18n.locale

    case page_name

    when /^the home\s?page/
      '/'

    when /^the Swedish home page/
      '/sv'

    when /the official index page/
      official_root_path locale

    when /the new race page/
      new_official_race_path locale

    when /the race edit page of "(.*)"/
      edit_official_race_path(locale, Race.find_by_name($1))

    when /the official cup page of "(.*)"/
      official_cup_path(locale, Cup.find_by_name($1))

    when /the official race page of "(.*)"/
      official_race_path(locale, Race.find_by_name($1))

    when /the new competitor page of the series/
      new_official_series_competitor_path(locale, @series)

    when /the official competitors page of the series/
      official_series_competitors_path(locale, @series)

    when /the official competitors page of series "(.*)"/
      official_series_competitors_path(locale, Series.find_by_name($1))

    when /the official start list page of the race "(.*)"/
      official_race_start_list_path(locale, Race.find_by_name($1))

    when /the official quick save page of "(.*)"/
      official_race_quick_saves_path(locale, Race.find_by_name($1))

    when /the official clubs page for "(.*)"/
      official_race_clubs_path(locale, Race.find_by_name($1))

    when /the invite officials page for "(.*)"/
      official_race_race_rights_path(locale, Race.find_by_name($1))

    when /the export race page of "(.*)"/
      new_official_race_exports_path(locale, Race.find_by_name($1))

    when /the official csv import page of the race/
      new_official_race_csv_import_path(locale, @race)

    when /the official relays page of "(.*)"/
      official_race_relays_path(locale, Race.find_by_name($1))

    when /the edit relay page of "(.*)"/
      edit_official_race_relay_path(locale, Relay.find_by_name($1).race, Relay.find_by_name($1))

    when /the finish relay page of "(.*)"/
      new_official_relay_finish_relay_path(locale, Relay.find_by_name($1))

    when /the official team competitions page of "(.*)"/
      official_race_team_competitions_path(locale, Race.find_by_name($1))

    when /the limited official competitors page for "(.*)"/
      new_official_limited_race_competitor_path(locale, Race.find_by_name($1))

    when /^the cup page$/
      cup_path(locale, @cup)

    when /^the cup page of "(.*)"$/
      cup_path(locale, Cup.find_by_name($1))

    when /the race page of "(.*)"/
      race_path(locale, Race.find_by_name($1))

    when /the races page/
      races_path

    when /the race page/
      race_path(locale, @race)

    when /the media page of "(.*)"/
      new_race_medium_path(locale, Race.find_by_name($1))

    when /the results page of the series/
      race_series_path(locale, @series.race, @series)

    when /the results page of the competitor/
      series_competitor_path(locale, @competitor.series, @competitor)

    when /the start list page of the series/
      race_series_start_list_path(locale, @series.race, @series)

    when /the relay results page of "(.*)"/
      race_relay_path(locale, Relay.find_by_name($1).race, Relay.find_by_name($1))

    when /the registration page/
      register_path locale

    when /the login page/
      login_path locale

    when /the admin index page/
      admin_root_path locale

    when /the admin users page/
      admin_users_path locale

    when /the admin new user page/
      new_admin_user_path locale

    when /the admin races page/
      admin_races_path locale

    when /the send feedback page/
      new_feedback_path locale

    when /the info page/
      info_path locale

    when "/reset_password/unknown/edit"
      edit_reset_password_path(locale, :reset_hash => 'unknown')

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
