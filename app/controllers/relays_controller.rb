class RelaysController < ApplicationController
  before_action :set_races, :assign_race_by_race_id, :assign_relay_by_id, :set_variant

  def show
    @is_relays = true
    @results = @relay.results
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "viesti-#{@relay.name}-tulokset", :layout => true,
          :margin => pdf_margin, :header => pdf_header("#{t 'activerecord.models.relay.one'} - #{@relay.name}"),
          :footer => pdf_footer, orientation: 'Landscape', disable_smart_shrinking: true
      end
    end
  end
end
