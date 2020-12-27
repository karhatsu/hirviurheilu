class NewUserMailer < ApplicationMailer
  helper :application

  def new_user(user)
    @user = user
    mail :to => ADMIN_EMAIL, :from => NOREPLY_ADDRESS,
      :subject => "Hirviurheilu - uusi käyttäjä (#{ProductionEnvironment.name})"
  end

  def from_admin(user)
    @user = user
    mail :to => user.email, :from => NOREPLY_ADDRESS,
      :subject => "Tunnukset Hirviurheilu-palveluun"
  end
end
