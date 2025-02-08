class ApplicationMailer < ActionMailer::Base
  NOREPLY_ADDRESS = ENV['NO_REPLY_EMAIL'] || 'noreply@hirviurheilu.com'

  layout 'email'

  private
  def set_locale
    @locale = I18n.locale == I18n.default_locale ? nil : I18n.locale
  end
end
