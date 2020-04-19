class FinishCompetition
  ACTION_DNS = Competitor::DNS
  ACTION_DNF = Competitor::DNF
  ACTION_DQ = Competitor::DQ
  ACTION_DELETE = 'DELETE'
  ACTION_COMPLETE = 'COMPLETE'
  ACTIONS = [ACTION_DNS, ACTION_DNF, ACTION_DQ, ACTION_DELETE, ACTION_COMPLETE]
  REAL_ACTIONS = [ACTION_DNS, ACTION_DNF, ACTION_DQ, ACTION_DELETE]

  attr_reader :error, :competitors_without_result

  def initialize(race, competitor_actions = [])
    @race = race
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
    @race.finished = true
    @race.save!
    @race.series.each do |s|
      s.destroy if s.competitors.count == 0
    end
  end

  private

  def validate(competitor_actions)
    if !only_shooting? && !@race.each_competitor_has_correct_estimates?
      @error = I18n.t('activerecord.errors.models.race.attributes.base.correct_estimate_missing')
      return
    end
    @race.competitors.each do |competitor|
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
        @race.competitors.find(competitor_id).destroy
      else
        @race.competitors.find(competitor_id).update_attribute :no_result_reason, action
      end
    end
  end

  def only_shooting?
    @race.sport.only_shooting?
  end
end
