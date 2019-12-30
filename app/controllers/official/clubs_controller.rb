class Official::ClubsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :set_clubs

  def index
    respond_to do |format|
      format.html { render :index }
      format.json { render :json => @race.clubs.to_json }
    end
  end

  def new
    @club = @race.clubs.build
  end

  def create
    @club = @race.clubs.build(club_params)
    if @club.save
      redirect_to official_race_clubs_path(@race)
    else
      render :new
    end
  end

  def edit
    @club = Club.find(params[:id])
  end

  def update
    @club = Club.find(params[:id])
    @club.update(club_params)
    if @club.save
      redirect_to official_race_clubs_path(@race)
    else
      render :edit
    end
  end

  def destroy
    @club = Club.find(params[:id])
    @club.destroy
    @clubs_count = @race.clubs.count
    redirect_to official_race_clubs_path(@race)
  end

  def competitors
    respond_to do |format|
      format.pdf do
        render :pdf => "#{@race.name}-kilpailijat-seuroittain", :layout => true, :margin => pdf_margin,
               :header => pdf_header("#{@race.name} - Kilpailijat piireittäin/seuroittain\n"), :footer => pdf_footer,
               disable_smart_shrinking: true
      end
    end
  end

  private
  def set_clubs
    @is_clubs = true
  end

  def club_params
    params.require(:club).permit(:name, :long_name)
  end
end
