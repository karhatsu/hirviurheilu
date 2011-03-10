class RelayTeam < ActiveRecord::Base
  belongs_to :relay

  validates :name, :presence => true
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 }
end
