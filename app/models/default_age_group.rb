class DefaultAgeGroup
  def initialize(name)
    @name = name
    @min_competitors = ['M', 'N'].include?(name[0]) ? 2 : 0
  end

  def name
    @name
  end

  def min_competitors
    @min_competitors
  end
end
