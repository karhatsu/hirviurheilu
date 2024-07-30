class Official::HeatListResetsController < Official::OfficialController
  before_action :set_menu_heats, :assign_race_by_race_id, :check_assigned_race

  def show
  end

  def destroy
    if params[:type].blank?
      flash[:error] = t('.choose_type')
      render :show
    elsif @race.name == params[:confirm_text]
      flash[:success] = t('.heats_cleared')
      @race.transaction do
        destroy_data
      end
      redirect_to official_race_heats_path(@race)
    else
      flash[:error] = t('.confirm_text_was_wrong')
      render :show
    end
  end

  private

  def set_menu_heats
    @is_heats = true
  end

  def destroy_data
    if params[:type] == 'QualificationRoundHeat'
      @race.competitors.update_all('qualification_round_heat_id=null, qualification_round_track_place=null')
      @race.qualification_round_heats.destroy_all if params[:delete_heats]
    elsif params[:type] == 'FinalRoundHeat'
      @race.competitors.update_all('final_round_heat_id=null, final_round_track_place=null')
      @race.final_round_heats.destroy_all if params[:delete_heats]
    end
  end
end
