class Club < ActiveRecord::Base
#TODO: problems with activescaffold
#  default_scope :order => :name

  validates :name, :presence => true
  validates :name, :uniqueness => true
end
