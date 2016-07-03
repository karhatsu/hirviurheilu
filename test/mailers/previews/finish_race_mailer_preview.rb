class FinishRaceMailerPreview < ActionMailer::Preview
  def finish_race
    FinishRaceMailer.finish_race Race.last
  end
end