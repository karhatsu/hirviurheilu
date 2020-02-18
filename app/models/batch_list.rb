class BatchList
  attr_reader :errors

  def initialize(series)
    @series = series
    @errors = []
  end

  def generate(first_batch_number, first_track_place, first_batch_time, minutes_between_batches)
    return unless validate first_batch_number, first_track_place, first_batch_time, minutes_between_batches
    @series.transaction do
      reserved_places = find_reserved_places
      batch = find_or_create_batch first_batch_number, first_batch_time
      batch_number = batch.number
      competitors = shuffle_competitors @series.competitors.where('batch_id IS NULL AND track_place IS NULL')
      track_place = first_track_place
      competitors.each_with_index do |competitor, i|
        if i > 0 && batch_number != batch.number
          time = batch.time.advance minutes: minutes_between_batches
          batch = find_or_create_batch(batch_number, time)
        end
        competitor.batch = batch
        competitor.track_place = track_place
        competitor.save!
        batch_number, track_place = resolve_next_track_place reserved_places, batch.number, track_place
      end
    end
  rescue => e
    @errors << "#{I18n.t(:unexpected_error)}: #{e.message}"
  end

  private

  def race
    @series.race
  end

  def validate(first_batch_number, first_track_place, first_batch_time, minutes_between_batches)
    validate_number first_batch_number, 'invalid_first_batch_number'
    validate_number first_track_place, 'invalid_first_track_place'
    validate_time first_batch_time, 'invalid_first_batch_time'
    validate_number minutes_between_batches, 'invalid_minutes_between_batches'
    return false unless @errors.empty?
    return false unless validate_shooting_place_count
    return false unless validate_competitors_count
    validate_first_place first_batch_number, first_track_place, first_batch_time
  end

  def validate_number(number, error_key)
    @errors << I18n.t(error_key, scope: 'activerecord.errors.models.batch_list.ilmahirvi') unless number > 0
  end

  def validate_time(time, error_key)
    @errors << I18n.t(error_key, scope: 'activerecord.errors.models.batch_list.ilmahirvi') unless time =~ /[0-2]?[0-9]:[0-5][0-9]/
  end

  def validate_shooting_place_count
    return true if race.shooting_place_count.to_i > 0
    @errors << I18n.t('activerecord.errors.models.batch_list.ilmahirvi.no_shooting_place_count')
    false
  end

  def validate_competitors_count
    return true unless @series.competitors.empty?
    @errors << I18n.t('activerecord.errors.models.batch_list.ilmahirvi.no_competitors')
    false
  end

  def validate_first_place(first_batch_number, first_track_place, first_batch_time)
    batch = Batch.where('race_id=? AND number=?', race.id, first_batch_number).first
    return true unless batch
    if batch.time.strftime('%H:%M') != first_batch_time
      @errors << I18n.t('activerecord.errors.models.batch_list.ilmahirvi.first_batch_time_conflict')
      return false
    end
    competitor = Competitor.where('batch_id=? AND track_place=?', batch.id, first_track_place).first
    return true unless competitor
    @errors << I18n.t('activerecord.errors.models.batch_list.ilmahirvi.first_track_place_reserved')
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

  def find_or_create_batch(number, time)
    Batch.create_with(time: time).find_or_create_by!(race: race, number: number)
  end

  def resolve_next_track_place(reserved_places, prev_batch_number, prev_track_place)
    if prev_track_place == race.shooting_place_count
      batch_number = prev_batch_number + 1
      track_place = 1
    else
      batch_number = prev_batch_number
      track_place = prev_track_place + 1
    end
    if reserved_places[batch_number] && reserved_places[batch_number][track_place]
      resolve_next_track_place reserved_places, batch_number, track_place
    else
      [batch_number, track_place]
    end
  end
end
