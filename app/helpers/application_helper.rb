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

  def series_datetime_print(series, hours_and_minutes=false, seconds=false, nil_result='')
    date = series.race.start_date.to_date
    date += series.start_day - 1
    datetime = DateTime.parse("#{date.to_date} #{series.start_time.strftime("%H:%M:%S")}")
    datetime_print(datetime, hours_and_minutes, seconds, nil_result)
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

  def national_record(competitor, raw=false)
    tag=''
    tag << 'SE' if competitor.national_record_passed?
    tag << 'SE(sivuaa)' if competitor.national_record_reached?
    tag << '?' if (competitor.national_record_reached? or competitor.national_record_passed?) and not competitor.series.race.finished?
    return tag if tag and raw
    return raw("<span class='explanation'>" + 
               '<a href="' + NATIONAL_RECORD_URL + '">' +
               tag + '</a>' + '</span>' ) if tag
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

  def time_points_and_time(competitor, all_competitors=false)
    return '' if competitor.no_result_reason
    return 300 if competitor.series.time_points_type == Series::TIME_POINTS_TYPE_ALL_300
    return '-' if competitor.time_in_seconds.nil?
    points = competitor.time_points(all_competitors)
    html = (points == 300 ? "<span class='series_best_time'>" : '')
    html << "#{points} (#{time_from_seconds(competitor.time_in_seconds)})"
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

  def shot_points_and_total(competitor)
    return '' if competitor.no_result_reason
    return "-" if competitor.shots_sum.nil?
    "#{competitor.shot_points} (#{competitor.shots_sum})"
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

  def race_date_interval(race)
    date_interval(race.start_date, race.end_date)
  end

  def date_interval(start_date, end_date)
    interval = start_date.strftime('%d.%m.%Y')
    unless end_date.nil? or start_date == end_date
      interval << " - #{end_date.strftime('%d.%m.%Y')}"
    end
    interval
  end

  # -- Form child functions --
  def remove_child_link(name, f, hide_class, confirm_question)
    f.hidden_field(:_destroy) + button_to_function(name, "remove_fields(this, '#{hide_class}', '#{confirm_question}')")
  end

  def add_child_link(name, f, method, id=nil)
    fields = new_child_fields(f, method)
    button_to_function(name, "insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\")", :id => id)
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

  def sport_icon(sport)
    return '' unless sport
    image_tag "#{sport.key.downcase}_icon.gif"
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
      if type == 'results'
        link = series_competitors_path(series)
      elsif type == 'start_list'
        link = series_start_list_path(series)
      elsif type == 'competitors'
        link = official_series_competitors_path(series)
      elsif type == 'times'
        link = official_series_times_path(series)
      elsif type == 'estimates'
        link = official_series_estimates_path(series)
      elsif type == 'shots'
        link = official_series_shots_path(series)
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
      menu << "<li>#{link_to relay.name, race_relay_path(race, relay)}</li>"
    end
    menu << "</ul>"
    raw(menu)
  end

  def team_competitions_dropdown_menu(race)
    return '' if race.team_competitions.count <= 1
    menu = "<ul>"
    race.team_competitions.each do |tc|
      menu << "<li>#{link_to tc.name, race_team_competition_path(race, tc)}</li>"
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
    list += result_rotation_relay_list(race)
    list
  end

  def next_result_rotation(url)
    @race = @series.race if @series
    list = result_rotation_list(@race)
    return race_path(@race) if list.empty? and url.nil?
    return url if list.empty?
    place = list.index(url)
    if (place and place != list.size - 1)
      return list[place + 1]
    end
    return list[0]
  end

  def series_result_title(series, all_competitors=false)
    suffix = ''
    suffix = ' - Kaikki kilpailijat' if all_competitors
    return '(Ei kilpailijoita)' if series.competitors.empty?
    return '(Sarja ei ole vielä alkanut)' unless series.started?
    return "Tulokset#{suffix}" if series.race.finished?
    return "Väliaikatulokset (päivitetty: #{datetime_print(series.competitors.
      maximum(:updated_at), true, true, '-', true)})#{suffix}"
  end

  def relay_result_title(relay)
    return '(Ei joukkueita)' if relay.relay_teams.empty?
    return '(Viesti ei ole vielä alkanut)' unless relay.started?
    return 'Tulokset' if relay.finished?
    return "Väliaikatulokset (päivitetty: #{datetime_print(relay.relay_competitors.
      maximum(:updated_at), true, true, '-', true)})"
  end

  def correct_estimate_range(ce)
    return "#{ce.min_number}-" unless ce.max_number
    return ce.min_number unless ce.min_number != ce.max_number
    "#{ce.min_number}-#{ce.max_number}"
  end
  
  def time_title(race)
    return 'Juoksu' if race.sport.run?
    'Hiihto'
  end

  def club_title(race)
    return 'Seura' if race.club_level == Race::CLUB_LEVEL_SEURA
    return 'Piiri' if race.club_level == Race::CLUB_LEVEL_PIIRI
    raise "Unknown club level: #{race.club_level}"
  end

  def clubs_title(race)
    return 'Seurat' if race.club_level == Race::CLUB_LEVEL_SEURA
    return 'Piirit' if race.club_level == Race::CLUB_LEVEL_PIIRI
    raise "Unknown club level: #{race.club_level}"
  end
  
  def comparison_time_title(competitor, all_competitors, always_empty)
    return '' if always_empty
    comparison_time = competitor.comparison_time_in_seconds(all_competitors)
    return '' unless comparison_time
    " title='Vertailuaika: #{time_from_seconds(comparison_time, false)}'"
  end
  
  private
  def result_rotation_series_list(race)
    race_day = race.race_day
    return [] if race_day == 0
    list = []
    race.series.where(:start_day => race_day).each do |s|
      list << series_competitors_path(s) if s.started?
    end
    list
  end

  def result_rotation_tc_list(race)
    race.team_competitions.collect do |tc|
      race_team_competition_path(race, tc)
    end
  end

  def result_rotation_relay_list(race)
    race_day = race.race_day
    return [] if race_day == 0
    list = []
    race.relays.where(:start_day => race_day).each do |relay|
      list << race_relay_path(race, relay) if relay.started?
    end
    list
  end

  def result_rotation_cookie
    return cookies[result_rotation_cookie_name]
  end
  
  def result_rotation_tc_cookie
    return cookies[result_rotation_tc_cookie_name]
  end
end
