class HomeController < ApplicationController
  def show
    @is_main_page = true
    @past = Race.past
    @ongoing = Race.ongoing
    @future = Race.future
  end
end
