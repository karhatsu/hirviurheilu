class DefaultSeries
  def initialize(name, *age_group_names_and_min_competitors)
    @name = name
    @age_groups = []
    age_group_names_and_min_competitors.each do |age_group|
      @age_groups << DefaultAgeGroup.new(age_group[0], age_group[1])
    end
  end
  
  def name
    @name
  end
  
  def default_age_groups
    @age_groups
  end
  
  def self.all
    [
      DefaultSeries.new('S15', ['T15', 0], ['P15', 0]),
      DefaultSeries.new('S17', ['T17', 0], ['P17', 0]),
      DefaultSeries.new('S20', ['T20', 0], ['P20', 0]),
      DefaultSeries.new('M'),
      DefaultSeries.new('M50'),
      DefaultSeries.new('M60', ['M65', 3]),
      DefaultSeries.new('M70', ['M75', 3], ['M80', 3], ['M85', 3], ['M90', 3]),
      DefaultSeries.new('N'),
      DefaultSeries.new('N50', ['N60', 3], ['N65', 3], ['N70', 3], ['N75', 3], ['N80', 3], ['N85', 3], ['N90', 3])
    ]
  end
end
