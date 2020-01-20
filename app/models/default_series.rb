class DefaultSeries
  def initialize(name, age_group_names = nil)
    @name = name
    @age_groups = (age_group_names || []).map {|name| DefaultAgeGroup.new name}
  end

  def name
    @name
  end

  def default_age_groups
    @age_groups
  end

  def self.all(sport)
    sport.default_series.map { |item| DefaultSeries.new item[0], item[1] }
  end
end
