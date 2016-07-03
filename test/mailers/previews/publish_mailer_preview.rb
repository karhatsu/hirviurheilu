class PublishMailerPreview < ActionMailer::Preview
  def publish_race
    PublishMailer.publish_mail Race.last, Race.last.users.first
  end
end