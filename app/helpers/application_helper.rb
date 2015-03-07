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

  def full_name(competitor, first_name_first=false)
    if first_name_first
      "#{competitor.first_name} #{competitor.last_name}"
    else
      "#{competitor.last_name} #{competitor.first_name}"
    end
  end

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

  def races_dropdown_menu(races)
    menu = "<ul>"
    races.each do |race|
      menu << "<li>#{link_to race.name, race_path(race)}</li>"
    end
    menu << "<li>#{link_to "- #{t('home.show.all_competitions')} -", races_path}</li>"
    menu << "</ul>"
    raw(menu)
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
  
  def locale_for_path
    return nil if I18n.locale == I18n.default_locale
    I18n.locale
  end
  
  def facebook_env?
    ['development', 'production'].include?(Rails.env)
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
end
