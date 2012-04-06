class NewCompetitionMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  def new_race(race, user)
    @race = race
    @user = user
    mail :to => ADMIN_EMAIL, :from => '<noreply@hirviurheilu.com>',
      :subject => "Hirviurheilu - uusi kilpailu (#{Rails.env})"
  end
  
  def new_cup(cup, user)
    @cup = cup
    @user = user
    mail :to => ADMIN_EMAIL, :from => '<noreply@hirviurheilu.com>',
      :subject => "Hirviurheilu - uusi cup-kilpailu (#{Rails.env})"
  end
end
