class DefaultSeries < ActiveRecord::Base
  validates :name, :presence => true
end
