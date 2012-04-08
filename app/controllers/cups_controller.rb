class CupsController < ApplicationController
  def show
    @is_cup = true
    @is_cup_main = true
    @cup = Cup.find(params[:id])
  end
end