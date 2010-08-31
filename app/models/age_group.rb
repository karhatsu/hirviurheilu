class AgeGroup < ActiveRecord::Base
  belongs_to :series
  has_many :competitors

  before_validation :set_min_competitors_default

  validates :name, :presence => true
  validates :min_competitors, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0 }

  def has_enough_competitors?
    competitors.size >= min_competitors
  end

  def best_time_in_seconds
    if @seconds_cache
      return @seconds_cache
    end
    @seconds_cache = Series.best_time_in_seconds(competitors)
  end

  private
  def set_min_competitors_default
    self.min_competitors = 0 unless min_competitors
  end
end
