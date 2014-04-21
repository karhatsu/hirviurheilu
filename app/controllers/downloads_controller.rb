class DownloadsController < ApplicationController
  before_action :require_user, :check_staging
  
  def installer
    OfflineDownloadMailer.download(current_user).deliver
    redirect_to 'http://www.karhatsu.com/hirviurheilu/HirviurheiluOffline-asennus.exe'
  end
  
  private
  def check_staging
    redirect_to root_path if Rails.env.staging?
  end
end