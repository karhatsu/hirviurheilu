class Club < ApplicationRecord
  default_scope { order :name }

  belongs_to :race, touch: true
  has_many :competitors
  has_many :race_rights

  before_validation :handle_empty_long_name

  validates :name, :presence => true, :uniqueness => { :scope => :race_id }
  validates :long_name, :uniqueness => { :scope => :race_id, :allow_nil => true }

  before_destroy :check_competitors

  def display_name
    return long_name if long_name
    name
  end
  
  def can_be_removed?
    competitors.empty? and race_rights.empty?
  end

  private
  def handle_empty_long_name
    self.long_name = nil if long_name == ''
  end

  def check_competitors
    unless can_be_removed?
      errors.add(:base, 'Seuraa ei voi poistaa, koska sillä on kilpailijoita tai jollain toimitsijalla on oikeudet vain tähän seuraan')
      return false
    end
  end
end
