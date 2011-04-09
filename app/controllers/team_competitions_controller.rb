class TeamCompetitionsController < ApplicationController
  before_filter :assign_race_by_race_id, :assign_team_competition_by_id

  def show
    @is_team_results = true
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "joukkuekilpailu-#{@tc.name}-tulokset", :layout => true
      end
    end
  end
end
