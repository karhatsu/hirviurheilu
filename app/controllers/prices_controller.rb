class PricesController < ApplicationController
  before_action :set_variant

  def index
    @is_prices = true
  end
end
