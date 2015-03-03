class FeedbackMailer < ApplicationMailer
  add_template_helper ApplicationHelper
  add_template_helper TimeFormatHelper

  def feedback_mail(comment, name, email, tel, current_user)
    @comment = comment
    @current_user = current_user
    @name = name
    @email = email
    @tel = tel
    from = email.blank? ? NOREPLY_ADDRESS : email
    mail :to => ADMIN_EMAIL, :from => from, :subject => 'Hirviurheilu - palaute'
  end

  def race_feedback_mail(race, comment, name, email, tel, current_user)
    @race = race
    @comment = comment
    @current_user = current_user
    @name = name
    @email = email
    @tel = tel
    from = email.blank? ? NOREPLY_ADDRESS : email
    mail to: race.race_rights.where(primary: true).first.user.email, bcc: ADMIN_EMAIL, from: from,
         subject: 'Hirviurheilu - palaute'
  end
end
