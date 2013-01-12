# encoding: UTF-8
class NewUserMailer < ActionMailer::Base
  add_template_helper ApplicationHelper
  
  def new_user(user)
    @user = user
    mail :to => ADMIN_EMAIL, :from => 'Hirviurheilu <noreply@hirviurheilu.com>',
      :subject => "Hirviurheilu - uusi käyttäjä (#{Rails.env})"
  end
  
  def from_admin(user, url)
    @user = user
    @url = url
    mail :to => user.email, :from => 'Hirviurheilu <noreply@hirviurheilu.com>',
      :subject => "Tunnukset Hirviurheilu-palveluun"
  end
end
