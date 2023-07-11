class Official::CupsController < Official::OfficialController
  before_action :assign_cup_by_id, :check_assigned_cup, except: [:new, :create]
  before_action :assign_races_for_new, only: [:new, :create]
  before_action :assign_races_for_edit, only: [:edit, :update]

  def new
    @cup = current_user.cups.build
  end

  def create
    @cup = current_user.cups.build(create_cup_params)
    if @cup.valid? && enough_races?
      @cup.save!
      @cup.create_default_cup_series
      @cup.create_default_cup_team_competitions if params[:team_competitions]
      current_user.cups << @cup
      flash[:success] = 'Cup-kilpailu lisätty'
      redirect_to official_cup_path(@cup)
    else
      flash_error_for_too_few_races unless enough_races?
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @cup.attributes = update_cup_params
    if @cup.valid? and enough_races?
      @cup.save!
      flash[:success] = 'Cup-kilpailu päivitetty'
        redirect_to official_cup_path(@cup)
    else
      flash_error_for_too_few_races unless enough_races?
      render :edit
    end
  end

  def destroy
    @cup.destroy
    redirect_to official_root_path
  end

  private

  def assign_races_for_new
    @races = current_user.races.where('start_date>=?', 1.year.ago)
  end

  def assign_races_for_edit
    @races = (current_user.races.where('start_date>=?', 1.year.ago) + @cup.races)
               .uniq {|r| r.id}
               .sort {|a, b| b.start_date <=> a.start_date}
  end

  def enough_races?
    params[:cup][:race_ids] ||= []
    params[:cup][:race_ids].length >= @cup.top_competitions.to_i
  end

  def flash_error_for_too_few_races
    flash[:error] = 'Sinun täytyy valita vähintään yhtä monta kilpailua kuin on yhteistulokseen laskettavien kilpailuiden määrä'
  end

  def create_cup_params
    params.require(:cup).permit(:name, :top_competitions, :include_always_last_race, :public_message, :use_qualification_round_result, race_ids: [])
  end

  def update_cup_params
    params.require(:cup).permit(:name, :top_competitions, :include_always_last_race, :public_message, :use_qualification_round_result,
                                race_ids: [],
                                cup_series_attributes: [:id, :name, :series_names, :_destroy],
                                cup_team_competitions_attributes: [:id, :name, :_destroy])
  end
end
