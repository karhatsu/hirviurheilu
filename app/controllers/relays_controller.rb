class RelaysController < ApplicationController
  before_filter :assign_race_by_race_id, :assign_relay_by_id

  def show
    @is_relays = true
    @results = @relay.results
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "viesti-#{@relay.name}-tulokset", :layout => true
      end
    end
  end
end
