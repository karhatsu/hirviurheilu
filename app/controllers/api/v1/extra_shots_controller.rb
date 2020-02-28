class Api::V1::ExtraShotsController < Api::V1::ShotsBaseController
  before_action :find_and_validate_race, :validate_shot_value, :validate_shot_number, :find_and_validate_competitor

  def update
    shots = build_shots @competitor.extra_shots
    @competitor.extra_shots = shots
    @competitor.save!
    render status: 200, json: { shots: shots }
  end

  private

  def validate_shot_number
    @shot_number = params[:shot_number].to_i
    return_error 400, 'invalid shot number' if @shot_number == 0
  end
end
