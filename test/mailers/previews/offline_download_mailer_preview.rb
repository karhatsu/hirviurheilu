class OfflineDownloadMailerPreview < ActionMailer::Preview
  def download
    OfflineDownloadMailer.download User.last
  end
end