class FeedbackMailer < ApplicationMailer
  helper :time_format

  def feedback_mail(comment, name, email, tel, current_user)
    @comment = comment
    @current_user = current_user
    @name = name
    @email = email
    @tel = tel
    mail :to => ADMIN_EMAIL, :from => from_address(email), :subject => 'Hirviurheilu - palaute'
  end

  def race_feedback_mail(race, comment, name, email, tel, current_user)
    @race = race
    @comment = comment
    @current_user = current_user
    @name = name
    @email = email
    @tel = tel
    mail to: race.race_rights.where(primary: true).first.user.email, bcc: ADMIN_EMAIL, from: from_address(email),
         subject: 'Hirviurheilu - palaute'
  end

  private

  def from_address(email)
    email.blank? ? NOREPLY_ADDRESS : email
  end
end
