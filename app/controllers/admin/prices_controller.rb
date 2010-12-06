class Admin::PricesController < Admin::AdminController
  before_filter :set_admin_prices

  active_scaffold :price

  private
  def set_admin_prices
    @is_admin_prices = true
  end
end
