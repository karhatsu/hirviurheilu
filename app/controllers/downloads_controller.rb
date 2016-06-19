class DownloadsController < ApplicationController
  OFFLINE_VERSION = '1.8.0'

  before_action :require_user, :check_staging
  
  def installer
    OfflineDownloadMailer.download(current_user).deliver_now
    redirect_to "http://www.karhatsu.com/hirviurheilu/HirviurheiluOffline-asennus-#{OFFLINE_VERSION}.exe"
  end
  
  private
  def check_staging
    redirect_to root_path if ProductionEnvironment.staging?
  end
end