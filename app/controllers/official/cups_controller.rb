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
        flash_error_for_too_few_races
        render :new
      end
    else
      render :new
    end
  end
  
  def show
  end
  
  def update
    @cup.attributes = params[:cup]
    if @cup.valid?
      if enough_races?
        @cup.save!
        flash[:success] = 'Cup-kilpailu päivitetty'
        redirect_to official_cup_path(@cup)
      else
        flash_error_for_too_few_races
        render :new
      end
    else
      render :edit
    end
  end
  
  private
  def enough_races?
    params[:cup][:race_ids] ||= []
    params[:cup][:race_ids].length >= @cup.top_competitions
  end
  
  def flash_error_for_too_few_races
    flash[:error] = 'Sinun täytyy valita vähintään yhtä monta kilpailua kuin on yhteistulokseen laskettavien kilpailuiden määrä'
  end
end