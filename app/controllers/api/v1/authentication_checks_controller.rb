class Api::V1::AuthenticationChecksController < Api::V1::ApiBaseController
  before_action :find_and_validate_race

  def show
    render json: { race: @race.name }
  end
end
