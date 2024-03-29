class Official::ClubsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :set_clubs

  def index
    respond_to do |format|
      format.html do
        use_react true
        render layout: true, html: ''
      end
      format.json
    end
  end

  def create
    @club = @race.clubs.build(club_params)
    unless @club.save
      render status: 400, json: { errors: @club.errors.full_messages }
    end
  end

  def update
    @club = Club.find(params[:id])
    @club.update(club_params)
    unless @club.save
      render status: 400, json: { errors: @club.errors.full_messages }
    end
  end

  def destroy
    @club = Club.find(params[:id])
    if @club.destroy
      render status: 201, body: nil
    else
      render status: 400, json: { errors: @club.errors.full_messages }
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
