class OfflineDownloadMailer < ActionMailer::Base
  def download(user)
    @user = user
    mail :to => ADMIN_EMAIL, :from => '<noreply@hirviurheilu.com>', :subject => 'Hirviurheilu Offline ladattu'
  end
end