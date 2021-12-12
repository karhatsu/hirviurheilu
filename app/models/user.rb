class User < ApplicationRecord
  acts_as_authentic do |config|
    config.transition_from_crypto_providers = [Authlogic::CryptoProviders::Sha512]
    config.crypto_provider = Authlogic::CryptoProviders::SCrypt
  end

  has_and_belongs_to_many :roles, :join_table => :rights
  has_many :race_rights
  has_many :races, -> { order 'start_date DESC' }, through: :race_rights
  has_and_belongs_to_many :cups, :join_table => :cup_officials

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: :invalid },
            length: { maximum: 100 },
            uniqueness: { case_sensitive: false, if: :will_save_change_to_email? }
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, confirmation: true, length: { minimum: 8, if: :require_password? }
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :club_name, presence: true, on: :create
  validate :prevent_bot

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
end
