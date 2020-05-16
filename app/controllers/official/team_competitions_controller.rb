class Official::TeamCompetitionsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :set_team_competitions
  before_action :assign_team_competition_by_id, :only => [:edit, :update, :destroy]

  def index
  end

  def new
    @tc = @race.team_competitions.build
  end

  def create
    @tc = @race.team_competitions.build(team_competition_params)
    if @tc.save
      flash[:success] = t('official.team_competitions.create.team_competition_created')
      redirect_to official_race_team_competitions_path(@race)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @tc.attributes = team_competition_params
    set_extra_shots
    if @tc.save
      @tc.series.delete_all if params[:team_competition][:series_ids].blank?
      @tc.age_groups.delete_all if params[:team_competition][:age_group_ids].blank?
      flash[:success] = t('official.team_competitions.update.team_competition_updated')
      redirect_to official_race_team_competitions_path(@race)
    else
      render :edit
    end
  end

  def destroy
    @tc.destroy
    flash[:success] = t('official.team_competitions.destroy.team_competition_removed')
    redirect_to official_race_team_competitions_path(@race)
  end

  private
  def set_team_competitions
    @is_team_competitions = true
  end

  def team_competition_params
    params.require(:team_competition).permit(:name, :team_competitor_count, :multiple_teams, :use_team_name,
                                             :national_record, series_ids: [], age_group_ids: [])
  end

  def set_extra_shots
    return if params[:extra_shots_club_id].blank?
    club_ids = params[:extra_shots_club_id].map(&:to_i)
    @tc.extra_shots = []
    club_ids.each_with_index do |club_id, i|
      if club_id > 0
        shots1 = convert_shots params[:extra_shots1][i]
        shots2 = convert_shots params[:extra_shots2][i]
        @tc.extra_shots << { club_id: club_id, shots1: shots1, shots2: shots2 }
      end
    end
  end

  def convert_shots(shots_field)
    shots_field.split(',').map(&:strip).map(&:to_i)
  end
end
