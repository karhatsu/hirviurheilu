class RelayTeam < ActiveRecord::Base
  belongs_to :relay
  has_many :relay_competitors, :order => 'leg'

  validates :name, :presence => true
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 },
    :uniqueness => { :scope => :relay_id }

  accepts_nested_attributes_for :relay_competitors

  def time_in_seconds
    competitor = relay_competitors.where(:leg => relay.legs_count).first
    return nil unless competitor and competitor.arrival_time
    competitor.arrival_time - relay.start_time
  end
end
