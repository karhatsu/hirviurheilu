# encoding: UTF-8
class FinishRaceMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  def finish_race(race)
    @race = race
    mail :to => ADMIN_EMAIL, :from => '<noreply@hirviurheilu.com>',
      :subject => "Hirviurheilu - kilpailu päättynyt (#{Rails.env})"
  end
end
