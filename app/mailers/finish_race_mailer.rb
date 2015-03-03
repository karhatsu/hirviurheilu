class FinishRaceMailer < ApplicationMailer
  add_template_helper ApplicationHelper
  add_template_helper TimeFormatHelper

  def finish_race(race)
    set_locale
    @race = race
    mail :to => ADMIN_EMAIL, :from => NOREPLY_ADDRESS, :reply_to => race.users.first.email,
      :subject => "Hirviurheilu - kilpailu päättynyt (#{Rails.env})"
  end
end
