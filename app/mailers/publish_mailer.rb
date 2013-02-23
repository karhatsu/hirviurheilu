class PublishMailer < ApplicationMailer
  def publish_mail(race, user)
    set_locale
    @race = race
    @user = user
    mail :to => ADMIN_EMAIL, :from => NOREPLY_ADDRESS,
      :subject => "Hirviurheilu - kilpailu julkaistu (#{Rails.env})"
  end
end
