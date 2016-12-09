class NewUserMailerPreview < ActionMailer::Preview
  def new_user
    NewUserMailer.new_user User.last
  end

  def from_admin
    NewUserMailer.from_admin User.last
  end
end