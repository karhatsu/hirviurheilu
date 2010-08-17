class HomeController < ApplicationController
  def show
    @run = Sport.find_run
    @ski = Sport.find_ski
  end
end
