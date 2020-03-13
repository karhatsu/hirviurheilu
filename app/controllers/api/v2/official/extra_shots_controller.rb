class Api::V2::Official::ExtraShotsController < Api::V2::Official::ShotsBaseController
  before_action :find_and_validate_race, :find_and_validate_competitor
  before_action :validate_shot_value, :validate_shot_number, only: :update

  def update
    shots = build_shots @competitor.extra_shots
    @competitor.extra_shots = shots
    @competitor.save!
    render status: 200, json: { shots: shots }
  end

  def update_all
    return render status: 400, json: { errors: ['shots missing from request body'] } unless params[:shots]
    return render status: 400, json: { errors: ['invalid shots value'] } unless params[:shots].is_a?(Array)
    @competitor.extra_shots = params[:shots]
    if @competitor.save
      render status: 200, json: { shots: @competitor.extra_shots }
    else
      render status: 400, json: { errors: @competitor.errors.full_messages }
    end
  end

  private

  def validate_shot_number
    @shot_number = params[:shot_number].to_i
    return_error 400, 'invalid shot number' if @shot_number == 0
  end
end
