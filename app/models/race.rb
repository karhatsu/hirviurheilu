class Race < ActiveRecord::Base
  belongs_to :sport
  has_many :series, :order => 'start_time'
  has_many :competitors, :through => :series

  accepts_nested_attributes_for :series, :allow_destroy => true

  before_validation :set_end_date

  validates :sport, :presence => true
  validates :name, :presence => true
  validates :location, :presence => true
  validates :start_date, :presence => true
  validates :start_interval_seconds, :numericality => { :only_integer => true,
    :allow_nil => true, :greater_than => 0 }
  validate :end_date_not_before_start_date

  scope :past, :conditions => ['end_date<?', Date.today], :order => 'end_date DESC'
  scope :ongoing, :conditions => ['start_date<=? and end_date>=?',
    Date.today, Date.today]
  scope :future, :conditions => ['start_date>?', Date.today], :order => 'start_date'

  def finish
    series.each do |s|
      unless s.correct_estimate1 and s.correct_estimate2
        errors.add(:base, "Ainakin sarjasta #{s.name} puuttuu oikea arviomatka.")
        return false
      end
    end
    competitors.each do |c|
      unless c.finished?
        name = "#{c.first_name} #{c.last_name}"
        errors.add(:base, "Ainakin yhdeltä kilpailijalta " +
          "(#{name}, #{c.series.name}) puuttuu tulos. " +
          "Jos kilpailija ei ole lähtenyt matkaan tai on keskeyttänyt, " +
          "merkitse tieto tuloslomakkeen 'Ei tulosta' kohtaan.")
        return false
      end
    end
    self.finished = true
    save!
    true
  end

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
