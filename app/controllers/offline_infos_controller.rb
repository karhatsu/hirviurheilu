class OfflineInfosController < ApplicationController
  skip_before_filter :set_competitions
  before_filter :check_staging, :set_offline_info

  def comparison
    @is_offline_vs_online = true
  end

  def installation
    @is_offline_installation = true
  end

  def price
    @is_offline_price = true
  end

  private
  def check_staging
    redirect_to root_path if Rails.env == 'staging'
  end

  def set_offline_info
    @is_offline_info = true
  end
end
