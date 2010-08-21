class Role < ActiveRecord::Base
  ADMIN = 'admin'
  OFFICIAL = 'official'

  validates :name, :presence => true, :uniqueness => true
end
