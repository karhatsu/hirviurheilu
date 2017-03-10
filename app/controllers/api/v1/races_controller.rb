class Api::V1::RacesController < Api::V1::ApiBaseController
  def show
    return render status: 404, body: nil unless race
    render json: race, only: [:name, :location, :start_date, :end_date, :organizer],
           methods: [:short_start_time],
           include: {
               sport: {only: [:name]},
               series: {only: [:name], include: {
                   competitors: {
                       only: [:first_name, :last_name, :number], methods: [:start_datetime],
                       include: {
                           club: {only: [:name]}
                       }
                   }
               }}
           }
  end

  private

  def race
    @race ||= Race.where(id: params[:id]).includes(series: [:race, competitors: [:club, series: [:race]]]).first
  end
end