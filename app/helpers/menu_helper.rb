module MenuHelper
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

  def main_menu_item(title, link, icon, selected, do_block=false, &block)
    item = '<div class="menu__item">'
    link_with_icon = "<i class='material-icons-outlined md-18'>#{icon}</i> #{title}"
    if selected
      item << link_to(link, class: 'selected') {raw link_with_icon}
    else
      item << link_to(link) {raw link_with_icon}
    end
    item << block.call if do_block and block
    item << '</div>'
    raw(item)
  end

  def menu_item(title, link, selected, truncate_length=nil, do_block=false, &block)
    a_title = (truncate_length ? title : nil)
    title = truncate(title, :length => truncate_length) if truncate_length
    item = '<div class="menu__item">'
    if selected
      item << link_to(title, link, :class => 'selected', :title => a_title)
    else
      item << link_to(title, link, :title => a_title)
    end
    item << block.call if do_block and block
    item << '</div>'
    raw(item)
  end

  def dropdown_menu_single(item)
    raw("<div class='dropdown-menu'><div class='dropdown-menu__item'>#{item}</div></div>")
  end

  def races_dropdown_menu(races)
    menu = '<div class="dropdown-menu">'
    races.each do |race|
      menu << "<div class='dropdown-menu__item'>#{link_to race.name, race_path(race)}</div>"
    end
    menu << "<div class='dropdown-menu__item'>#{link_to "- #{t('home.show.all_competitions')} -", races_path}</div>"
    menu << '</div>'
    raw(menu)
  end

  def series_dropdown_menu(race, type)
    return '' if race.series.size <= 1
    menu = '<div class="dropdown-menu">'
    race.series.each do |series|
      next if series.new_record?
      if type == 'results'
        link = race_series_path(locale_for_path, race, series)
      elsif type == 'start_list'
        link = race_series_start_list_path(locale_for_path, race, series)
      elsif type == 'trap'
        link = race_trap_path(locale_for_path, race)
      elsif type == 'shotgun'
        link = race_shotgun_path(locale_for_path, race)
      elsif type == 'rifle_moving'
        link = race_rifle_moving_path(locale_for_path, race)
      elsif type == 'rifle_standing'
        link = race_rifle_standing_path(locale_for_path, race)
      elsif type == 'rifle'
        link = race_series_rifle_path(locale_for_path, race, series)
      elsif type == 'competitors'
        link = official_series_competitors_path(locale_for_path, series)
      elsif type == 'times'
        link = official_series_times_path(locale_for_path, series)
      elsif type == 'estimates'
        link = official_series_estimates_path(locale_for_path, series)
      elsif type == 'shots'
        link = official_series_shots_path(locale_for_path, series)
      end
      menu << "<div class='dropdown-menu__item'>#{link_to series.name, link}</div>"
    end
    menu << '</div>'
    raw(menu)
  end

  def relays_dropdown_menu(race)
    return '' if race.relays.count <= 1
    menu = '<div class="dropdown-menu">'
    race.relays.each do |relay|
      menu << "<div class='dropdown-menu__item'>#{link_to relay.name, race_relay_path(locale_for_path, race, relay)}</div>"
    end
    menu << '</div>'
    raw(menu)
  end

  def team_competitions_dropdown_menu(race, rifle=false)
    return '' if race.team_competitions.count <= 1
    menu = '<div class="dropdown-menu">'
    race.team_competitions.each do |tc|
      path = rifle ? race_rifle_team_competition_path(locale_for_path, race, tc) : race_team_competition_path(locale_for_path, race, tc)
      menu << "<div class='dropdown-menu__item'>#{link_to tc.name, path}</div>"
    end
    menu << '</div>'
    raw(menu)
  end

  def cup_series_dropdown_menu(cup, rifle=false)
    return '' if cup.cup_series.length <= 1
    menu = '<div class="dropdown-menu">'
    cup.cup_series.each do |cs|
      path = rifle ? cup_rifle_cup_series_path(locale_for_path, cup, cs) : cup_cup_series_path(locale_for_path, cup, cs)
      menu << "<div class='dropdown-menu__item'>#{link_to cs.name, path}</div>"
    end
    menu << '</div>'
    raw(menu)
  end
end
