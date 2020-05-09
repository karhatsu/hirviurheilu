class Official::FinishRacesController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def new
    @competitors_without_result = []
    @unfinished_series = unfinished_series
  end

  def create
    competition = params[:series_id].blank? ? @race : @race.series.find(params[:series_id])
    finish_competition = FinishCompetition.new competition, build_competitor_actions
    if finish_competition.can_finish?
      finish_competition.finish
      if competition.is_a? Race
        FinishRaceMailer.finish_race(@race).deliver_now
        flash[:success] = t('official.finish_races.create.race_finished', race_name: @race.name)
        redirect_to official_race_path(@race)
      else
        flash[:success] = t('official.finish_races.create.series_finished', series_name: competition.name)
        redirect_to new_official_race_finish_race_path(@race)
      end
    else
      flash[:error] = finish_competition.error
      @competitors_without_result = finish_competition.competitors_without_result.sort {|a, b| a.number <=> b.number}
      @unfinished_series = unfinished_series
      render :new
    end
  end

  private

  def unfinished_series
    @race.sport.shooting? ? @race.series.where('finished=? and competitors_count>0', false) : []
  end

  def build_competitor_actions
    return [] unless params[:competitor_ids]
    actions = []
    params[:competitor_ids].each do |competitor_id|
      actions << { competitor_id: competitor_id.to_i, action: params["competitor_#{competitor_id}"] }
    end
    actions
  end
end
