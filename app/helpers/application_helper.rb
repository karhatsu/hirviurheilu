module ApplicationHelper

  def flash_notice
    raw("<div class='notice'>#{flash[:notice]}</div>") if flash[:notice]
  end

  def flash_error
    raw("<div class='error'>#{flash[:error]}</div>") if flash[:error]
  end

  def highlight_notice(content)
    timestamp = Time.now.to_i
    html = %{
      <div class="notice" id="highlight_#{timestamp}">#{content}</div>
      <script type="text/javascript">
        $(document).ready(function() {
          setTimeout(function() {$("#highlight_#{timestamp}").addClass('notice_flash')}, 500);
          setTimeout(function() {$("#highlight_#{timestamp}").removeClass('notice_flash')}, 1000);
          setTimeout(function() {$("#highlight_#{timestamp}").addClass('notice_flash')}, 1500);
          setTimeout(function() {$("#highlight_#{timestamp}").removeClass('notice_flash')}, 2000);
        });
      </script>
    }
    raw(html)
  end

  def datetime_print(time, hours_and_minutes=false, seconds=false, nil_result='')
    return nil_result if time.nil?
    t = time.strftime('%d.%m.%Y')
    t << " #{time_print(time, seconds)}" if hours_and_minutes
    t
  end

  def time_print(time, seconds=false, nil_result='')
    return nil_result if time.nil?
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
    "#{competitor.time_points} (#{time_from_seconds(competitor.time_in_seconds)})"
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
    return "" if competitor.estimate1.nil? and competitor.estimate2.nil?
    diff1 = competitor.estimate_diff1_m
    diff2 = competitor.estimate_diff2_m
    diffs = ""
    if diff1.nil?
      diffs << "-"
    else
      diffs << "+" if diff1 > 0
      diffs << "#{diff1}m"
    end
    diffs << "/"
    if diff2.nil?
      diffs << "-"
    else
      diffs << "+" if diff2 > 0
      diffs << "#{diff2}m"
    end
    diffs
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

  def correct_estimate(series, i, not_available_str)
    raise "Unknown index for correct estimate: #{i}" if i != 1 and i != 2
    return not_available_str unless series.race.finished
    correct = (i == 1 ? series.correct_estimate1 : series.correct_estimate2)
    return not_available_str unless correct
    correct
  end

  def full_name(competitor)
    "#{competitor.last_name} #{competitor.first_name}"
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

  def add_child_link(name, f, method)
    fields = new_child_fields(f, method)
    link_to_function(name, "insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\")")
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

end
