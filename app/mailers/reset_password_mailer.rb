class ResetPasswordMailer < ApplicationMailer
  def reset_mail(email, reset_hash)
    @email = email
    @reset_hash = reset_hash
    mail :to => email, :from => NOREPLY_ADDRESS,
      :subject => 'Hirviurheilu - salasanan vaihto'
  end
end
