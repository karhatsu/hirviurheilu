class DownloadsController < ApplicationController
  before_filter :require_user
  
  def installer
    redirect_to 'http://www.karhatsu.com/hirviurheilu/hirviurheilu.zip'
  end
  
  def upgrader
    redirect_to 'http://www.karhatsu.com/hirviurheilu/hirviurheilu.zip'
  end
end