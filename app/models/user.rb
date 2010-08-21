class User < ActiveRecord::Base
  acts_as_authentic

  validates :first_name, :presence => true
  validates :last_name, :presence => true
end
