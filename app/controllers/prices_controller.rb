class PricesController < ApplicationController
  def index
    use_react
    @is_info = true
    @is_prices = true
    render layout: true, html: ''
  end
end
