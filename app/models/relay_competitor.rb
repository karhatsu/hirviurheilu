class RelayCompetitor < ActiveRecord::Base
  belongs_to :relay_team

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :misses, :numericality => { :only_integer => true, :allow_nil => true,
    :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5 }
  validates :leg, :numericality => { :only_integer => true, :greater_than => 0 }
  validate :leg_not_bigger_than_relay_legs
  validate :arrival_not_before_start_time

  private
  def leg_not_bigger_than_relay_legs
    if relay_team and leg > relay_team.relay.legs
      errors.add(:leg, 'ei voi olla suurempi kuin viestin osuuksien määrä')
    end
  end

  def arrival_not_before_start_time
    return if start_time.nil? and arrival_time.nil?
    if start_time.nil?
      errors.add(:base,
        'Kilpailijalla ei voi olla saapumisaikaa, jos hänellä ei ole lähtöaikaa')
      return
    end
    if arrival_time and start_time >= arrival_time
      errors.add(:arrival_time, "pitää olla lähtöajan jälkeen")
    end
  end
end
