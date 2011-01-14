class TeamResultsController < ApplicationController
  before_filter :assign_race_by_race_id

  def index
    @is_team_results = true
  end
end
