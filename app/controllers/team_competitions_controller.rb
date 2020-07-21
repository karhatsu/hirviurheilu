class TeamCompetitionsController < ApplicationController
  before_action :set_races, :assign_race_by_race_id, :assign_team_competition_by_id

  def show
    @rifle_team = false
    @is_team_results = true
    @results = @tc.results
    render_page
  end

  private

  def render_page
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "joukkuekilpailu-#{@tc.name}-tulokset", :layout => true,
               :margin => pdf_margin, :header => pdf_header("#{t 'activerecord.models.team_competition.one'} - #{@tc.name}"),
               :footer => pdf_footer, :orientation => 'Landscape', disable_smart_shrinking: true
      end
    end
  end
end
