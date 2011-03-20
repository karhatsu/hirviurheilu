class Official::TeamCompetitionsController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race, :set_team_competitions
  before_filter :assign_team_competition_by_id, :only => [:edit, :update]

  def index
  end

  def new
    @tc = @race.team_competitions.build
  end

  def create
    @tc = @race.team_competitions.build(params[:team_competition])
    if @tc.save
      flash[:success] = 'Joukkuekilpailu luotu'
      redirect_to official_race_team_competitions_path(@race)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tc.update_attributes(params[:team_competition])
      flash[:success] = 'Joukkuekilpailun tiedot päivitetty'
      redirect_to official_race_team_competitions_path(@race)
    else
      render :edit
    end
  end

  private
  def set_team_competitions
    @is_team_competitions = true
  end
end
