class RelayTeam < ActiveRecord::Base
  belongs_to :relay
  has_many :relay_competitors, :order => 'leg'

  validates :name, :presence => true
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 },
    :uniqueness => { :scope => :relay_id }

  accepts_nested_attributes_for :relay_competitors
end
