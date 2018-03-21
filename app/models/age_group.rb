class AgeGroup < ApplicationRecord
  belongs_to :series, touch: true
  has_many :competitors

  before_validation :set_min_competitors_default

  validates :name, :presence => true
  validates :min_competitors, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0 }

  def competitors_count(unofficials)
    if unofficials == Series::UNOFFICIALS_EXCLUDED
      @competitors_count ||= competitors.where(unofficial: false).where('no_result_reason<>? OR no_result_reason IS NULL', Competitor::DNS).size
    else
      @competitors_count_all ||= competitors.where('no_result_reason<>? OR no_result_reason IS NULL', Competitor::DNS).size
    end
  end

  private
  def set_min_competitors_default
    self.min_competitors = 0 unless min_competitors
  end
end
