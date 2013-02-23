# encoding: UTF-8
class FinishRaceMailer < ApplicationMailer
  add_template_helper ApplicationHelper

  def finish_race(race)
    set_locale
    @race = race
    mail :to => ADMIN_EMAIL, :from => NOREPLY_ADDRESS,
      :subject => "Hirviurheilu - kilpailu päättynyt (#{Rails.env})"
  end
end
