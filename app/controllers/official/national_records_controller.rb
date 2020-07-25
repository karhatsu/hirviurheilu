class Official::NationalRecordsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def index
  end

  def update_all
    if @race.update update_params
      flash[:success] = t '.updated'
      redirect_to official_race_path(@race)
    else
      render :index
    end
  end

  private

  def update_params
    accepted = [{ series_attributes: [:id, :national_record, :rifle_national_record] }]
    params.require(:race).permit(accepted)
  end
end
