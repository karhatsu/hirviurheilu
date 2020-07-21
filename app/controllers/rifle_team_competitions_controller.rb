class RifleTeamCompetitionsController < TeamCompetitionsController
  before_action :set_races, :assign_race_by_race_id, :assign_team_competition_by_id

  def show
    @rifle_team = true
    @results = @tc.rifle_results
    render_page
  end
end
