class NewCompetitionMailer < ApplicationMailer
  add_template_helper ApplicationHelper
  add_template_helper TimeFormatHelper

  def new_race(race, user)
    set_locale
    @race = race
    @user = user
    mail :to => ADMIN_EMAIL, :from => NOREPLY_ADDRESS,
      :subject => "Hirviurheilu - uusi kilpailu (#{Rails.env})"
  end
  
  def new_cup(cup, user)
    set_locale
    @cup = cup
    @user = user
    mail :to => ADMIN_EMAIL, :from => NOREPLY_ADDRESS,
      :subject => "Hirviurheilu - uusi cup-kilpailu (#{Rails.env})"
  end
end
