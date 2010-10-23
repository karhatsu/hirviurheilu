class Official::RacesController < Official::OfficialController
  before_filter :check_race_rights, :except => [:new, :create]

  def new
    @race = Race.new
    @race.start_interval_seconds = Race::DEFAULT_START_INTERVAL
  end

  def create
    @race = Race.new(params[:race])
    if @race.save
      current_user.races << @race
      flash[:notice] = "Kilpailu lisätty. "
      if params[:add_default_series]
        @race.add_default_series
        flash[:notice] << "Pääset lisäämään kilpailijoita klikkaamalla sarjan " +
          "nimen vieressä olevaa linkkiä."
        redirect_to official_root_path
      else
        flash[:notice] << "Voit nyt lisätä sarjoja kilpailulle alla olevasta linkistä."
        redirect_to edit_official_race_path(@race)
      end
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
