class CupTeamCompetitionsController < ApplicationController
  before_action :assign_cup, :assign_cup_team_competition_by_id

  def show
    @is_cup = true
    @is_cup_series = true
    use_react
    render layout: true, html: ''
  end

  private

  def assign_cup
    @id = params[:cup_id]
    @cup = Cup.where(id: @id).first #includes([:cup_series, races: [series: [competitors: [:age_group, :club, :series]]]]).first
    render 'errors/cup_not_found' unless @cup
  end
end
