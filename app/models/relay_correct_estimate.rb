class RelayCorrectEstimate < ActiveRecord::Base
  belongs_to :relay, touch: true

  validates :distance, :numericality => { :only_integer => true, :allow_nil => true,
    :greater_than_or_equal_to => 50, :less_than_or_equal_to => 200 }
  validates :leg, :numericality => { :only_integer => true, :greater_than => 0 },
    :uniqueness => { :scope => :relay_id }
  validate :leg_not_bigger_than_relay_legs_count

  private
  def leg_not_bigger_than_relay_legs_count
    if relay and leg > relay.legs_count
      errors.add(:leg, 'ei voi olla suurempi kuin viestin osuuksien määrä')
    end
  end
end
