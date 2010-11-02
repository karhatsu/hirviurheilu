class FeedbackMailer < ActionMailer::Base
  def feedback_mail(comment, name, email, tel)
    @comment = comment
    @name = name
    @email = email
    @tel = tel
    mail :to => ADMIN_EMAIL, :from => '<noreply@hirviurheilu.com>',
      :subject => 'Hirviurheilu - palaute'
  end
end
