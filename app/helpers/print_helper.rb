module PrintHelper
  def format_event_races(event_races)
    series_map = event_races.reduce({}) do |map, data|
      map[data[0]] ||= []
      map[data[0]] << data[2]
      map
    end
    series_map.map do |series, sports|
      "#{series} (#{sports.join(', ')})"
    end.join(', ')
  end
end
