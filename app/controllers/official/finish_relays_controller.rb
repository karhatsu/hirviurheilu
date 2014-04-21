# encoding: UTF-8
class Official::FinishRelaysController < Official::OfficialController
  before_action :assign_relay_by_relay_id, :check_assigned_relay, :set_relays

  def new
  end

  def create
    if @relay.finish
      flash[:success] = "Viesti '#{@relay.name}' merkitty päättyneeksi"
      redirect_to official_race_relays_path(@relay.race)
    else
      render :new
    end
  end
end
