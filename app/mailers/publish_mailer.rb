class PublishMailer < ActionMailer::Base
  def publish_mail(race, user)
    @race = race
    @user = user
    mail :to => ADMIN_EMAIL, :from => '<noreply@hirviurheilu.com>',
      :subject => "Hirviurheilu - kilpailu julkaistu (#{Rails.env})"
  end
end
