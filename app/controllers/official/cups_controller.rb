# encoding: UTF-8
class Official::CupsController < Official::OfficialController
  #TODO: permission check
  
  def new
    @cup = current_user.cups.build
  end
  
  def create
    # TODO: cup email
    @cup = current_user.cups.build(params[:cup])
    if @cup.valid?
      @cup.save
      current_user.cups << @cup
      params[:race_id].each do |race_id|
        race = current_user.races.find(race_id)
        @cup.races << race
      end
      flash[:success] = 'Cup-kilpailu lisätty'
      redirect_to official_cup_path(@cup)
    else
      render :new
    end
  end
  
  def show
    @cup = Cup.find(params[:id])
  end
end