class CupSeries
  def initialize(series)
    @series = [series]
  end
  
  def <<(series)
    raise "Series name (#{series.name}) should be #{name}" if series.name != name
    @series << series
  end
  
  def series
    @series
  end
  
  def name
    @series.first.name
  end
  
  def cup_competitors
    name_to_competitor = Hash.new
    @series.each do |series|
      series.competitors.each do |competitor|
        name = CupCompetitor.name(competitor)
        if name_to_competitor.has_key?(name)
          name_to_competitor[name] << competitor
        else
          name_to_competitor[name] = CupCompetitor.new(competitor)
        end
      end
    end
    name_to_competitor.values
  end
end