class Race < ApplicationRecord
  include CompetitorsCopy

  DEFAULT_START_INTERVAL = 60
  DEFAULT_BATCH_INTERVAL = 180

  CLUB_LEVEL_SEURA = 0
  CLUB_LEVEL_PIIRI = 1

  START_ORDER_NOT_SELECTED = 0
  START_ORDER_BY_SERIES = 1
  START_ORDER_MIXED = 2

  belongs_to :district
  belongs_to :sport
  has_many :series, -> { order(:name) }, :dependent => :destroy
  has_many :age_groups, :through => :series
  has_many :competitors, -> { order(:last_name, :first_name) }, :through => :series
  has_many :clubs, :dependent => :destroy
  has_many :correct_estimates, -> { order :min_number }
  has_many :relays, -> { order(:name) }, :dependent => :destroy
  has_many :team_competitions, -> { order :name }, :dependent => :destroy
  has_many :race_rights
  has_many :users, :through => :race_rights
  has_and_belongs_to_many :cups

  accepts_nested_attributes_for :series, :allow_destroy => true
  accepts_nested_attributes_for :correct_estimates, :allow_destroy => true
  accepts_nested_attributes_for :clubs
  accepts_nested_attributes_for :relays
  accepts_nested_attributes_for :team_competitions

  before_validation :set_end_date, :set_club_level

  validates :sport, :presence => true
  validates :name, :presence => true
  validates :location, :presence => true
  validates :start_date, :presence => true
  validates :start_interval_seconds, :numericality => { :only_integer => true,
    :greater_than => 0 }
  validates :batch_size, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0 }
  validates :batch_interval_seconds, :numericality => { :only_integer => true,
    :greater_than => 0 }
  validates :club_level, :inclusion => { :in => [CLUB_LEVEL_SEURA, CLUB_LEVEL_PIIRI] }
  validates :start_order, :inclusion => { :in => [START_ORDER_BY_SERIES, START_ORDER_MIXED],
    :message => :have_to_choose }
  validate :end_date_not_before_start_date
  validate :check_duplicate_name_location_start_date, :on => :create
  validate :check_competitors_on_change_to_mixed_start_order, :on => :update
  
  after_save :set_series_start_lists_if_needed, :on => :update

  scope :past, lambda { where('end_date<?', Time.zone.today).includes(:sport).order('end_date DESC, name') }
  scope :today, lambda { where('start_date=? OR end_date=?', Time.zone.today, Time.zone.today).includes(:sport).order('start_date, name') }
  scope :future, lambda { where('start_date>?', Time.zone.today).includes(:sport).order('start_date, name') }

  attr_accessor :email, :password # for publishing

  def race
    self
  end

  def self.cache_key_for_all
    "races/all-#{cache_timestamp(Race.maximum(:updated_at))}"
  end

  def cache_key_for_all_series
    "races/#{id}-#{cache_timestamp(updated_at)}-allseries-#{cache_timestamp(series.maximum(:updated_at))}"
  end
  
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
      errors.add :base, :correct_estimate_missing
      return false
    end
    competitors.each do |c|
      unless c.finished?
        name = "#{c.first_name} #{c.last_name}"
        errors.add :base, :result_missing, :name => name, :series_name => c.series.name
        return false
      end
    end
    self.finished = true
    save!
    series.each do |s|
      s.destroy if s.competitors.count == 0
    end
    true
  end

  def finish!
    finish || raise(errors.full_messages.to_s)
  end

  def days_count
    return 1 if end_date.nil?
    (end_date - start_date).to_i + 1
  end
  
  def days_count=(days)
    days = days.to_i
    raise "days (#{days}) must be positive" if days <= 0
    if start_date
      self.end_date = start_date + days - 1
    end
    @days_count_temp = days
  end
  
  def start_date=(date)
    super(date)
    if @days_count_temp.to_i > 0
      self.days_count = @days_count_temp
    end
  end
  
  def end_date=(date)
    super
    @days_count_temp = nil
  end

  def set_correct_estimates_for_competitors!
    errors = set_correct_estimates_for_competitors
    raise errors.join('. ') unless errors.empty?
  end

  def set_correct_estimates_for_competitors
    reload
    return [] if correct_estimates.empty?

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

    errors = []
    competitors.each do |c|
      if c.number
        if max_range_low_limit and c.number >= max_range_low_limit
          set_correct_estimates_for_competitor(c, number_to_corrects_hash, max_range_low_limit)
        elsif number_to_corrects_hash[c.number]
          set_correct_estimates_for_competitor(c, number_to_corrects_hash, c.number)
        else
          c.reset_correct_estimates
        end
        if c.valid?
          c.save
        else
          errors = errors + c.errors.full_messages
        end
      end
    end

    errors
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

  def has_team_competition?
    not team_competitions.empty?
  end
  
  def has_team_competitions_with_team_names?
    team_competitions.exists?(:use_team_name => true)
  end

  def has_any_national_records_defined?
    series.each do |s|
      return true if s.national_record
    end
    false
  end

  def race_day
    day = (Time.zone.today - start_date).to_i + 1
    return 0 if day < 0 or day > days_count
    day
  end

  def next_start_number
    competitors.maximum(:number).to_i + 1
  end

  def next_start_time
    max_time = competitors.maximum(:start_time)
    return '00:00:00' unless max_time
    start_time = max_time + start_interval_seconds
    start_time
  end

  def all_competitions_finished?
    return false unless finished?
    relays.each do |relay|
      return false unless relay.finished
    end
    true
  end
  
  def can_destroy?
    competitors.count == 0 and relays.count == 0
  end

  def start_time_defined?
    start_time and start_time.strftime('%H:%M') != '00:00'
  end

  def short_start_time
    return nil unless start_time_defined?
    start_time.strftime '%H:%M:%S'
  end
  
  private
  def end_date_not_before_start_date
    if end_date and end_date < start_date
      errors.add :end_date, :must_not_be_before_start_date
    end
  end

  def check_duplicate_name_location_start_date
    if name and location and start_date and
        Race.exists?(:name => name, :location => location, :start_date => start_date)
      errors.add :base, :already_race_with_same_name_location_date
    end
  end
  
  def check_competitors_on_change_to_mixed_start_order
    if start_order == START_ORDER_MIXED and competitors.where(:start_time => nil).count > 0
      errors.add :base, :start_order_mixed_not_allowed
    end
  end
  
  def set_series_start_lists_if_needed
    return unless start_order == START_ORDER_MIXED
    series.each do |s|
      unless s.has_start_list
        s.has_start_list = true
        s.save!
      end
    end
  end

  def set_end_date
    self.end_date = start_date unless end_date
  end

  def set_club_level
    self.club_level = CLUB_LEVEL_SEURA unless club_level
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

  def cache_timestamp(updated_at)
    Race.cache_timestamp updated_at
  end

  def self.cache_timestamp(updated_at)
    updated_at.try(:utc).try(:to_s, :nsec)
  end
end
