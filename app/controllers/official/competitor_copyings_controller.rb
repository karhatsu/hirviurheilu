class Official::CompetitorCopyingsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :load_races

  def new
  end

  def create
    source_race = Race.find params[:source_race_id]
    errors = @race.copy_competitors_from source_race
    if errors.empty?
      flash[:success] = t('.competitors_copied', amount: source_race.competitors.count)
      redirect_to official_race_path(@race)
    else
      flash[:error] = errors.uniq.join(' ')
      render :new
    end
  end

  def show
    redirect_to new_official_race_competitor_copying_path(@race)
  end

  private

  def load_races
    @races = current_user.races.order('start_date desc').select {|race| race.id != @race.id}
  end
end