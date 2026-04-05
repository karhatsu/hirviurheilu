class Official::TeamCompetitionsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :set_team_competitions
  before_action :assign_team_competition_by_id, only: [:update, :destroy]

  def index
    respond_to do |format|
      format.html do
        use_react true
        render layout: true, html: ''
      end
      format.json do
        @team_competitions = @race.team_competitions.includes(:series, :age_groups)
      end
    end
  end

  def create
    @tc = @race.team_competitions.build(team_competition_params)
    unless @tc.save
      render status: 400, json: { errors: @tc.errors.full_messages }
    end
  end

  def update
    @tc.attributes = team_competition_params
    set_extra_shots
    if @tc.save
      @tc.series.delete_all if params[:team_competition][:series_ids].blank?
      @tc.age_groups.delete_all if params[:team_competition][:age_group_ids].blank?
      @tc.touch unless @tc.changed?
    else
      render status: 400, json: { errors: @tc.errors.full_messages }
    end
  end

  def destroy
    @club = Club.find(params[:id])
    if @tc.destroy
      render status: 201, body: nil
    else
      render status: 400, json: { errors: @tc.errors.full_messages }
    end
  end

  private
  def set_team_competitions
    @is_team_competitions = true
  end

  def team_competition_params
    params.require(:team_competition).permit(
      :name,
      :team_competitor_count,
      :multiple_teams,
      :show_partial_teams,
      :use_team_name,
      :national_record,
      series_ids: [],
      age_group_ids: []
    )
  end

  def set_extra_shots
    return if params[:extra_shots].blank?
    @tc.extra_shots = []
    params[:extra_shots].each do |extra_shots|
      shots1 = convert_shots extra_shots[:shots1]
      shots2 = convert_shots extra_shots[:shots2]
      score1 = extra_shots[:score1]
      score2 = extra_shots[:score2]
      if shots1.present? || shots2.present?
        @tc.extra_shots << { "club_id" => extra_shots[:club_id].to_i, "shots1" => shots1, "shots2" => shots2 }
      elsif score1.present? || score2.present?
        @tc.extra_shots << { "club_id" => extra_shots[:club_id].to_i, "score1" => score1.to_i, "score2" => score2.to_i }
      end
    end
  end

  def convert_shots(shots_field)
    return [] if shots_field.blank?
    shots_field.split(',').map(&:strip).map(&:to_i)
  end
end
