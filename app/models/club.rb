class Club < ActiveRecord::Base
#TODO: problems with activescaffold
#  default_scope :order => :name

  belongs_to :race

  validates :name, :presence => true, :uniqueness => { :scope => :race_id }
end
