class Official::ClubsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :set_clubs

  def index
    respond_to do |format|
      format.html { render :index }
      format.json { render :json => @race.clubs.to_json }
    end
  end

  def create
    @club = @race.clubs.build(club_params)
    if @club.save
      respond_to do |format|
        format.html { redirect_to(official_race_clubs_path(@race) )}
        format.js { render :created }
      end
    else
      respond_to do |format|
        format.html { render :index }
        format.js { render :created }
      end
    end
  end

  def update
    @club = Club.find(params[:id])
    @club.update(club_params)
    if @club.save
      respond_to do |format|
        format.html { redirect_to(official_race_clubs_path(@race) )}
        format.js { render :updated }
      end
    else
      respond_to do |format|
        format.html { render :index }
        format.js { render :updated }
      end
    end
  end

  def destroy
    @club = Club.find(params[:id])
    @club.destroy
    @clubs_count = @race.clubs.count
    respond_to do |format|
      format.html { redirect_to(official_race_clubs_path(@race) )}
      format.js { render :destroyed }
    end
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
