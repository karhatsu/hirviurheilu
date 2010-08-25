class HomeController < ApplicationController
  def show
    @past = Race.past
    @ongoing = Race.ongoing
    @future = Race.future
  end
end
