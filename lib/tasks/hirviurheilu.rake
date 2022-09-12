namespace :hirviurheilu do
  task unfinished_race_reminder_job: :environment do
    UnfinishedRaceReminderJob.send_emails
  end
end
