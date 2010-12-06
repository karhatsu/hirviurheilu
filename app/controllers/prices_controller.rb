class PricesController < ApplicationController
  skip_before_filter :set_competitions

  def index
    @is_prices = true
    @prices = Price.all
  end
end
