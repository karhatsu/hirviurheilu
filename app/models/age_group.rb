class AgeGroup < ActiveRecord::Base
  belongs_to :series
  has_many :competitors

  before_validation :set_min_competitors_default

  validates :name, :presence => true
  validates :min_competitors, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0 }

  def has_enough_competitors?
    competitors_count >= min_competitors
  end

  def competitors_count
    @competitors_count ||= competitors.where(:unofficial => false).size
  end

  def best_time_in_seconds
    return nil unless has_enough_competitors?
    @seconds_cache ||= Series.best_time_in_seconds(self)
  end

  private
  def set_min_competitors_default
    self.min_competitors = 0 unless min_competitors
  end
end
