class LegsController < ApplicationController
  before_action :set_races, :assign_relay_by_relay_id, :set_variant

  def show
    @is_relays = true
    @leg = params[:id]
    return redirect_to race_relay_path(@relay.race, @relay) if invalid_leg?
    render :show
  end

  private
  def invalid_leg?
    @leg.to_i <= 0 || @leg.to_i > @relay.legs_count
  end
end
