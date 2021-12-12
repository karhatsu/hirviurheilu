class ImportMultipleRacesMailer < ApplicationMailer
  helper :application, :time_format

  def races_assigned_to_existing_user(by_user, to_user, races)
    @by_user = by_user
    @to_user = to_user
    @races = races
    mail to: to_user.email, from: NOREPLY_ADDRESS, subject: "Hirviurheilu - Sinulle on lisätty kilpailuja"
  end

  def races_assigned_to_new_user(by_user, email, races)
    @by_user = by_user
    @email = email
    @races = races
    mail to: email, from: NOREPLY_ADDRESS, subject: "Hirviurheilu - Sinulle on lisätty kilpailuja"
  end
end
