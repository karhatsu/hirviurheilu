class LegsController < ApplicationController
  before_filter :assign_relay_by_relay_id

  def show
    @leg = params[:id]
    redirect_to race_relay_path(@relay.race, @relay) if invalid_leg?
    @results = @relay.leg_results(@leg)
    render 'relays/show'
  end

  private
  def invalid_leg?
    @leg.to_i <= 0 || @leg.to_i > @relay.legs_count
  end
end
