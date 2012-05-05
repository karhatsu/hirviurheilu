class Cup < ActiveRecord::Base
  has_and_belongs_to_many :races, :order => :start_date
  has_many :cup_series
  
  validates :name, :presence => true
  validates :top_competitions, :numericality => { :greater_than => 1, :only_integer => true }
  
  def sport
    races.first.sport if has_races?
  end
  
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
