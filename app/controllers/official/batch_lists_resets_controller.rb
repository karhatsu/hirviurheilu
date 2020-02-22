class Official::BatchListsResetsController < Official::OfficialController
  before_action :set_menu_batches, :assign_race_by_race_id, :check_assigned_race

  def show
  end

  def destroy
    if @race.name == params[:confirm_text]
      flash[:success] = t('.batches_cleared')
      @race.competitors.update_all('batch_id=null, track_place=null')
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
end
