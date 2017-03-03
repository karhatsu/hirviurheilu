class User < ActiveRecord::Base
  OFFLINE_USER_EMAIL = 'offline@hirviurheilu.com'
  OFFLINE_USER_PASSWORD = 'offline'

  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::Sha512
  end

  has_and_belongs_to_many :roles, :join_table => :rights
  has_many :race_rights
  has_many :races, :through => :race_rights
  has_and_belongs_to_many :cups, :join_table => :cup_officials

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :club_name, presence: true, on: :create
  validate :prevent_bot
  validate :only_one_user_in_offline_mode

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
  
  def official_for_cup?(cup)
    cups.each do |c|
      return true if c == cup
    end
    false
  end
  
  def has_full_rights_for_race?(race)
    race_right = race_rights.where(:race_id => race.id).first
    race_right and !race_right.only_add_competitors
  end

  def self.create_offline_user
    raise "Cannot create offline user unless offline mode" if Mode.online?
    offline_user = User.create!(:email => OFFLINE_USER_EMAIL,
      :password => OFFLINE_USER_PASSWORD,
      :password_confirmation => OFFLINE_USER_PASSWORD,
      :first_name => 'Offline', :last_name => 'Käyttäjä', club_name: 'Seura')
    offline_user.add_official_rights
    offline_user
  end

  def relevant_attributes
    attributes.except('crypted_password', 'password_salt', 'persistence_token', 'single_access_token', 'perishable_token')
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

  def prevent_bot
    errors.add :base, 'Odottamaton virhe' if first_name == last_name || first_name == club_name || last_name == club_name
  end

  def only_one_user_in_offline_mode
    if Mode.offline? and User.count == 1
      errors.add(:base, 'Offline-tilassa voi olla vain yksi käyttäjä')
    end
  end
end
