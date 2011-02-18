require 'digest/md5'

class ActivationKey < ActiveRecord::Base
  validates :comment, :presence => true

  def self.valid?(email, password, activation_key)
    digest = Digest::MD5.hexdigest(email + password)
    digest[22,32].upcase == activation_key.upcase
  end

  def self.activated?
    Mode.online? or ActivationKey.count > 0
  end
end
