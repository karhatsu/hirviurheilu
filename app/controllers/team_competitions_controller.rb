class TeamCompetitionsController < ApplicationController
  before_filter :assign_race_by_race_id

  def show
    @tc = TeamCompetition.find(params[:id])
    @is_team_results = true
  end
end
