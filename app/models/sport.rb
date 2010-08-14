class Sport < ActiveRecord::Base
  has_many :contests

  validates :name, :presence => true
  validates :key, :presence => true
  validates :key, :uniqueness => true
end
