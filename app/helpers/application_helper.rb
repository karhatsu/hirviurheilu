module ApplicationHelper

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
    home_page = race.home_page
    organizer = race.organizer
    organizer_phone = race.organizer_phone
    address = race.address
    return nil if home_page.blank? && organizer.blank? && organizer_phone.blank? && address.blank?
    return organizer_phone if home_page.blank? && organizer.blank? && address.blank?
    info = []
    info << organizer if home_page.blank? && !organizer.blank?
    unless home_page.blank?
      link_label = organizer.blank? ? t('races.show.race_home_page') : organizer
      info << '<a href="' + link_with_protocol(home_page) + '" target="_blank">' + link_label + '</a>'
    end
    info << '<a href="https://www.google.fi/maps/place/' + address.gsub(/ /, '+') + '" target="_blank">' + address + '</a>' unless address.blank?
    info << organizer_phone unless organizer_phone.blank?
    raw info.join(', ')
  end

  def races_drop_down_array(races)
    races.map { |race| ["#{race.name} (#{race_date_interval(race, false)}, #{race.location})", race.id] }
  end
end
