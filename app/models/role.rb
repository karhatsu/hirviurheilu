class Role < ActiveRecord::Base
  ADMIN = 'admin'
  OFFICIAL = 'official'

  validates :name, :presence => true, :uniqueness => true

  def self.create_roles
    create!(:name => Role::ADMIN)
    create!(:name => Role::OFFICIAL)
  end
end
