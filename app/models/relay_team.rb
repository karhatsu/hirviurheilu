class RelayTeam < ActiveRecord::Base
  belongs_to :relay
  has_many :relay_competitors

  validates :name, :presence => true
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 }
end
