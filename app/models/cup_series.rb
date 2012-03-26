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
end