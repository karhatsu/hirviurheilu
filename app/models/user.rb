class User < ActiveRecord::Base
  acts_as_authentic

  has_and_belongs_to_many :roles, :join_table => :rights
  has_and_belongs_to_many :races, :join_table => :race_officials

  validates :first_name, :presence => true
  validates :last_name, :presence => true

  def add_admin_rights
    add_role Role::ADMIN
  end

  def add_official_rights
    add_role Role::OFFICIAL
  end

  def admin?
    has_role?(Role::ADMIN)
  end

  def official?
    has_role?(Role::OFFICIAL)
  end

  def official_for_race?(race)
    races.each do |r|
      return true if r == race
    end
    false
  end

  private
  def add_role(role)
    roles << Role.find_by_name(role)
  end

  def has_role?(role)
    roles.each do |r|
      return true if r.name == role
    end
    false
  end
end
