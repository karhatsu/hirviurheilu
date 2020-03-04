class Api::V2::Official::HealthsController < Api::V2::Official::OfficialApiBaseController
  before_action :find_and_validate_race

  def show
    render json: { race: @race.name }
  end
end
