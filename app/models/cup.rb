class Cup < ApplicationRecord
  has_and_belongs_to_many :races, -> { order :start_date, :name }
  has_many :cup_series, -> { order :name }
  has_many :cup_team_competitions, -> { order :name }

  validates :name, :presence => true
  validates :top_competitions, :numericality => { :greater_than_or_equal_to => 1, :only_integer => true }

  accepts_nested_attributes_for :cup_series, :allow_destroy => true

  def start_date
    races.first.start_date if has_races?
  end

  def end_date
    races.last.end_date if has_races?
  end

  def location
    races.collect { |r| r.location }.uniq.join(' / ') if has_races?
  end

  def create_default_cup_series
    raise "Cannot create cup series when already has some" unless cup_series.empty?
    return unless has_races?
    races.first.series.each do |series|
      CupSeries.create!(:cup => self, :name => series.name)
    end
  end

  def create_default_cup_team_competitions
    raise "Cannot create cup team competitions when already has some" unless cup_team_competitions.empty?
    races.first&.team_competitions&.each do |tc|
      CupTeamCompetition.create! cup: self, name: tc.name
    end
  end

  def has_rifle?
    races.all? { |race| race.sport.european? }
  end

  def self.cup_races(cups)
    cup_races = []
    cups.each { |cup| cup.races.each { |race| cup_races << race } }
    cup_races
  end

  private
  def has_races?
    races.length > 0
  end
end
