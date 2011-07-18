class AgeGroup < ActiveRecord::Base
  belongs_to :series
  has_many :competitors

  before_validation :set_min_competitors_default

  validates :name, :presence => true
  validates :min_competitors, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0 }

  def has_enough_competitors?(unofficial=false)
    competitors_count(unofficial) >= min_competitors
  end

  def competitors_count(unofficial)
    conditions = { :no_result_reason => nil }
    if unofficial
      @competitors_count_unofficial ||= competitors.where(conditions).size
    else
      conditions[:unofficial] = false
      @competitors_count ||= competitors.where(conditions).size
    end
  end

  def best_time_in_seconds(unofficial=false)
    return nil unless has_enough_competitors?(unofficial)
    if unofficial
      @seconds_cache_unofficial ||= Series.best_time_in_seconds(self, true)
    else
      @seconds_cache ||= Series.best_time_in_seconds(self, false)
    end
  end

  private
  def set_min_competitors_default
    self.min_competitors = 0 unless min_competitors
  end
end
