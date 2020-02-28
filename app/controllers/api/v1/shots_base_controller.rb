class Api::V1::ShotsBaseController < Api::V1::ApiBaseController
  private

  def find_and_validate_race
    @race = Race.where(id: params[:race_id]).first
    return return_error 404, 'race not found' unless @race
    return_error 401 if @race.api_secret != request.env['HTTP_X_API_SECRET']
  end

  def validate_shot_value
    @shot_value = params[:value]
    return_error 400, 'invalid shot value' if Competitor.invalid_shot? @shot_value, @race.sport.max_shot
  end

  def find_and_validate_competitor
    @competitor = @race.competitors.where(number: params[:competitor_number]).first
    return_error 404, 'competitor not found' unless @competitor
  end

  def build_shots(current_shots)
    shots = current_shots || []
    shots[@shot_number - 1] = @shot_value
    shots.map {|shot| shot || 0 }
  end

  def return_error(status, error_message = nil)
    return render status: status, json: { error: error_message } if error_message
    render status: status, body: nil
  end
end
