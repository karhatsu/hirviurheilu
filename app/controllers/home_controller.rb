class HomeController < ApplicationController
  def show
    use_react
    @is_main_page = true
    render layout: true, html: ''
  end
end
