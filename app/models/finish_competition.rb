class FinishCompetition
  attr_reader :errors

  def initialize(race)
    @race = race
    @errors = []
    validate
  end

  def can_finish?
    @errors.empty?
  end

  def finish
    raise @errors.join('. ') unless can_finish?
    @race.finished = true
    @race.save!
    @race.series.each do |s|
      s.destroy if s.competitors.count == 0
    end
  end

  private

  def validate
    if !only_shooting? && !@race.each_competitor_has_correct_estimates?
      errors << I18n.t('activerecord.errors.models.race.attributes.base.correct_estimate_missing')
      return
    end
    @race.competitors.each do |c|
      unless c.finished?
        name = "#{c.first_name} #{c.last_name}"
        text_key = "activerecord.errors.models.race.attributes.base.result_missing_#{only_shooting? ? 'shooting' : 'three_sports'}"
        errors << I18n.t(text_key, name: name, series_name: c.series.name)
      end
    end
  end

  def only_shooting?
    @race.sport.only_shooting?
  end
end
