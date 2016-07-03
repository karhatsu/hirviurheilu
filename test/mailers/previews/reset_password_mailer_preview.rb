class ResetPasswordMailerPreview < ActionMailer::Preview
  def reset_mail
    ResetPasswordMailer.reset_mail 'customer@test.com', 'abd123efg5678cc', 'http://www.hirviurheilu.com'
  end
end