class Api::V2::Public::CupTeamCompetitionsController < Api::V2::ApiBaseController
  def show
    @cup = Cup.where(id: params[:cup_id]).includes([:cup_team_competitions, races: :team_competitions]).first
    @cup_team_competition = CupTeamCompetition.where(id: params[:id]).includes(cup: [races: [team_competitions: [:race, series: [:race, competitors: [:club, :age_group, :series]]]]]).first
    render status: 404, body: nil unless @cup_team_competition
  end
end
