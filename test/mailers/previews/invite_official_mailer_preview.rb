class InviteOfficialMailerPreview < ActionMailer::Preview
  def invite
    InviteOfficialMailer.invite Race.last, User.first, User.last
  end

  def invite_only_competitor_adding
    InviteOfficialMailer.invite_only_competitor_adding Race.last, User.first, User.last
  end
end