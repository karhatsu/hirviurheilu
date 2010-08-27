class AgeGroup < ActiveRecord::Base
  belongs_to :series
  has_many :competitors

  validates :series, :presence => true
  validates :name, :presence => true

  def best_time_in_seconds
    if @seconds_cache
      return @seconds_cache
    end
    @seconds_cache = Series.best_time_in_seconds(competitors)
  end
end
