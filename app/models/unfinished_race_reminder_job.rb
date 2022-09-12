class UnfinishedRaceReminderJob
  def self.send_emails
    races = Race.where('finished=false and cancelled=false and series_count>0 and end_date=?', Date.yesterday)
    races.each do |race|
      FinishRaceMailer.unfinished_race(race, race.users.first).deliver_now
    end
  end
end
