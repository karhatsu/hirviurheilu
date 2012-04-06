# encoding: UTF-8
class Official::CupsController < Official::OfficialController
  #TODO: permission check
  
  def new
    @cup = current_user.cups.build
  end
  
  def create
    # TODO: cup email
    @cup = current_user.cups.build(params[:cup])
    @cup.save
    flash[:success] = 'Cup-kilpailu lisätty'
    redirect_to official_cup_path(@cup)
  end
  
  def show
    @cup = Cup.find(params[:id])
  end
end