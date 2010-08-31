class DefaultSeries < ActiveRecord::Base
  has_many :default_age_groups

  validates :name, :presence => true
end
