class OfflineDownloadMailer < ApplicationMailer
  def download(user)
    @user = user
    mail :to => ADMIN_EMAIL, :from => NOREPLY_ADDRESS, :subject => 'Hirviurheilu Offline ladattu'
  end
end