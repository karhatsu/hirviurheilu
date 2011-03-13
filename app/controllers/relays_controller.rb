class RelaysController < ApplicationController
  before_filter :assign_race_by_race_id, :assign_relay_by_id

  def show
    @is_relays = true
    @results = @relay.results
  end
end
