class Api::V1::TimesController < Api::V1::ApiBaseController
  def index
    race = Race.where(id: params[:race_id]).first
    return render status: 404, body: nil unless race
    render json: race.competitors,
           only: [:id, :number, :first_name, :last_name, :start_time, :shooting_start_time, :shooting_finish_time, :arrival_time]
  end
end
