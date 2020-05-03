class FinishCompetition
  ACTION_DNS = Competitor::DNS
  ACTION_DNF = Competitor::DNF
  ACTION_DQ = Competitor::DQ
  ACTION_DELETE = 'DELETE'
  ACTION_COMPLETE = 'COMPLETE'
  ACTIONS = [ACTION_DNS, ACTION_DNF, ACTION_DQ, ACTION_DELETE, ACTION_COMPLETE]
  REAL_ACTIONS = [ACTION_DNS, ACTION_DNF, ACTION_DQ, ACTION_DELETE]

  attr_reader :error, :competitors_without_result

  def initialize(competition, competitor_actions = [])
    raise "Finish series available only for shooting races" if competition.is_a?(Series) && !competition.sport.shooting?
    @competition = competition
    @competitor_actions = competitor_actions
    @error = nil
    @competitors_without_result = []
    validate competitor_actions
  end

  def can_finish?
    !error
  end

  def finish
    raise error unless can_finish?
    do_competitor_actions
    @competition.finished = true
    @competition.save!
    if @competition.is_a? Race
      delete_series_without_competitors @competition
      @competition.series.where('finished=?', false).each do |series|
        series.finished = true
        series.save!
      end
    else
      race = @competition.race
      if race.all_series_finished?
        race.finished = true
        race.save!
        delete_series_without_competitors race
      end
    end
  end

  private

  def validate(competitor_actions)
    if !@competition.sport.shooting? && !@competition.each_competitor_has_correct_estimates?
      @error = I18n.t('activerecord.errors.models.race.attributes.base.correct_estimate_missing')
      return
    end
    @competition.competitors.each do |competitor|
      competitors_without_result << competitor unless competitor.finished? || action_for_competitor?(competitor_actions, competitor.id)
    end
    @error = I18n.t('activerecord.errors.models.race.attributes.base.results_missing') unless competitors_without_result.empty?
  end

  def action_for_competitor?(competitor_actions, competitor_id)
    competitor_actions.find {|action| action[:competitor_id] == competitor_id && REAL_ACTIONS.include?(action[:action])}
  end

  def do_competitor_actions
    @competitor_actions.each do |competitor_action|
      competitor_id = competitor_action[:competitor_id]
      action = competitor_action[:action]
      if action == ACTION_DELETE
        @competition.competitors.find(competitor_id).destroy
      else
        @competition.competitors.find(competitor_id).update_attribute :no_result_reason, action
      end
    end
  end

  def delete_series_without_competitors(race)
    race.series.each do |s|
      s.destroy if s.competitors.count == 0
    end
  end
end
