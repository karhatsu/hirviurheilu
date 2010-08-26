class Official::RacesController < Official::OfficialController
  before_filter :check_race_rights, :except => [:new, :create]

  def new
    @race = Race.new
  end

  def create
    @race = Race.new(params[:race])
    if @race.save
      current_user.races << @race
      flash[:notice] = "Kilpailu lisätty. Voit lisätä nyt sarjoja kilpailulle."
      redirect_to edit_official_race_path(@race)
    else
      render :new
    end
  end

  def edit
    @race = Race.find(params[:id])
  end

  def update
    @race = Race.find(params[:id])
    if @race.update_attributes(params[:race])
      redirect_to official_root_path
    else
      render :edit
    end
  end

  def destroy
    @race = Race.find(params[:id])
    if @race.destroy
      flash[:notice] = "Kilpailu poistettu"
    else
      flash[:error] = "Kilpailua ei voi poistaa: #{@race.errors[:base]}"
    end
    redirect_to official_root_path
  end

  private
  def check_race_rights
    check_race(Race.find(params[:id]))
  end
end
