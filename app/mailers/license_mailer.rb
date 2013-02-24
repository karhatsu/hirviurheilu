class LicenseMailer < ApplicationMailer
  def license_mail(user)
    @user = user
    mail :to => ADMIN_EMAIL, :from => NOREPLY_ADDRESS,
      :subject => "Hirviurheilu - aktivointitunnus katsottu"
  end
end