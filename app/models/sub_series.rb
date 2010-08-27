class SubSeries < ActiveRecord::Base
  belongs_to :series

  validates :series, :presence => true
  validates :name, :presence => true
end
