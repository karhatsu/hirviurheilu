class FinishRaceMailer < ApplicationMailer
  helper :application
  helper :time_format

  def finish_race(race)
    set_locale
    @race = race
    mail to: ADMIN_EMAIL, from: NOREPLY_ADDRESS, subject: "Hirviurheilu - kilpailu päättynyt (#{ProductionEnvironment.name})"
  end
end
