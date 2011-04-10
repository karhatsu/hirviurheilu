class PricesController < ApplicationController
  def index
    @is_prices = true
    @prices = Price.all
    @default_competitors_count = 50
    @price = price(@default_competitors_count)
  end

  def calculate_price
    @price = price(params[:competitors].to_i)
    respond_to do |format|
      format.js { render :calculated }
      format.html { redirect_to prices_path }
    end
  end

  private
  def price(competitors)
    Price.price_for_competitor_amount(competitors)
  end
end
