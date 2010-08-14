class Contest < ActiveRecord::Base
  belongs_to :sport

  validates :name, :presence => true
  validates :location, :presence => true
  validates :start_date, :presence => true
end
