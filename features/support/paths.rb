module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the official index page/
      official_root_path

    when /the new race page/
      new_official_race_path

    when /the race edit page of "(.*)"/
      edit_official_race_path(Race.find_by_name($1))

    when /the official race page of "(.*)"/
      official_race_path(Race.find_by_name($1))

    when /the new competitor page of the series/
      new_official_series_competitor_path(@series)

    when /the official competitors page of the series/
      official_series_competitors_path(@series)

    when /the official clubs page for "(.*)"/
      official_race_clubs_path(Race.find_by_name($1))

    when /the invite officials page for "(.*)"/
      official_race_invite_officials_path(Race.find_by_name($1))

    when /the export race page of "(.*)"/
      new_official_race_exports_path(Race.find_by_name($1))

    when /the official relays page of "(.*)"/
      official_race_relays_path(Race.find_by_name($1))

    when /the edit relay page of "(.*)"/
      edit_official_race_relay_path(Relay.find_by_name($1).race, Relay.find_by_name($1))

    when /the finish relay page of "(.*)"/
      new_official_relay_finish_relay_path(Relay.find_by_name($1).race)

    when /the official team competitions page of "(.*)"/
      official_race_team_competitions_path(Race.find_by_name($1))

    when /the race page of "(.*)"/
      race_path(Race.find_by_name($1))

    when /the race page/
      race_path(@race)

    when /the media page of "(.*)"/
      new_race_medium_path(Race.find_by_name($1))

    when /the results page of the series/
      series_competitors_path(@series)

    when /the results page of the competitor/
      series_competitor_path(@competitor.series, @competitor)

    when /the start list page of the series/
      series_start_list_path(@series)

    when /the relay results page of "(.*)"/
      race_relay_path(Relay.find_by_name($1).race, Relay.find_by_name($1))

    when /the registration page/
      register_path

    when /the login page/
      login_path

    when /the activation key page/
      new_activation_key_path

    when /the admin index page/
      admin_root_path

    when /the send feedback page/
      new_feedback_path

    when /the info page/
      info_path

    when /the offline-online comparison page/
      offline_vs_online_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
