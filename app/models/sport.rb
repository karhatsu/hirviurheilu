class Sport < ActiveRecord::Base
  SKI = "SKI"
  RUN = "RUN"

  has_many :races

  validates :name, :presence => true
  validates :key, :presence => true
  validates :key, :uniqueness => true

  def ski?
    key == SKI
  end

  def run?
    key == RUN
  end
  
  def initials
    ski? ? 'HH' : 'HJ'
  end

  def self.find_ski
    find_by_key(SKI)
  end

  def self.find_run
    find_by_key(RUN)
  end

  def self.default_sport
    month = Time.new.month
    if month >= 5 and month <= 10
      return find_run
    else
      return find_ski
    end
  end

  def self.create_ski
    create!(:name => "Hirvenhiihto", :key => "SKI")
  end

  def self.create_run
    create!(:name => "Hirvenjuoksu", :key => "RUN")
  end
end
