# encoding: UTF-8
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
    if @tc.update(team_competition_params)
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
    params.require(:team_competition).permit(:name, :team_competitor_count, :use_team_name, series_ids: [], age_group_ids: [])
  end
end
