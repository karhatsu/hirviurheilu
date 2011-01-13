class Race < ActiveRecord::Base
  DEFAULT_START_INTERVAL = 60

  belongs_to :sport
  has_many :series, :order => 'name'
  has_many :competitors, :through => :series
  has_many :clubs, :order => 'name'
  has_many :correct_estimates, :order => 'min_number'
  has_and_belongs_to_many :users, :join_table => :race_officials

  accepts_nested_attributes_for :series, :allow_destroy => true
  accepts_nested_attributes_for :correct_estimates, :allow_destroy => true

  before_validation :set_end_date

  validates :sport, :presence => true
  validates :name, :presence => true
  validates :location, :presence => true
  validates :start_date, :presence => true
  validates :start_interval_seconds, :numericality => { :only_integer => true,
    :greater_than => 0 }
  validate :end_date_not_before_start_date

  before_destroy :prevent_destroy_if_series

  scope :past, :conditions => ['end_date<?', Date.today], :order => 'end_date DESC'
  scope :ongoing, :conditions => ['start_date<=? and end_date>=?',
    Date.today, Date.today]
  scope :future, :conditions => ['start_date>?', Date.today], :order => 'start_date'

  def add_default_series
    DefaultSeries.all.each do |ds|
      s = Series.new(:name => ds.name)
      ds.default_age_groups.each do |dag|
        s.age_groups << AgeGroup.new(:name => dag.name,
          :min_competitors => dag.min_competitors)
      end
      series << s
    end
  end

  def finish
    unless each_competitor_has_correct_estimates?
      errors.add(:base, "Osalta kilpailijoista puuttuu oikea arviomatka.")
      return false
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

  def finish!
    finish || raise(errors.full_messages.to_s)
  end

  def days_count
    return 1 if end_date.nil?
    (end_date - start_date).to_i + 1
  end

  def set_correct_estimates_for_competitors
    reload
    return if correct_estimates.empty?

    number_to_corrects_hash = Hash.new
    max_range_low_limit = nil
    correct_estimates.each do |ce|
      if ce.max_number.nil?
        max_range_low_limit = ce.min_number
        number_to_corrects_hash[max_range_low_limit] =
          [ce.distance1, ce.distance2, ce.distance3, ce.distance4]
      else
        (ce.min_number..ce.max_number).to_a.each do |nro|
          number_to_corrects_hash[nro] =
            [ce.distance1, ce.distance2, ce.distance3, ce.distance4]
        end
      end
    end

    competitors.each do |c|
      if c.number
        if max_range_low_limit and c.number >= max_range_low_limit
          set_correct_estimates_for_competitor(c, number_to_corrects_hash, max_range_low_limit)
        elsif number_to_corrects_hash[c.number]
          set_correct_estimates_for_competitor(c, number_to_corrects_hash, c.number)
        else
          c.reset_correct_estimates
        end
        c.save!
      end
    end
  end

  def each_competitor_has_correct_estimates?
    competitors.where('competitors.correct_estimate1 is null or ' +
        'competitors.correct_estimate2 is null').empty?
  end

  def estimates_at_most
    series.each do |s|
      return 4 if s.estimates == 4
    end
    2
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

  def prevent_destroy_if_series
    if series.count > 0
      errors.add(:base, "Kilpailun voi poistaa vain jos siinä ei ole sarjoja")
      return false
    end
  end

  def set_correct_estimates_for_competitor(competitor, number_to_corrects_hash, key)
    competitor.correct_estimate1 = number_to_corrects_hash[key][0]
    competitor.correct_estimate2 = number_to_corrects_hash[key][1]
    if competitor.series.estimates == 4
      competitor.correct_estimate3 = number_to_corrects_hash[key][2]
      competitor.correct_estimate4 = number_to_corrects_hash[key][3]
    else
      competitor.correct_estimate3 = nil
      competitor.correct_estimate4 = nil
    end
  end
end
