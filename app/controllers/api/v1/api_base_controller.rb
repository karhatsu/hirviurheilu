class Api::V1::ApiBaseController < ApplicationController
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }

  private

  def find_and_validate_race
    @race = Race.where(id: params[:race_id]).first
    return return_error 404, 'race not found' unless @race
    return_error 401 if @race.api_secret != request.env['HTTP_X_API_SECRET']
  end

  def return_error(status, error_message = nil)
    return render status: status, json: { error: error_message } if error_message
    render status: status, body: nil
  end
end
