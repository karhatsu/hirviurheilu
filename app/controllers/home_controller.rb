class HomeController < ApplicationController
  def show
    use_react
    @is_main_page = true
    respond_to do |format|
      format.html { render layout: true, html: '' }
      format.text { render status: 404, body: nil }
    end
  end
end
