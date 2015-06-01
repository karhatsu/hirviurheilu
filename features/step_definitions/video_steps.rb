Given /^the admin has defined video source "(.*?)" with description "(.*?)" for the race$/ do |source, description|
  @race.video_source = source
  @race.video_description = description
  @race.save!
end
