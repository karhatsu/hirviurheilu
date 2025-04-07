class Official::HeatsController < Official::OfficialController
  before_action :set_menu_heats, :assign_race_by_race_id, :check_assigned_race

  def index
    @qualification_round_heats = @race.qualification_round_heats.includes(competitors: [:club, :series])
    @final_round_heats = @race.final_round_heats.includes(competitors: [:club, :series])
  end

  def new
    @heat = @race.heats.build
    @heat.type = params[:type]
    if @heat.type
      @heat.number = @race.next_heat_number(@heat.final_round?)
      @heat.time = @race.next_heat_time(@heat.final_round?) || '00:00'
    else
      @heat.time = '00:00'
    end
  end

  def create
    @heat = @race.heats.build heat_params
    @heat.type = 'QualificationRoundHeat' if @race.sport.one_heat_list?
    if @heat.save
      flash[:success] = t '.heat_added'
      redirect_to official_race_heats_path(@race)
    else
      render :new
    end
  end

  def edit
    @heat = @race.heats.find params[:id]
  end

  def update
    @heat = @race.heats.find params[:id]
    if @heat.update heat_params
      flash[:success] = t '.heat_updated'
      redirect_to official_race_heats_path(@race)
    else
      render :edit
    end
  end

  def destroy
    @heat = @race.heats.find params[:id]
    @heat.destroy
    flash[:success] = t '.heat_deleted'
    redirect_to official_race_heats_path(@race)
  end

  private

  def set_menu_heats
    @is_heats = true
  end

  def heat_params
    params.require(:heat).permit(:type, :number, :track, :day, :day2, :day3, :day4, :time, :time2, :time3, :time4, :description)
  end
end
