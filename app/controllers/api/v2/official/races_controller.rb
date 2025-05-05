class Api::V2::Official::RacesController < Api::V2::Official::OfficialApiBaseController
  def show
    @race = Race.where(id: params[:id]).includes(series: [:race, :age_groups, competitors: [:club, series: [:race]]]).first
    return render status: 404, body: nil unless @race
    @official = true
    render 'api/v2/public/races/show'
  end
end
