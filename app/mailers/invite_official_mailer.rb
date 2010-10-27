class InviteOfficialMailer < ActionMailer::Base
  def invite(race, inviter, invitee, url)
    @race = race
    @inviter = inviter
    @invitee = invitee
    @url = url
    mail :to => invitee.email, :from => 'Hirviurheilu <noreply@hirviurheilu.com>',
      :subject => "Kutsu kilpailun #{race.name} toimitsijaksi"
  end
end
