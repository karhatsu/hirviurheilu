class Race < ActiveRecord::Base
  belongs_to :sport
  has_many :series, :order => 'start_time'

  accepts_nested_attributes_for :series, :allow_destroy => true

  before_validation :set_end_date

  validates :sport, :presence => true
  validates :name, :presence => true
  validates :location, :presence => true
  validates :start_date, :presence => true
  validates :start_interval_seconds, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validate :end_date_not_before_start_date

  scope :past, :conditions => ['end_date<?', Date.today]
  scope :ongoing, :conditions => ['start_date<=? and end_date>=?',
    Date.today, Date.today]
  scope :future, :conditions => ['start_date>?', Date.today]

  private
  def end_date_not_before_start_date
    if end_date and end_date < start_date
      errors.add(:end_date, "ei voi olla ennen alkupäivää")
    end
  end

  def set_end_date
    self.end_date = start_date unless end_date
  end

end
