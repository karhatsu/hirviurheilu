class LicenseMailerPreview < ActionMailer::Preview
  def license_mail
    LicenseMailer.license_mail User.where('activation_key is not null').last
  end
end