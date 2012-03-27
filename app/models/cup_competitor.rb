class CupCompetitor
  def initialize(competitor)
    @competitors = [competitor]
  end
  
  def first_name
    @competitors.first.first_name
  end
  
  def last_name
    @competitors.first.last_name
  end
  
  def <<(competitor)
    raise "Competitor name (#{name(competitor)}) should be #{name(self)}" unless name(competitor) == name(self)
    @competitors << competitor
  end
  
  def competitors
    @competitors
  end
  
  private
  def name(competitor)
    "#{competitor.last_name} #{competitor.first_name}"
  end
end