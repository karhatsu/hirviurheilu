class DefaultAgeGroup < ActiveRecord::Base
  belongs_to :default_series

  before_validation :set_min_competitors_default

  validates :name, :presence => true
  validates :min_competitors, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0 }

  private
  def set_min_competitors_default
    self.min_competitors = 0 unless min_competitors
  end
end
