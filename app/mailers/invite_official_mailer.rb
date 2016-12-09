class InviteOfficialMailer < ApplicationMailer
  add_template_helper ApplicationHelper
  add_template_helper TimeFormatHelper

  def invite(race, inviter, invitee)
    @race = race
    @inviter = inviter
    @invitee = invitee
    @locale = set_locale
    mail :to => invitee.email, :from => NOREPLY_ADDRESS,
      :subject => "Kutsu kilpailun #{race.name} toimitsijaksi"
  end
  
  def invite_only_competitor_adding(race, inviter, invitee)
    @race = race
    @inviter = inviter
    @invitee = invitee
    @locale = set_locale
    mail :to => invitee.email, :from => NOREPLY_ADDRESS,
      :subject => "Kilpailun #{race.name} kilpailijoiden lisäyspyyntö"
  end
end
