class Race < ActiveRecord::Base
  belongs_to :sport
  has_many :series

  accepts_nested_attributes_for :series, :allow_destroy => true

  validates :sport, :presence => true
  validates :name, :presence => true
  validates :location, :presence => true
  validates :start_date, :presence => true
  validate :end_date_not_before_start_date

  private
  def end_date_not_before_start_date
    if end_date and end_date < start_date
      errors.add(:end_date, "ei voi olla ennen alkupäivää")
    end
  end
end
