class Role < ActiveRecord::Base
  ADMIN = 'admin'
  OFFICIAL = 'official'

  validates :name, :presence => true, :uniqueness => true

  def self.ensure_default_roles_exist
    Role.create!(:name => Role::ADMIN) unless Role.find_by_name(Role::ADMIN)
    Role.create!(:name => Role::OFFICIAL) unless Role.find_by_name(Role::OFFICIAL)
  end

  def self.create_roles
    create!(:name => Role::ADMIN)
    create!(:name => Role::OFFICIAL)
  end
end
