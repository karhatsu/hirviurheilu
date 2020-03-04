class Api::V2::Official::OfficialApiBaseController < Api::V2::ApiBaseController
  private

  def find_and_validate_race
    @race = Race.where(id: params[:race_id]).first
    return return_error 404, 'race not found' unless @race
    return return_error(500, 'race has no API secret') if @race.api_secret.blank?
    return_error 401 if @race.api_secret != request.env['HTTP_AUTHORIZATION']
  end

  def return_error(status, error_message = nil)
    return render status: status, json: { errors: [error_message] } if error_message
    render status: status, body: nil
  end
end
