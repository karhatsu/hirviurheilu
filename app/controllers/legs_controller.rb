class LegsController < ApplicationController
  before_action :set_races, :assign_relay_by_relay_id

  def show
    @is_relays = true
    @leg = params[:id]
    return redirect_to race_relay_path(@relay.race, @relay) if invalid_leg?
    return redirect_to(race_relay_leg_path(@relay.race, @relay, @leg), status: 301) unless params[:race_id]
    use_react
    render layout: true, html: ''
  end

  private
  def invalid_leg?
    @leg.to_i <= 0 || @leg.to_i > @relay.legs_count
  end
end
