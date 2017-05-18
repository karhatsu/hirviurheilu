class AgeGroup < ApplicationRecord
  belongs_to :series, touch: true
  has_many :competitors

  before_validation :set_min_competitors_default

  validates :name, :presence => true
  validates :min_competitors, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0 }

  def competitors_count(all_competitors)
    conditions = { :no_result_reason => nil }
    if all_competitors
      @competitors_count_all ||= competitors.where(conditions).size
    else
      conditions[:unofficial] = false
      @competitors_count ||= competitors.where(conditions).size
    end
  end

  private
  def set_min_competitors_default
    self.min_competitors = 0 unless min_competitors
  end
end
