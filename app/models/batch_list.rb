class BatchList
  attr_reader :errors

  def initialize(series)
    @series = series
    @errors = []
  end

  def generate_qualification_round(first_batch_number, first_track_place, first_batch_time, minutes_between_batches, opts = {})
    batch_day = opts[:batch_day] || 1
    return unless validate false, first_batch_number, first_track_place, batch_day, first_batch_time, minutes_between_batches
    competitors = shuffle_competitors @series.competitors.where('qualification_round_batch_id IS NULL AND qualification_round_track_place IS NULL')
    generate_batches false, competitors, first_batch_number, first_track_place, first_batch_time, minutes_between_batches, false, opts
  end

  def generate_final_round(first_batch_number, first_track_place, first_batch_time, minutes_between_batches, competitors_count, opts = {})
    batch_day = opts[:batch_day] || 1
    return unless validate true, first_batch_number, first_track_place, batch_day, first_batch_time, minutes_between_batches, competitors_count
    competitors = competitors_for_final_round(competitors_count).select {|c| c.final_round_batch_id.nil? && c.final_round_track_place.nil? }
    competitors = competitors.reverse if opts[:best_as_last]
    generate_batches true, competitors, first_batch_number, first_track_place, first_batch_time, minutes_between_batches, false, opts
  end

  private

  def race
    @series.race
  end

  def validate(final_round, first_batch_number, first_track_place, batch_day, first_batch_time, minutes_between_batches, competitors_count = nil)
    validate_number first_batch_number, 'invalid_first_batch_number'
    validate_number first_track_place, 'invalid_first_track_place'
    validate_time first_batch_time, 'invalid_first_batch_time'
    validate_number minutes_between_batches, 'invalid_minutes_between_batches'
    validate_number competitors_count, 'invalid_competitors_count' if competitors_count
    return false unless @errors.empty?
    return false unless validate_track_count
    return false unless validate_shooting_place_count
    return false unless validate_competitors_count
    validate_first_place final_round, first_batch_number, first_track_place, batch_day, first_batch_time
  end

  def validate_number(number, error_key)
    @errors << I18n.t(error_key, scope: 'activerecord.errors.models.batch_list') unless number > 0
  end

  def validate_time(time, error_key)
    @errors << I18n.t(error_key, scope: 'activerecord.errors.models.batch_list') unless time =~ /[0-2]?[0-9]:[0-5][0-9]/
  end

  def validate_track_count
    return true if race.track_count.to_i > 0
    @errors << I18n.t('activerecord.errors.models.batch_list.no_shooting_place_count')
    false
  end

  def validate_shooting_place_count
    return true if race.shooting_place_count.to_i > 0
    @errors << I18n.t('activerecord.errors.models.batch_list.no_shooting_place_count')
    false
  end

  def validate_competitors_count
    return true unless @series.competitors.empty?
    @errors << I18n.t('activerecord.errors.models.batch_list.no_competitors')
    false
  end

  def validate_first_place(final_round, first_batch_number, first_track_place, batch_day, first_batch_time)
    if final_round
      batch = FinalRoundBatch.where('race_id=? AND number=?', race.id, first_batch_number).first
    else
      batch = QualificationRoundBatch.where('race_id=? AND number=?', race.id, first_batch_number).first
    end
    return true unless batch
    if batch.day != batch_day
      @errors << I18n.t('activerecord.errors.models.batch_list.first_batch_day_conflict')
      return false
    end
    if batch.time.strftime('%H:%M') != first_batch_time
      @errors << I18n.t('activerecord.errors.models.batch_list.first_batch_time_conflict')
      return false
    end
    if final_round
      competitor = Competitor.where('final_round_batch_id=? AND final_round_track_place=?', batch.id, first_track_place).first
    else
      competitor = Competitor.where('qualification_round_batch_id=? AND qualification_round_track_place=?', batch.id, first_track_place).first
    end
    return true unless competitor
    @errors << I18n.t('activerecord.errors.models.batch_list.first_track_place_reserved')
    false
  end

  def competitors_for_final_round(competitors_count)
    competitors = Competitor.sort_by_qualification_round(@series.sport, @series.competitors)
    required_score = competitors[competitors_count - 1]&.qualification_round_score || 0
    competitors.select {|c| c.qualification_round_score.to_i >= required_score}
  end

  def generate_batches(final_round, competitors, first_batch_number, first_track_place, first_batch_time, minutes_between_batches, only_one, opts)
    batch_day = opts[:batch_day] || 1
    @series.transaction do
      reserved_places = find_reserved_places final_round
      concurrent_batches = race.concurrent_batches
      track = concurrent_batches > 1 ? 1 : nil
      batch = find_or_create_batch final_round, first_batch_number, batch_day, first_batch_time, track
      batch_number, track_place = resolve_next_track_place reserved_places, batch.number, first_track_place - 1, opts
      competitors.each_with_index do |competitor, i|
        if i > 0 && batch_number != batch.number
          time = batch.time
          time = time.advance minutes: minutes_between_batches if concurrent_batches == 1 || batch.track == concurrent_batches
          if concurrent_batches == 1
            track = nil
          else
            next_track = (batch.track || 1) + 1
            track = next_track > concurrent_batches ? 1 : next_track
          end
          batch = find_or_create_batch(final_round, batch_number, batch_day, time, track)
        end
        if final_round
          competitor.final_round_batch = batch
          competitor.final_round_track_place = track_place
        else
          competitor.qualification_round_batch = batch
          competitor.qualification_round_track_place = track_place
        end
        competitor.save!
        batch_number, track_place = resolve_next_track_place reserved_places, batch.number, track_place, opts
        break if only_one && batch_number != batch.number
      end
    end
  rescue => e
    @errors << "#{I18n.t(:unexpected_error)}: #{e.message}"
  end

  def find_reserved_places(final_round)
    reserved_places = Hash.new
    joins = final_round ? :final_round_batch : :qualification_round_batch
    where = final_round ? 'final_round_batch_id IS NOT NULL AND final_round_track_place IS NOT NULL' : 'qualification_round_batch_id IS NOT NULL AND qualification_round_track_place IS NOT NULL'
    order = final_round ? 'batches.number, competitors.final_round_track_place' : 'batches.number, competitors.qualification_round_track_place'
    @series.competitors.joins(joins).where(where).order(order).each do |competitor|
      batch_number = final_round ? competitor.final_round_batch.number : competitor.qualification_round_batch.number
      track_place = final_round ? competitor.final_round_track_place : competitor.qualification_round_track_place
      reserved_places[batch_number] ||= Hash.new
      reserved_places[batch_number][track_place] = true
    end
    reserved_places
  end

  def shuffle_competitors(competitors)
    competitors.shuffle
  end

  def find_or_create_batch(final_round, number, day, time, track)
    if final_round
      batch = FinalRoundBatch.create_with(day: day, time: time, track: track).find_or_create_by!(race: race, number: number)
    else
      batch = QualificationRoundBatch.create_with(day: day, time: time, track: track).find_or_create_by!(race: race, number: number)
    end
    if batch.track.nil? && track
      batch.track = track
      batch.save!
    end
    batch
  end

  def resolve_next_track_place(reserved_places, prev_batch_number, prev_track_place, opts)
    if prev_track_place == race.competitors_per_batch
      batch_number = prev_batch_number + 1
      track_place = 1
    else
      batch_number = prev_batch_number
      track_place = prev_track_place + 1
    end
    try_next_track_place = reserved_places[batch_number] && reserved_places[batch_number][track_place]
    try_next_track_place ||= opts[:skip_first_track_place] && track_place == 1
    try_next_track_place ||= opts[:skip_last_track_place] && track_place == race.competitors_per_batch
    try_next_track_place ||= opts[:only_track_places] == 'odd' && track_place % 2 == 0
    try_next_track_place ||= opts[:only_track_places] == 'even' && track_place % 2 == 1
    try_next_track_place ||= (opts[:skip_track_places] || []).include? track_place
    if try_next_track_place
      resolve_next_track_place reserved_places, batch_number, track_place, opts
    else
      [batch_number, track_place]
    end
  end
end
