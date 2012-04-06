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
        add_cup
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
    @cup = Cup.find(params[:id])
  end
  
  private
  def enough_races?
    params[:race_id] and params[:race_id].length >= @cup.top_competitions
  end
  
  def add_cup
    @cup.save
    current_user.cups << @cup
    params[:race_id].each do |race_id|
      race = current_user.races.find(race_id)
      @cup.races << race
    end
  end
end