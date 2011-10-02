# encoding: UTF-8
class NewUserMailer < ActionMailer::Base
  def new_user(user)
    @user = user
    mail :to => ADMIN_EMAIL, :from => 'Hirviurheilu <noreply@hirviurheilu.com>',
      :subject => "Hirviurheilu - uusi käyttäjä (#{Rails.env})"
  end
end
