class Sport < ActiveRecord::Base
  validates :name, :presence => true
  validates :key, :presence => true
  validates :key, :uniqueness => true
end
