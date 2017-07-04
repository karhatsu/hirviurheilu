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
      DefaultSeries.new('S13', ['T13', 0], ['P13', 0], ['T11', 0], ['P11', 0], ['T9', 0], ['P9', 0], ['T7', 0], ['P7', 0]),
      DefaultSeries.new('S15', ['T15', 0], ['P15', 0]),
      DefaultSeries.new('S17', ['T17', 0], ['P17', 0]),
      DefaultSeries.new('S20', ['T20', 0], ['P20', 0]),
      DefaultSeries.new('M', ['M40', 2]),
      DefaultSeries.new('M50'),
      DefaultSeries.new('M60', ['M65', 2]),
      DefaultSeries.new('M70', ['M75', 2]),
      DefaultSeries.new('M80', ['M85', 2], ['M90', 2]),
      DefaultSeries.new('N', ['N40', 2]),
      DefaultSeries.new('N50', ['N55', 2], ['N60', 2]),
      DefaultSeries.new('N65', ['N70', 2], ['N75', 2], ['N80', 2], ['N85', 2], ['N90', 2])
    ]
  end
end
