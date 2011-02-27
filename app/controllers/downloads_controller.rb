class DownloadsController < ApplicationController
  before_filter :require_user, :check_staging
  
  def installer
    redirect_to 'http://www.karhatsu.com/hirviurheilu/hirviurheilu-asennus.zip'
  end
  
  def upgrader
    redirect_to 'http://www.karhatsu.com/hirviurheilu/hirviurheilu-paivitys.zip'
  end

  private
  def check_staging
    redirect_to root_path if Rails.env == 'staging'
  end
end