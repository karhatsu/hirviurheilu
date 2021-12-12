class ImportMultipleRacesMailerPreview < ActionMailer::Preview
  def races_assigned_to_existing_user
    ImportMultipleRacesMailer.races_assigned_to_existing_user User.first, User.last, Race.last(3)
  end

  def races_assigned_to_new_user
    ImportMultipleRacesMailer.races_assigned_to_new_user User.first, 'new.user@test.com', Race.last(3)
  end
end
