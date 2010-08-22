class Competitor < ActiveRecord::Base
  DNS = 'DNS' # did not start
  DNF = 'DNF' # did not finish

  belongs_to :club
  belongs_to :series
  has_many :shots

  accepts_nested_attributes_for :shots, :allow_destroy => true

  validates :series, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :number, :numericality => { :only_integer => true,
    :greater_than => 0, :allow_nil => true }, :uniqueness => { :scope => :series_id }
  validates :year_of_birth, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 1900, :less_than_or_equal_to => 2100 }
  validates :shots_total_input, :allow_nil => true,
    :numericality => { :only_integer => true,
      :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :estimate1, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => -1 }
  validates :estimate2, :allow_nil => true,
    :numericality => { :only_integer => true, :greater_than => -1 }
  validate :arrival_not_before_start_time
  validate :only_one_shot_input_method_used
  validate :max_ten_shots
  validate :check_no_result_reason

  def shot_values
    values = shots.collect do |s|
      s.value
    end
    (10 - values.length).times do
      values << nil
    end
    values
  end

  def shots_sum
    return shots_total_input if shots_total_input
    return nil if shots.empty?
    sum = 0
    shots.each do |s|
      sum += s.value.to_i
    end
    sum
  end

  def time_in_seconds
    return nil if start_time.nil? or arrival_time.nil?
    arrival_time - start_time
  end

  def shot_points
    sum = shots_sum
    return nil if sum.nil?
    6 * sum
  end

  def estimate_diff1_m
    return nil if estimate1.nil?
    estimate1 - series.correct_estimate1
  end

  def estimate_diff2_m
    return nil if estimate2.nil?
    estimate2 - series.correct_estimate2
  end

  def estimate_points
    return nil if estimate1.nil? or estimate2.nil?
    points = 300 - 2 * (series.correct_estimate1 - estimate1).abs -
      2 * (series.correct_estimate2 - estimate2).abs
    return points if points >= 0
    0
  end

  def time_points
    own_time = time_in_seconds
    return nil if own_time.nil?
    points = 300 - (own_time - series.best_time_in_seconds) / 6
    if points > 300
      raise "Time points bigger than max and no DNS/DNF!" unless no_result_reason
      return nil
    end
    return points.to_i if points >= 0
    0
  end

  def points
    sp = shot_points
    return nil if sp.nil?
    ep = estimate_points
    return nil if ep.nil?
    tp = time_points
    return nil if tp.nil?
    sp + ep + tp
  end

  def points!
    shot_points.to_i + estimate_points.to_i + time_points.to_i
  end

  def next_competitor
    unless number
      return self
    end
    comp = @series.competitors.find(:first, :conditions => ['number>?', number],
      :order => 'number')
    return comp if comp
    @series.competitors.find(:first, :conditions => 'number is not null',
      :order => 'number')
  end

  def previous_competitor
    unless number
      return self
    end
    comp = @series.competitors.find(:first, :conditions => ['number<?', number],
      :order => 'number DESC')
    return comp if comp
    @series.competitors.find(:first, :conditions => 'number is not null',
      :order => 'number DESC')
  end

  protected
  def arrival_not_before_start_time
    return if start_time.nil? or arrival_time.nil?
    errors.add(:arrival_time, :arrival_not_before_start_time) if start_time > arrival_time
  end

  def only_one_shot_input_method_used
    if shots_total_input
      shots.each do |s|
        if s.value
          errors.add(:shots_total_input,
            "Ammuntatulokset voi syöttää vain summana tai yksittäisinä laukauksina")
        end
      end
    end
  end

  def max_ten_shots
    errors.add(:shots, "Laukauksia voi olla enintään 10") if shots.length > 10
  end

  def check_no_result_reason
    self.no_result_reason = nil if no_result_reason == ''
    unless [nil, DNS, DNF].include?(no_result_reason)
      errors.add(:no_result_reason, "Tuntematon syy tuloksen puuttumiselle: '#{no_result_reason}'")
    end
  end

end
