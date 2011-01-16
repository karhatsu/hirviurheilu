module ApplicationHelper

  def flash_notice
    raw("<div class='notice'>#{flash[:notice]}</div>") if flash[:notice]
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

  def datetime_print(datetime, hours_and_minutes=false, seconds=false, nil_result='')
    return nil_result if datetime.nil?
    t = date_print(datetime)
    t << " #{time_print(datetime, seconds)}" if hours_and_minutes
    t
  end

  def time_print(time, seconds=false, nil_result='')
    return raw(nil_result) if time.nil?
    format = (seconds ? '%H:%M:%S' : '%H:%M')
    time.strftime(format)
  end

  def points_print(competitor)
    return competitor.no_result_reason if competitor.no_result_reason
    return competitor.points unless competitor.points.nil?
    return "(#{competitor.points!})" unless competitor.points!.nil?
    "-"
  end

  def time_from_seconds(seconds)
    return "-" if seconds.nil?
    h = seconds.to_i / 3600
    min = (seconds.to_i - h * 3600) / 60
    sec = seconds.to_i % 60
    time = (h >= 1 ? "#{h}:" : "")
    time << "#{min < 10 ? "0" : ""}#{min}:"
    time << "#{sec < 10 ? "0" : ""}#{sec}"
  end

  def time_points_and_time(competitor)
    return '' if competitor.no_result_reason
    return "-" if competitor.time_in_seconds.nil?
    points = competitor.time_points
    html = (points == 300 ? "<span class='series_best_time'>" : '')
    html << "#{competitor.time_points} (#{time_from_seconds(competitor.time_in_seconds)})"
    html << (points == 300 ? "</span>" : '')
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
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this, '#{hide_class}', '#{confirm_question}')")
  end

  def add_child_link(name, f, method, id=nil)
    fields = new_child_fields(f, method)
    link_to_function(name, "insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\")", :id => id)
  end

  def new_child_fields(form_builder, method, index=nil, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f
    index_str = (index ? "_#{index}" : '')
    form_builder.fields_for(method, options[:object], :child_index => "new#{index_str}_#{method}") do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f})
    end
  end
  # -- Form child functions (end) --

  def sport_icon(sport)
    return '' unless sport
    image_tag "#{sport.key.downcase}_icon.gif"
  end

  def menu_item(title, link, selected, truncate_length=nil)
    a_title = (truncate_length ? title : nil)
    title = truncate(title, :length => truncate_length) if truncate_length
    if selected
      raw("<li>#{link_to(title, link, :class => 'selected', :title => a_title)}</li>")
    else
      raw("<li>#{link_to(title, link, :title => a_title)}</li>")
    end
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

end
