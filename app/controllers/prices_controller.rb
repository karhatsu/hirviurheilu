class PricesController < ApplicationController
  skip_before_filter :set_competitions

  def index
    @is_prices = true
    @prices = Price.all
    @default_competitors_count = 50
    @price = Price.price_for_competitor_amount(@default_competitors_count)
  end

  def calculate_price
    @price = Price.price_for_competitor_amount(params[:competitors].to_i)
    respond_to do |format|
      format.js { render :calculated }
      format.html { redirect_to prices_path }
    end
  end
end
