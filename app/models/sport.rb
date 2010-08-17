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
end
