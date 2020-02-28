class Api::V1::ShotsController < Api::V1::ApiBaseController
  def update
    race = Race.where(id: params[:race_id]).first
    return return_error 404, 'race not found' unless race
    return return_error 401 if race.api_secret != request.env['HTTP_X_API_SECRET']

    shot_number = params[:shot_number].to_i
    return return_error 400, 'invalid shot number' if shot_number == 0 || shot_number > race.sport.max_shots_count

    shot_value = params[:value]
    return return_error 400, 'invalid shot value' if Competitor.invalid_shot? shot_value, race.sport.max_shot

    competitor = race.competitors.where(number: params[:competitor_number]).first
    return return_error 404, 'competitor not found' unless competitor

    shots = competitor.shots || []
    shots[shot_number - 1] = shot_value
    shots = shots.map {|shot| shot || 0 }
    competitor.shots = shots
    competitor.save!
    render status: 200, json: { shots: shots }
  end

  private

  def return_error(status, error_message = nil)
    return render status: status, json: { error: error_message } if error_message
    render status: status, body: nil
  end
end
