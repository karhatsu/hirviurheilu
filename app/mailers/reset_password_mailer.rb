class ResetPasswordMailer < ActionMailer::Base
  def reset_mail(email, reset_hash, site_url)
    @email = email
    @reset_hash = reset_hash
    @site_url = site_url
    mail :to => email, :from => 'Hirviurheilu <noreply@hirviurheilu.com>',
      :subject => 'Hirviurheilu - salasanan vaihto'
  end
end
