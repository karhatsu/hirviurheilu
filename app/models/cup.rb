class Cup < ActiveRecord::Base
  has_and_belongs_to_many :races
  
  validates :name, :presence => true
  validates :top_competitions, :numericality => { :greater_than => 1, :only_integer => true }
end
