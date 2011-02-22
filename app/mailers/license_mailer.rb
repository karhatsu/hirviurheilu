class LicenseMailer < ActionMailer::Base
  def license_mail(user)
    @user = user
    mail :to => ADMIN_EMAIL, :from => 'Hirviurheilu <noreply@hirviurheilu.com>',
      :subject => "Hirviurheilu - aktivointitunnus katsottu"
  end
end