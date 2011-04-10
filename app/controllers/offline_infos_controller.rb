class OfflineInfosController < ApplicationController
  before_filter :set_offline_info

  def comparison
    @is_offline_vs_online = true
  end

  def installation
    @is_offline_installation = true
    render :installation_staging if Rails.env == 'staging'
  end

  def price
    @is_offline_price = true
  end

  private
  def set_offline_info
    @is_offline_info = true
  end
end
