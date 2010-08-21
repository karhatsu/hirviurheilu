class Club < ActiveRecord::Base
  default_scope :order => :name

  validates :name, :presence => true
  validates :name, :uniqueness => true
end
