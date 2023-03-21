class Official::MegalinkImportsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def index
    use_react true
    render layout: true, html: ''
  end
end
