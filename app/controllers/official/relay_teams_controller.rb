class Official::RelayTeamsController < Official::OfficialController
  before_filter :assign_relay_by_relay_id, :check_assigned_relay, :set_relays

  def index
  end
end
