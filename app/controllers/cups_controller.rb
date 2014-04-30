class CupsController < ApplicationController
  before_action :set_variant

  def show
    @is_cup = true
    @is_cup_main = true
    @cup = Cup.find(params[:id])
  end
end