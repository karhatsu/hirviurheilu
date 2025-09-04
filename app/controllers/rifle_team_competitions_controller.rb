class RifleTeamCompetitionsController < TeamCompetitionsController
  before_action :set_races, :assign_race_by_race_id, :assign_team_competition_by_id

  def show
    unless @tc.sport.european?
      @id = @tc.id
      return render 'errors/team_competition_not_found', status: 404
    end
    @rifle_team = true
    @results = @tc.rifle_results
    render_page
  end
end
