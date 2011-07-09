class Club < ActiveRecord::Base
  default_scope :order => :name

  belongs_to :race
  has_many :competitors

  before_validation :handle_empty_long_name

  validates :name, :presence => true, :uniqueness => { :scope => :race_id }
  validates :long_name, :uniqueness => { :scope => :race_id, :allow_nil => true }

  before_destroy :check_competitors

  def expanded
    return long_name if long_name
    name
  end

  private
  def handle_empty_long_name
    self.long_name = nil if long_name == ''
  end

  def check_competitors
    unless competitors.empty?
      errors.add(:base, 'Seuraa ei voi poistaa, koska sillä on kilpailijoita')
      return false
    end
  end
end
