class Api::V1::RacesController < Api::V1::ApiBaseController
  def show
    return render status: 404, body: nil unless race
    render json: race, only: [:name, :location, :start_date, :end_date, :organizer],
           methods: [:short_start_time],
           include: {sport: {only: [:name]}}
  end

  private

  def race
    @race ||= Race.where(id: params[:id]).first
  end
end