class PricesController < ApplicationController
  def index
    @is_prices = true
    @prices = Price.all
  end
end
