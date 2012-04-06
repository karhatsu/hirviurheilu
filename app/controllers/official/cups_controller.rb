# encoding: UTF-8
class Official::CupsController < Official::OfficialController
  before_filter :assign_cup_by_id, :check_assigned_cup, :except => [:new, :create]
  
  def new
    @cup = current_user.cups.build
  end
  
  def create
    @cup = current_user.cups.build(params[:cup])
    if @cup.valid?
      if enough_races?
        @cup.save!
        current_user.cups << @cup
        NewCompetitionMailer.new_cup(@cup, current_user).deliver
        flash[:success] = 'Cup-kilpailu lisätty'
        redirect_to official_cup_path(@cup)
      else
        flash[:error] = 'Sinun täytyy valita vähintään yhtä monta kilpailua kuin on yhteistulokseen laskettavien kilpailuiden määrä'
        render :new
      end
    else
      render :new
    end
  end
  
  def show
  end
  
  def update
    @cup.update_attributes(params[:cup])
    flash[:success] = 'Cup-kilpailu päivitetty'
    redirect_to official_cup_path(@cup)
  end
  
  private
  def enough_races?
    params[:cup][:race_ids] ||= []
    params[:cup][:race_ids].length >= @cup.top_competitions
  end
end