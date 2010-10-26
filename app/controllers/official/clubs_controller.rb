class Official::ClubsController < Official::OfficialController
  before_filter :assign_race, :check_race_rights, :set_clubs

  def index
  end

  def create
    @club = @race.clubs.build(params[:club])
    if @club.save
      respond_to do |format|
        format.js { render :created }
      end
    else
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
    @is_clubs = true
  end
end
