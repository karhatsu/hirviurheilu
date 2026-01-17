class PressesController < ApplicationController
  def show
    return head :not_acceptable unless request.format.html?
    use_react
    render layout: true, html: ''
  end
end
