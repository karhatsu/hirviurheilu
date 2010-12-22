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
      if another_max_number_nil_exists? or overlapping_min_numbers_exists?
        errors.add(:max_number,
          'Vain yksi oikeiden arvioiden asetuksista voi sisältää tyhjän isoimman numeron.')
      end
    else
      if overlapping_numbers_exists?
        errors.add(:base,
          'Oikeiden arvioiden asetukset eivät voi sisältää päällekkäisiä numeroita.')
      end
    end
  end

  def another_max_number_nil_exists?
    condition = 'race_id=? and max_number is null'
    where = [condition, race.id]
    if id
      condition = "id<>? and #{condition}"
      where = [condition, id, race.id]
    end
    CorrectEstimate.where(where).size > 0
  end

  # when max_number is nil:
  def overlapping_min_numbers_exists?
    condition = 'race_id=? and max_number>=?'
    where = [condition]
    if id
      condition = "id<>? and #{condition}"
      where = [condition, id]
    end
    where += [race.id, min_number]
    CorrectEstimate.where(where).size > 0
  end

  def overlapping_numbers_exists?
    condition = 'race_id=? and (' +
      '(min_number<=? and max_number>=?) or (min_number<=? and max_number>=?))'
    where = [condition]
    if id
      condition = "id<>? and #{condition}"
      where = [condition, id]
    end
    where += [race.id, min_number, min_number, max_number, max_number]
    CorrectEstimate.where(where).size > 0
  end
end
