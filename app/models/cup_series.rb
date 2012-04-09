class CupSeries
  def initialize(cup, series)
    @cup = cup
    @series = [series]
  end
  
  def cup
    @cup
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
    @cup_competitors ||= pick_competitors_with_same_name_in_all_races
  end
  
  def ordered_competitors
    cup_competitors.sort do |a, b|
      [b.points.to_i, b.points!.to_i] <=> [a.points.to_i, a.points!.to_i]
    end
  end
  
  private
  def pick_competitors_with_same_name_in_all_races
    name_to_competitor = Hash.new
    @series.each do |series|
      series.competitors.each do |competitor|
        name = CupCompetitor.name(competitor)
        if name_to_competitor.has_key?(name)
          name_to_competitor[name] << competitor
        else
          name_to_competitor[name] = CupCompetitor.new(self, competitor)
        end
      end
    end
    name_to_competitor.values
  end
end