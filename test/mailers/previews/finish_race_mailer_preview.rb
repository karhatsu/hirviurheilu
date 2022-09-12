class FinishRaceMailerPreview < ActionMailer::Preview
  def finish_race
    FinishRaceMailer.finish_race Race.last
  end

  def unfinished_race
    race = Race.where('finished=false and cancelled=false and series_count > 0 and start_date < ?', Date.yesterday).order('start_date desc').first
    FinishRaceMailer.unfinished_race race, race.users.last
  end
end
