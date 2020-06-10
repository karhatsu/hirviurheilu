class EuropeanRiflesController < ApplicationController
  before_action :assign_series_by_series_id, :set_races

  def index
    @rifle = true
  end
end
