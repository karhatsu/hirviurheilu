class CupsController < ApplicationController
  before_action :assign_cup_by_id, :set_variant

  def show
    @is_cup = true
    @is_cup_main = true
  end
end