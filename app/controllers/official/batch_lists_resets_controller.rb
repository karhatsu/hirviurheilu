class Official::BatchListsResetsController < Official::OfficialController
  before_action :set_menu_batches, :assign_race_by_race_id, :check_assigned_race

  def show
  end

  def destroy
    if params[:type].blank?
      flash[:error] = t('.choose_type')
      render :show
    elsif @race.name == params[:confirm_text]
      flash[:success] = t('.batches_cleared')
      @race.transaction do
        destroy_data
      end
      redirect_to official_race_batches_path(@race)
    else
      flash[:error] = t('.confirm_text_was_wrong')
      render :show
    end
  end

  private

  def set_menu_batches
    @is_batches = true
  end

  def destroy_data
    if params[:type] == 'QualificationRoundBatch'
      @race.competitors.update_all('qualification_round_batch_id=null, qualification_round_track_place=null')
      @race.qualification_round_batches.destroy_all if params[:delete_batches]
    elsif params[:type] == 'FinalRoundBatch'
      @race.competitors.update_all('final_round_batch_id=null, final_round_track_place=null')
      @race.final_round_batches.destroy_all if params[:delete_batches]
    end
  end
end
