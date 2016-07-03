class InviteOfficialMailerPreview < ActionMailer::Preview
  def invite
    InviteOfficialMailer.invite Race.last, User.first, User.last, 'http://www.hirviurheilu.com/official/races/123'
  end

  def invite_only_competitor_adding
    InviteOfficialMailer.invite_only_competitor_adding Race.last, User.first, User.last,
                                                       'http://www.hirviurheilu.com/official/races/123'
  end
end