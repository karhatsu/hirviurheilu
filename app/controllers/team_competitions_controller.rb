class TeamCompetitionsController < ApplicationController
  before_action :set_races, :assign_race_by_race_id, :assign_team_competition_by_id, :set_variant

  def show
    @is_team_results = true
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "joukkuekilpailu-#{@tc.name}-tulokset", :layout => true,
          :margin => pdf_margin, :header => pdf_header("#{t 'activerecord.models.team_competition.one'} - #{@tc.name}"),
          :footer => pdf_footer, :orientation => 'Landscape'
      end
    end
  end
end
