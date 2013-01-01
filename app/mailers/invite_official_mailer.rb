# encoding: UTF-8
class InviteOfficialMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  def invite(race, inviter, invitee, url)
    @race = race
    @inviter = inviter
    @invitee = invitee
    @url = url
    mail :to => invitee.email, :from => 'Hirviurheilu <noreply@hirviurheilu.com>',
      :subject => "Kutsu kilpailun #{race.name} toimitsijaksi"
  end
  
  def invite_only_competitor_adding(race, inviter, invitee, url)
    @race = race
    @inviter = inviter
    @invitee = invitee
    @url = url
    mail :to => invitee.email, :from => 'Hirviurheilu <noreply@hirviurheilu.com>',
      :subject => "Kilpailun #{race.name} kilpailijoiden lisäyspyyntö"
  end
end
