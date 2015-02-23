class NewUserMailer < ApplicationMailer
  add_template_helper ApplicationHelper
  
  def new_user(user)
    @user = user
    mail :to => ADMIN_EMAIL, :from => NOREPLY_ADDRESS,
      :subject => "Hirviurheilu - uusi käyttäjä (#{Rails.env})"
  end
  
  def from_admin(user, url)
    @user = user
    @url = url
    mail :to => user.email, :from => NOREPLY_ADDRESS,
      :subject => "Tunnukset Hirviurheilu-palveluun"
  end
end
