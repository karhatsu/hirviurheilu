class FinishCompetition
  attr_reader :error, :competitors_without_result

  def initialize(race)
    @race = race
    @error = nil
    @competitors_without_result = []
    validate
  end

  def can_finish?
    !error
  end

  def finish
    raise error unless can_finish?
    @race.finished = true
    @race.save!
    @race.series.each do |s|
      s.destroy if s.competitors.count == 0
    end
  end

  private

  def validate
    if !only_shooting? && !@race.each_competitor_has_correct_estimates?
      @error = I18n.t('activerecord.errors.models.race.attributes.base.correct_estimate_missing')
      return
    end
    @race.competitors.each do |competitor|
      competitors_without_result << competitor unless competitor.finished?
    end
    @error = I18n.t('activerecord.errors.models.race.attributes.base.results_missing') unless competitors_without_result.empty?
  end

  def only_shooting?
    @race.sport.only_shooting?
  end
end
