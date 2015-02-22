# encoding: UTF-8
module ApplicationHelper

  def offline?
    Mode.offline?
  end

  def flash_success
    raw("<div class='success'>#{flash[:success]}</div>") if flash[:success]
  end

  def flash_error
    raw("<div class='error'>#{flash[:error]}</div>") if flash[:error]
  end

  def highlight_info(content)
    timestamp = Time.now.to_f.to_s.gsub!('.', '')
    html = %{
      <div class="info" id="highlight_#{timestamp}">#{content}</div>
      <script type="text/javascript">
        $(document).ready(function() {
          setTimeout(function() {$("#highlight_#{timestamp}").addClass('info_flash')}, 500);
          setTimeout(function() {$("#highlight_#{timestamp}").removeClass('info_flash')}, 1000);
          setTimeout(function() {$("#highlight_#{timestamp}").addClass('info_flash')}, 1500);
          setTimeout(function() {$("#highlight_#{timestamp}").removeClass('info_flash')}, 2000);
        });
      </script>
    }
    raw(html)
  end

  def date_print(time)
    time.strftime('%d.%m.%Y')
  end

  def datetime_print(datetime, hours_and_minutes=false, seconds=false,
      nil_result='', to_local_zone=false)
    return nil_result if datetime.nil?
    t = date_print(datetime)
    t << " #{time_print(datetime, seconds, nil_result, to_local_zone)}" if hours_and_minutes
    t
  end

  def time_print(time, seconds=false, nil_result='', to_local_zone=false)
    return raw(nil_result) if time.nil?
    format = (seconds ? '%H:%M:%S' : '%H:%M')
    return time.in_time_zone(Time.zone).strftime(format) if to_local_zone
    time.strftime(format)
  end

  def series_start_time_print(series)
    datetime_print(series.start_datetime, true)
  end

  def relay_start_time_print(relay)
    date = relay.race.start_date.to_date
    date += relay.start_day - 1
    datetime = DateTime.parse("#{date.to_date} #{relay.start_time.strftime("%H:%M:%S")}")
    datetime_print(datetime, true)
  end

  def points_print(competitor, all_competitors=false)
    if competitor.no_result_reason
      return no_result_reason_print(competitor.no_result_reason)
    end
    points = competitor.points(all_competitors)
    return points.to_s unless points.nil?
    partial_points = competitor.points!(all_competitors)
    return "(#{partial_points})" unless partial_points.nil?
    "-"
  end
  
  def cup_points_print(competitor)
    points = competitor.points
    return points.to_s unless points.nil?
    partial_points = competitor.points!
    return "(#{partial_points})" unless partial_points.nil?
    "-"
  end
  
  def long_cup_series_name(cup_series)
    return cup_series.name if cup_series.has_single_series_with_same_name?
    "#{cup_series.name} (#{cup_series.series_names.split(',').join(', ')})"
  end

  def national_record(competitor, raw=false)
    if competitor.national_record_passed?
      tag = 'SE'
    elsif competitor.national_record_reached?
      tag = 'SE(sivuaa)'
    else
      return ''
    end
    tag << '?' unless competitor.series.race.finished?
    return tag if raw
    return raw("<span class='explanation'>" +
               '<a href="' + NATIONAL_RECORD_URL + '">' +
               tag + '</a>' + '</span>' )
    ''
  end

  def no_result_reason_print(no_result_reason, scope='competitor')
    raw("<span class='explanation' " +
      "title='#{t(scope + '.' + no_result_reason)}'>" +
      "#{no_result_reason}</span>")
  end

  def time_from_seconds(seconds,alwayssigned=false)
    return "-" if seconds.nil?
    if seconds < 0
      time = "-"
      seconds = seconds.abs
    else
      time = ""
      time = "+" if alwayssigned
    end
    return "-" if seconds.nil?
    h = seconds.to_i / 3600
    min = (seconds.to_i - h * 3600) / 60
    sec = seconds.to_i % 60
    time << (h >= 1 ? "#{h}:" : "")
    time << "#{min < 10 ? "0" : ""}#{min}:"
    time << "#{sec < 10 ? "0" : ""}#{sec}"
  end

  def time_points(competitor, with_time=false, all_competitors=false)
    return '' if competitor.no_result_reason
    return 300 if competitor.series.time_points_type == Series::TIME_POINTS_TYPE_ALL_300
    return '-' if competitor.time_in_seconds.nil?
    points = competitor.time_points(all_competitors)
    html = (points == 300 ? "<span class='series_best_time'>" : '')
    html << points.to_s
    html << " (#{time_from_seconds(competitor.time_in_seconds)})" if with_time
    html << (points == 300 ? "</span>" : '')
    raw(html)
  end

  def relay_time_adjustment(adjustment)
    return '' unless adjustment
    return '' if adjustment == 0
    html = '(<span class=\'adjustment\' title="Aika sisältää korjausta '
    html << time_from_seconds(adjustment, true)
    html << '">'
    html << time_from_seconds(adjustment, true)
    html << '</span>)'
    raw(html)
  end

  def shot_points(competitor, shots_total=false)
    return '' if competitor.no_result_reason
    return "-" if competitor.shots_sum.nil?
    points = competitor.shot_points.to_s
    points << " (#{competitor.shots_sum})" if shots_total
    points
  end

  def shots_list(competitor)
    return "-" if competitor.shots_sum.nil?
    return competitor.shots_total_input unless competitor.shots_total_input.nil?
    shot_values = competitor.shot_values
    list = ""
    shot_values.each_with_index do |v, i|
      list << "," if i > 0
      list << "#{v.to_i}"
    end
    list
  end

  def print_estimate_diff(diff)
    return "-" if diff.nil?
    d = ""
    d << "+" if diff > 0
    d << "#{diff}"
  end

  def estimate_diffs(competitor)
    if competitor.series.estimates == 4
      return "" if competitor.estimate1.nil? and competitor.estimate2.nil? and
        competitor.estimate3.nil? and competitor.estimate4.nil?
    else
      return "" if competitor.estimate1.nil? and competitor.estimate2.nil?
    end
    diffs = estimate_diff_with_sign_and_symbol(competitor.estimate_diff1_m)
    diffs << "/"
    diffs << estimate_diff_with_sign_and_symbol(competitor.estimate_diff2_m)
    if competitor.series.estimates == 4
      diffs << "/"
      diffs << estimate_diff_with_sign_and_symbol(competitor.estimate_diff3_m)
      diffs << "/"
      diffs << estimate_diff_with_sign_and_symbol(competitor.estimate_diff4_m)
    end
    diffs
  end

  def estimate_diff_with_sign_and_symbol(diff)
    if diff.nil?
      return "-"
    else
      return "#{diff > 0 ? "+" : ""}#{diff}m"
    end
  end

  def estimate_points_and_diffs(competitor)
    return '' if competitor.no_result_reason
    return "-" if competitor.estimate_points.nil?
    "#{competitor.estimate_points} (#{estimate_diffs(competitor)})"
  end

  def estimate_points(competitor)
    return '' if competitor.no_result_reason
    return "-" if competitor.estimate_points.nil?
    competitor.estimate_points
  end

  def correct_estimate(competitor, i, not_available_str)
    raise "Unknown index for correct estimate: #{i}" if i < 1 or i > 4
    return not_available_str unless competitor.series.race.finished
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

  def full_name(competitor, first_name_first=false)
    if first_name_first
      "#{competitor.first_name} #{competitor.last_name}"
    else
      "#{competitor.last_name} #{competitor.first_name}"
    end
  end

  def race_date_interval(race, time_tag=true)
    date_interval race.start_date, race.end_date, time_tag
  end

  def date_interval(start_date, end_date, time_tag=true)
    interval = ''
    interval << "<time itemprop='startDate' datetime='#{start_date.strftime('%Y-%m-%d')}'>" if time_tag
    interval << start_date.strftime('%d.%m.%Y')
    interval << "</time>" if time_tag
    unless end_date.nil? or start_date == end_date
      interval << " - #{end_date.strftime('%d.%m.%Y')}"
    end
    raw interval
  end

  # -- Form child functions --
  def remove_child_link(name, f, hide_class, confirm_question)
    onclick = "remove_fields(this, '#{hide_class}', '#{confirm_question}');"
    f.hidden_field(:_destroy) + tag(:input, {:type => 'button', :value => name, :onclick => onclick})
  end

  def add_child_link(name, f, method, id=nil)
    fields = new_child_fields(f, method)
    onclick = "insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\");"
    tag(:input, {:type => 'button', :value => name, :onclick => onclick, :id => id})
  end

  def new_child_fields(form_builder, method, index=nil, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f
    index_str = (index ? "_#{index}" : '')
    form_builder.fields_for(method, options[:object], :child_index => "new#{index_str}_#{method}") do |f|
      render(:partial => options[:partial],
        :locals => { options[:form_builder_local] => f, :index => index })
    end
  end
  # -- Form child functions (end) --

  def competition_icon(competition)
    alt = competition.sport.initials
    image_prefix = "#{competition.sport.key.downcase}_icon"
    return image_tag("#{image_prefix}_cup.gif", alt: alt, class: 'competition_icon') if competition.is_a?(Cup)
    image_tag "#{image_prefix}.gif", alt: alt, class: 'competition_icon'
  end

  def menu_item(title, link, selected, truncate_length=nil, do_block=false, &block)
    a_title = (truncate_length ? title : nil)
    title = truncate(title, :length => truncate_length) if truncate_length
    item = "<li>"
    if selected
      item << link_to(title, link, :class => 'selected', :title => a_title)
    else
      item << link_to(title, link, :title => a_title)
    end
    item << block.call if do_block and block
    item << "</li>"
    raw(item)
  end

  def dropdown_menu_single(item)
    raw("<ul><li>#{item}</li></ul>")
  end

  def series_dropdown_menu(race, type)
    return '' if race.series.count <= 1
    menu = "<ul>"
    race.series.each do |series|
      next if series.new_record?
      if type == 'results'
        link = series_competitors_path(locale_for_path, series)
      elsif type == 'start_list'
        link = series_start_list_path(locale_for_path, series)
      elsif type == 'competitors'
        link = official_series_competitors_path(locale_for_path, series)
      elsif type == 'times'
        link = official_series_times_path(locale_for_path, series)
      elsif type == 'estimates'
        link = official_series_estimates_path(locale_for_path, series)
      elsif type == 'shots'
        link = official_series_shots_path(locale_for_path, series)
      end
      menu << "<li>#{link_to series.name, link}</li>"
    end
    menu << "</ul>"
    raw(menu)
  end

  def relays_dropdown_menu(race)
    return '' if race.relays.count <= 1
    menu = "<ul>"
    race.relays.each do |relay|
      menu << "<li>#{link_to relay.name, race_relay_path(locale_for_path, race, relay)}</li>"
    end
    menu << "</ul>"
    raw(menu)
  end

  def team_competitions_dropdown_menu(race)
    return '' if race.team_competitions.count <= 1
    menu = "<ul>"
    race.team_competitions.each do |tc|
      menu << "<li>#{link_to tc.name, race_team_competition_path(locale_for_path, race, tc)}</li>"
    end
    menu << "</ul>"
    raw(menu)
  end
  
  def cup_series_dropdown_menu(cup)
    return '' if cup.cup_series.length <= 1
    menu = "<ul>"
    cup.cup_series.each do |cs|
      menu << "<li>#{link_to cs.name, cup_cup_series_path(locale_for_path, cup, cs)}</li>"
    end
    menu << "</ul>"
    raw(menu)
  end

  def yes_or_empty(boolean, value=nil, &block)
    if boolean
      image_tag('icon_yes.gif', :title => value)
    elsif block
      block.call
    else
      raw('&nbsp;')
    end
  end

  def value_or_space(value)
    return value if value
    raw('&nbsp;')
  end
  
  def menu_cup
    @cup if @cup and not @cup.new_record?
  end

  def menu_race
    if @race and not @race.new_record?
      @race
    elsif @series
      @series.race
    elsif @relay
      @relay.race
    elsif @competitor
      @competitor.series.race
    else
      nil
    end
  end

  def menu_series
    if @series
      @series
    elsif @competitor
      @competitor.series
    else
      nil
    end
  end

  def start_days_form_field(form_builder, series)
    race = series.race
    if race.nil? or race.days_count == 1
      series.start_day = 1 # in case there is an old, illegal value for some reason
      return form_builder.hidden_field(:start_day)
    else
      options = []
      start_date = race.start_date
      race.days_count.times do |i|
        options << [date_print(start_date.to_date + i), i + 1]
      end
      return form_builder.select(:start_day, options_for_select(options, series.start_day))
    end
  end

  def youtube_path
    "http://www.youtube.com/watch?v=oRNIy1G4qWM"
  end

  def link_with_protocol(link)
    return link if link[0, 7] == 'http://' or link[0, 8] == 'https://'
    'http://' + link
  end

  def result_rotation_list(race)
    return [] if offline?
    list = result_rotation_series_list(race)
    # team competition is active only when at least one series is active
    list += result_rotation_tc_list(race) unless list.empty? or !result_rotation_tc_cookie
    list
  end

  def next_result_rotation(race)
    url = request.fullpath
    list = result_rotation_list(race)
    return url if list.empty?
    place = list.index(url)
    if (place and place != list.size - 1)
      return list[place + 1]
    end
    list[0]
  end

  def series_result_title(series, all_competitors=false)
    suffix = ''
    suffix = " - #{t(:all_competitors)}" if all_competitors
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

  def correct_estimate_range(ce)
    return "#{ce.min_number}-" unless ce.max_number
    return ce.min_number unless ce.min_number != ce.max_number
    "#{ce.min_number}-#{ce.max_number}"
  end
  
  def time_title(race)
    return t(:run) if race.sport.run?
    t(:ski)
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
  
  def comparison_time_title(competitor, all_competitors=false, always_empty=false)
    return '' if always_empty
    comparison_time = competitor.comparison_time_in_seconds(all_competitors)
    return '' unless comparison_time
    raw " title='Vertailuaika: #{time_from_seconds(comparison_time, false)}'"
  end
  
  def comparison_and_own_time_title(competitor)
    time_in_seconds = competitor.time_in_seconds
    return '' unless time_in_seconds
    title = " title='Aika: #{time_from_seconds(time_in_seconds)}"
    comparison_time_in_seconds = competitor.comparison_time_in_seconds(false)
    title << ". Vertailuaika: #{time_from_seconds(comparison_time_in_seconds)}." if comparison_time_in_seconds
    title << "'"
    raw title
  end
  
  def shots_total_title(competitor)
    shots_sum = competitor.shots_sum
    return '' unless shots_sum
    raw " title='Ammuntatulos: #{shots_sum}'"
  end
  
  def title_prefix
    env = Rails.env
    return '' if env == 'production'
    return '(Offline) ' if env == 'winoffline-prod'
    return '(Dev) ' if env == 'development'
    return '(Offline-dev) ' if env == 'winoffline-dev'
    '(Testi) '
  end
  
  def locale_for_path
    return nil if I18n.locale == I18n.default_locale
    I18n.locale
  end
  
  def facebook_env?
    ['development', 'production'].include?(Rails.env)
  end
  
  def result_rotation_auto_scroll
    cookies[result_rotation_scroll_cookie_name]
  end
  
  def refresh_counter_min_seconds
    20
  end
  
  def refresh_counter_default_seconds
    30
  end
  
  def refresh_counter_auto_scroll
    !(menu_series.nil? or result_rotation_auto_scroll.nil?)
  end
  
  def refresh_counter_seconds(seconds=nil)
    return seconds if seconds
    auto_scroll = refresh_counter_auto_scroll
    return refresh_counter_default_seconds unless auto_scroll
    series = menu_series
    return refresh_counter_default_seconds unless series
    [refresh_counter_min_seconds, series.competitors.count].max
  end
  
  def organizer_info_with_possible_link(race)
    return nil if race.home_page.blank? and race.organizer.blank? and race.organizer_phone.blank?
    return race.organizer_phone if race.home_page.blank? and race.organizer.blank?
    info = race.organizer.blank? ? t("races.show.race_home_page") : race.organizer
    info = raw('<a href="' + link_with_protocol(race.home_page) + '" target="_blank">' + info + '</a>') unless race.home_page.blank?
    info << ", #{race.organizer_phone}" unless race.organizer_phone.blank?
    info
  end

  def races_drop_down_array(races)
    races.map { |race| ["#{race.name} (#{race_date_interval(race, false)}, #{race.location})", race.id] }
  end
  
  private
  def result_rotation_series_list(race)
    race_day = race.race_day
    return [] if race_day == 0
    list = []
    race.series.where(['start_day=?', race_day]).each do |s|
      list << series_competitors_path(locale_for_path, s) if s.started? and s.has_result_for_some_competitor?
    end
    list
  end

  def result_rotation_tc_list(race)
    race.team_competitions.collect do |tc|
      race_team_competition_path(locale_for_path, race, tc)
    end
  end

  def result_rotation_cookie
    return cookies[result_rotation_cookie_name]
  end
  
  def result_rotation_tc_cookie
    return cookies[result_rotation_tc_cookie_name]
  end
end
