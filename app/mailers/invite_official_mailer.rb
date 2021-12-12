class InviteOfficialMailer < ApplicationMailer
  helper :application
  helper :time_format

  def invite(race, inviter, invitee)
    @race = race
    @inviter = inviter
    @invitee = invitee
    @locale = set_locale
    mail :to => invitee.email, :from => NOREPLY_ADDRESS,
      :subject => "Hirviurheilu - kutsu kilpailun #{race.name} toimitsijaksi"
  end

  def invite_only_competitor_adding(race, inviter, invitee)
    @race = race
    @inviter = inviter
    @invitee = invitee
    @locale = set_locale
    mail :to => invitee.email, :from => NOREPLY_ADDRESS,
      :subject => "Hirviurheilu - kilpailun #{race.name} kilpailijoiden lisäyspyyntö"
  end
end
