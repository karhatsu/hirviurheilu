class BatchList
  attr_reader :errors

  def initialize(series)
    @series = series
    @errors = []
  end

  def generate(first_batch_number, first_track_place, first_batch_time, concurrent_batches, minutes_between_batches, opts = {})
    batch_day = opts[:batch_day] || 1
    return unless validate first_batch_number, first_track_place, batch_day, first_batch_time, concurrent_batches, minutes_between_batches
    @series.transaction do
      reserved_places = find_reserved_places
      track = concurrent_batches > 1 ? 1 : nil
      batch = find_or_create_batch first_batch_number, batch_day, first_batch_time, track
      competitors = shuffle_competitors @series.competitors.where('batch_id IS NULL AND track_place IS NULL')
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
          batch = find_or_create_batch(batch_number, batch_day, time, track)
        end
        competitor.batch = batch
        competitor.track_place = track_place
        competitor.save!
        batch_number, track_place = resolve_next_track_place reserved_places, batch.number, track_place, opts
      end
    end
  rescue => e
    @errors << "#{I18n.t(:unexpected_error)}: #{e.message}"
  end

  private

  def race
    @series.race
  end

  def validate(first_batch_number, first_track_place, batch_day, first_batch_time, concurrent_batches, minutes_between_batches)
    validate_number first_batch_number, 'invalid_first_batch_number'
    validate_number first_track_place, 'invalid_first_track_place'
    validate_time first_batch_time, 'invalid_first_batch_time'
    validate_number concurrent_batches, 'invalid_concurrent_batches'
    validate_number minutes_between_batches, 'invalid_minutes_between_batches'
    return false unless @errors.empty?
    return false unless validate_shooting_place_count
    return false unless validate_competitors_count
    validate_first_place first_batch_number, first_track_place, batch_day, first_batch_time
  end

  def validate_number(number, error_key)
    @errors << I18n.t(error_key, scope: 'activerecord.errors.models.batch_list') unless number > 0
  end

  def validate_time(time, error_key)
    @errors << I18n.t(error_key, scope: 'activerecord.errors.models.batch_list') unless time =~ /[0-2]?[0-9]:[0-5][0-9]/
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

  def validate_first_place(first_batch_number, first_track_place, batch_day, first_batch_time)
    batch = Batch.where('race_id=? AND number=?', race.id, first_batch_number).first
    return true unless batch
    if batch.day != batch_day
      @errors << I18n.t('activerecord.errors.models.batch_list.first_batch_day_conflict')
      return false
    end
    if batch.time.strftime('%H:%M') != first_batch_time
      @errors << I18n.t('activerecord.errors.models.batch_list.first_batch_time_conflict')
      return false
    end
    competitor = Competitor.where('batch_id=? AND track_place=?', batch.id, first_track_place).first
    return true unless competitor
    @errors << I18n.t('activerecord.errors.models.batch_list.first_track_place_reserved')
    false
  end

  def find_reserved_places
    reserved_places = Hash.new
    @series.competitors.joins(:batch).where('batch_id IS NOT NULL AND track_place IS NOT NULL').order('batches.number, competitors.track_place').each do |competitor|
      batch_number = competitor.batch.number
      reserved_places[batch_number] ||= Hash.new
      reserved_places[batch_number][competitor.track_place] = true
    end
    reserved_places
  end

  def shuffle_competitors(competitors)
    competitors.shuffle
  end

  def find_or_create_batch(number, day, time, track)
    batch = Batch.create_with(day: day, time: time, track: track).find_or_create_by!(race: race, number: number)
    if batch.track.nil? && track
      batch.track = track
      batch.save!
    end
    batch
  end

  def resolve_next_track_place(reserved_places, prev_batch_number, prev_track_place, opts)
    if prev_track_place == race.shooting_place_count
      batch_number = prev_batch_number + 1
      track_place = 1
    else
      batch_number = prev_batch_number
      track_place = prev_track_place + 1
    end
    try_next_track_place = reserved_places[batch_number] && reserved_places[batch_number][track_place]
    try_next_track_place ||= opts[:skip_first_track_place] && track_place == 1
    try_next_track_place ||= opts[:skip_last_track_place] && track_place == race.shooting_place_count
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