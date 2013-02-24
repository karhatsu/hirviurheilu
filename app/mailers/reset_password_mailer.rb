class ResetPasswordMailer < ApplicationMailer
  def reset_mail(email, reset_hash, site_url)
    @email = email
    @reset_hash = reset_hash
    @site_url = site_url
    mail :to => email, :from => NOREPLY_ADDRESS,
      :subject => 'Hirviurheilu - salasanan vaihto'
  end
end
