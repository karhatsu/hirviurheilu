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

  def self.find_ski
    find_by_key(SKI)
  end

  def self.find_run
    find_by_key(RUN)
  end
end
