class Api::V2::Official::ShotsBaseController < Api::V2::Official::OfficialApiBaseController
  private

  def validate_shot_value
    @shot_value = params[:value]
    return_error 400, 'invalid shot value' if Competitor.invalid_shot? @shot_value, @race.sport.best_shot_value
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
end
