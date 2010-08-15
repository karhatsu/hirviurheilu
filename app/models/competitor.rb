class Competitor < ActiveRecord::Base
  belongs_to :club

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :year_of_birth, :numericality => {:only_integer => true}
end
