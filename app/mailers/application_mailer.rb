class ApplicationMailer < ActionMailer::Base
  NOREPLY_ADDRESS = '<noreply@hirviurheilu.com>'
  
  private
  def set_locale
    @locale = I18n.locale == I18n.default_locale ? nil : I18n.locale
  end
end