class NewCompetitionMailerPreview < ActionMailer::Preview
  def new_race
    NewCompetitionMailer.new_race Race.last, Race.last.users.first
  end

  def new_cup
    NewCompetitionMailer.new_cup Cup.last, Race.last.users.first
  end
end