class FeedbackMailer < ApplicationMailer
  def feedback_mail(comment, name, email, tel, current_user)
    @comment = comment
    @current_user = current_user
    @name = name
    @email = email
    @tel = tel
    from = email.blank? ? NOREPLY_ADDRESS : email
    mail :to => ADMIN_EMAIL, :from => from, :subject => 'Hirviurheilu - palaute'
  end
end
