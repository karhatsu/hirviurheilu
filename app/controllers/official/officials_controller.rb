class Official::OfficialsController < Official::OfficialController
  before_filter :assign_race, :check_race_rights, :set_clubs

  def index
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      if user.races.include?(@race)
        flash[:error] = "Henkilö on jo tämän kilpailun toimitsija"
        render :index
      else
        user.races << @race
        flash[:notice] = "Toimitsija #{user.first_name} #{user.
          last_name} lisätty kilpailun #{@race.name} toimitsijaksi"
        redirect_to official_race_officials_path(@race)
      end
    else
      flash[:error] = "Tietokannasta ei löytynyt syöttämääsi sähköpostiosoitetta"
      render :index
    end
  end

  private
  def assign_race
    @race = Race.find(params[:race_id])
  end

  def check_race_rights
    check_race(@race)
  end

  def set_clubs
    @is_officials = true
  end
end
