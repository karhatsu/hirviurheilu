class CorrectEstimate < ActiveRecord::Base
  belongs_to :race

  validates :race, :presence => true
  validates :min_number, :numericality => { :only_integer => true,
    :greater_than => 0 }
  validates :max_number, :numericality => { :only_integer => true,
    :greater_than => 0, :allow_nil => true }
  validates :distance1, :numericality => { :only_integer => true,
    :greater_than => 0 }
  validates :distance2, :numericality => { :only_integer => true,
    :greater_than => 0 }
  validate :overlapping_numbers

  private
  def overlapping_numbers
    return unless min_number and race
    if max_number.nil?
      unless CorrectEstimate.where(:race_id => race.id, :max_number => nil).empty?
        errors.add(:max_number,
          'Vain yksi oikeiden arvioiden asetuksista voi sisältää tyhjän isoimman numeron.')
      end
    else
      condition = 'race_id=? and (' +
        '(min_number<=? and max_number>=?) or (min_number<=? and max_number>=?))'
      unless CorrectEstimate.where([condition, race.id, min_number, min_number,
            max_number, max_number]).empty?
        errors.add(:base,
          'Oikeiden arvioiden asetukset eivät voi sisältää päällekkäisiä numeroita.')
      end
    end
  end
end
