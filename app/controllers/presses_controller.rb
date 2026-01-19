class PressesController < ApplicationController
  def show
    use_react
    render layout: true, html: ''
  end
end
