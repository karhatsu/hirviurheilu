# encoding: UTF-8
class InviteOfficialMailer < ApplicationMailer
  add_template_helper ApplicationHelper

  def invite(race, inviter, invitee, url)
    @race = race
    @inviter = inviter
    @invitee = invitee
    @url = url
    mail :to => invitee.email, :from => NOREPLY_ADDRESS,
      :subject => "Kutsu kilpailun #{race.name} toimitsijaksi"
  end
  
  def invite_only_competitor_adding(race, inviter, invitee, url)
    @race = race
    @inviter = inviter
    @invitee = invitee
    @url = url
    mail :to => invitee.email, :from => NOREPLY_ADDRESS,
      :subject => "Kilpailun #{race.name} kilpailijoiden lisäyspyyntö"
  end
end
