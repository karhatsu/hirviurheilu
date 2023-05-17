class FeedbackMailer < ApplicationMailer
  helper :time_format

  def feedback_mail(comment, name, email, tel, current_user)
    @comment = comment
    @current_user = current_user
    @name = name
    @email = email
    @tel = tel
    mail to: ADMIN_EMAIL, from: NOREPLY_ADDRESS, reply_to: reply_to(email), subject: 'Hirviurheilu - palaute'
  end

  def race_feedback_mail(race, comment, name, email, tel, current_user)
    @race = race
    @comment = comment
    @current_user = current_user
    @name = name
    @email = email
    @tel = tel
    official = race.race_rights.where(primary: true).first&.user || race.race_rights.first.user
    mail to: official.email, bcc: ADMIN_EMAIL, from: NOREPLY_ADDRESS, reply_to: reply_to(email), subject: 'Hirviurheilu - palaute'
  end

  private

  def reply_to(email)
    email.blank? ? nil : email
  end
end
