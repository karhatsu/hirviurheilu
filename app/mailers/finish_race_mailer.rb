class FinishRaceMailer < ApplicationMailer
  helper :application
  helper :time_format

  def finish_race(race)
    set_locale
    @race = race
    mail to: ADMIN_EMAIL, from: NOREPLY_ADDRESS, subject: "Hirviurheilu - kilpailu päättynyt (#{ProductionEnvironment.name})"
  end

  def unfinished_race(race, official)
    set_locale
    @race = race
    @official = official
    mail to: official.email, from: NOREPLY_ADDRESS, subject: "Hirviurheilu - kilpailua ei ole päätetty"
  end
end
