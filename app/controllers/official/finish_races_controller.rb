class Official::FinishRacesController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def new
    @competitors_without_result = []
  end

  def create
    finish_competition = FinishCompetition.new @race, build_competitor_actions
    if finish_competition.can_finish?
      finish_competition.finish
      FinishRaceMailer.finish_race(@race).deliver_now
      flash[:success] = t('official.finish_races.create.race_finished', :race_name => @race.name)
      redirect_to official_race_path(@race)
    else
      flash[:error] = finish_competition.error
      @competitors_without_result = finish_competition.competitors_without_result
      render :new
    end
  end

  private

  def build_competitor_actions
    return [] unless params[:competitor_ids]
    actions = []
    params[:competitor_ids].each do |competitor_id|
      actions << { competitor_id: competitor_id.to_i, action: params["competitor_#{competitor_id}"] }
    end
    actions
  end
end
