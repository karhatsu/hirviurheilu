class CorrectEstimate < ApplicationRecord
  belongs_to :race, touch: true

  #validates :race, :presence => true
  validates :min_number, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :max_number, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true }
  validates :distance1, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 50, :less_than_or_equal_to => 200 }
  validates :distance2, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 50, :less_than_or_equal_to => 200 }
  validates :distance3, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 50, :less_than_or_equal_to => 200,
    :allow_nil => true }
  validates :distance4, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 50, :less_than_or_equal_to => 200,
    :allow_nil => true }
  validate :overlapping_numbers

  def self.for_number_in_race(number, race)
    where(['race_id=? and min_number<=? and (max_number>=? or max_number is ?)',
        race.id, number, number, nil]).first
  end

  private
  def overlapping_numbers
    return unless min_number and race
    if max_number.nil?
      if another_max_number_nil_exists? or overlapping_min_numbers_exists?
        errors.add :max_number, :only_one_can_be_empty
      end
    else
      if overlapping_numbers_exists?
        errors.add :base, :overlapping_numbers
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
