class HeatList
  attr_reader :errors

  def initialize(series)
    @series = series
    @errors = []
  end

  def generate_qualification_round(first_heat_number, first_track_place, first_heat_time, minutes_between_heats, opts = {})
    return unless validate false, first_heat_number, first_track_place, first_heat_time, minutes_between_heats, nil, opts
    competitors = shuffle_competitors @series.competitors.where('qualification_round_heat_id IS NULL AND qualification_round_track_place IS NULL')
    generate_heats false, competitors, first_heat_number, first_track_place, first_heat_time, minutes_between_heats, false, opts
  end

  def generate_final_round(first_heat_number, first_track_place, first_heat_time, minutes_between_heats, competitors_count, opts = {})
    return unless validate true, first_heat_number, first_track_place, first_heat_time, minutes_between_heats, competitors_count, opts
    competitors = competitors_for_final_round(competitors_count).select {|c| c.final_round_heat_id.nil? && c.final_round_track_place.nil? }
    competitors = competitors.reverse if opts[:best_as_last]
    generate_heats true, competitors, first_heat_number, first_track_place, first_heat_time, minutes_between_heats, false, opts
  end

  private

  def race
    @series.race
  end

  def validate(final_round, first_heat_number, first_track_place, first_heat_time, minutes_between_heats, competitors_count, opts)
    heat_day = opts[:heat_day] || 1
    first_heat_track_number = opts[:first_heat_track_number]
    include_tracks = opts[:include_tracks]
    validate_number first_heat_number, 'invalid_first_heat_number'
    validate_number first_track_place, 'invalid_first_track_place'
    validate_time first_heat_time, 'invalid_first_heat_time'
    validate_number minutes_between_heats, 'invalid_minutes_between_heats'
    validate_number competitors_count, 'invalid_competitors_count' if competitors_count
    if race.concurrent_heats > 1
      validate_number first_heat_track_number, 'invalid_first_heat_track_number'
      validate_included_tracks include_tracks
    end
    return false unless @errors.empty?
    return false unless validate_first_track_number first_heat_track_number, include_tracks if race.concurrent_heats > 1
    return false unless validate_track_count
    return false unless validate_shooting_place_count
    return false unless validate_competitors_count
    return false unless validate_free_track_time final_round, first_heat_number, first_heat_track_number, heat_day, first_heat_time if race.concurrent_heats > 1
    validate_first_place final_round, first_heat_number, first_track_place, heat_day, first_heat_time
  end

  def validate_number(number, error_key)
    @errors << I18n.t(error_key, scope: 'activerecord.errors.models.heat') unless number && number > 0
  end

  def validate_time(time, error_key)
    @errors << I18n.t(error_key, scope: 'activerecord.errors.models.heat') unless time =~ /^[0-2]?[0-9]:[0-5][0-9]$/
  end

  def validate_included_tracks(include_tracks)
    @errors << I18n.t('activerecord.errors.models.heat.invalid_included_tracks') if include_tracks.nil? || include_tracks.empty?
  end

  def validate_first_track_number(first_heat_track_number, include_tracks)
    return true if include_tracks.include? first_heat_track_number
    @errors << I18n.t('activerecord.errors.models.heat.included_tracks_mismatch')
    false
  end

  def validate_track_count
    return true if race.track_count.to_i > 0
    @errors << I18n.t('activerecord.errors.models.heat.no_shooting_place_count')
    false
  end

  def validate_shooting_place_count
    return true if race.shooting_place_count.to_i > 0
    @errors << I18n.t('activerecord.errors.models.heat.no_shooting_place_count')
    false
  end

  def validate_competitors_count
    return true unless @series.competitors.empty?
    @errors << I18n.t('activerecord.errors.models.heat.no_competitors')
    false
  end

  def validate_first_place(final_round, first_heat_number, first_track_place, heat_day, first_heat_time)
    if final_round
      heat = FinalRoundHeat.where('race_id=? AND number=?', race.id, first_heat_number).first
    else
      heat = QualificationRoundHeat.where('race_id=? AND number=?', race.id, first_heat_number).first
    end
    return true unless heat
    if heat.day != heat_day
      @errors << I18n.t('activerecord.errors.models.heat.first_heat_day_conflict')
      return false
    end
    if heat.time.strftime('%H:%M') != first_heat_time
      @errors << I18n.t('activerecord.errors.models.heat.first_heat_time_conflict')
      return false
    end
    if final_round
      competitor = Competitor.where('final_round_heat_id=? AND final_round_track_place=?', heat.id, first_track_place).first
    else
      competitor = Competitor.where('qualification_round_heat_id=? AND qualification_round_track_place=?', heat.id, first_track_place).first
    end
    return true unless competitor
    @errors << I18n.t('activerecord.errors.models.heat.first_track_place_reserved')
    false
  end

  def validate_free_track_time(final_round, first_heat_number, first_heat_track_number, heat_day, first_heat_time)
    where = 'race_id=? AND number!=? AND track=? AND day=? AND time=?'
    if final_round
      exists = FinalRoundHeat.where(where, race.id, first_heat_number, first_heat_track_number, heat_day, first_heat_time).exists?
    else
      exists = QualificationRoundHeat.where(where, race.id, first_heat_number, first_heat_track_number, heat_day, first_heat_time).exists?
    end
    return true unless exists
    @errors << I18n.t('activerecord.errors.models.heat.first_heat_track_conflict')
    false
  end

  def competitors_for_final_round(competitors_count)
    competitors = Competitor.sort_by_qualification_round(@series.sport, @series.competitors)
    required_score = competitors[competitors_count - 1]&.qualification_round_total_score || 0
    competitors.select {|c| c.qualification_round_total_score.to_i >= required_score && !c.no_result_reason}
  end

  def generate_heats(final_round, competitors, first_heat_number, first_track_place, first_heat_time, minutes_between_heats, only_one, opts)
    heat_day = opts[:heat_day] || 1
    @series.transaction do
      reserved_places = find_reserved_places final_round
      concurrent_heats = race.concurrent_heats
      track = resolve_first_track concurrent_heats, opts
      heat = find_or_create_heat final_round, first_heat_number, heat_day, first_heat_time, track
      heat_number, track_place = resolve_next_track_place reserved_places, heat.number, first_track_place - 1, opts
      competitors.each_with_index do |competitor, i|
        if i > 0 && heat_number != heat.number
          time = heat.time
          track = concurrent_heats == 1 ? nil : resolve_next_track(heat.track, concurrent_heats, opts[:include_tracks])
          if first_track? track, opts[:include_tracks]
            time = time.advance minutes: minutes_between_heats
          end
          heat = find_or_create_heat(final_round, heat_number, heat_day, time, track)
        end
        if final_round
          competitor.final_round_heat = heat
          competitor.final_round_track_place = track_place
        else
          competitor.qualification_round_heat = heat
          competitor.qualification_round_track_place = track_place
        end
        competitor.save!
        heat_number, track_place = resolve_next_track_place reserved_places, heat.number, track_place, opts
        break if only_one && heat_number != heat.number
      end
    end
  rescue => e
    @errors << "#{I18n.t(:unexpected_error)}: #{e.message}"
  end

  def find_reserved_places(final_round)
    reserved_places = Hash.new
    joins = final_round ? :final_round_heat : :qualification_round_heat
    where = final_round ? 'final_round_heat_id IS NOT NULL AND final_round_track_place IS NOT NULL' : 'qualification_round_heat_id IS NOT NULL AND qualification_round_track_place IS NOT NULL'
    order = final_round ? 'heats.number, competitors.final_round_track_place' : 'heats.number, competitors.qualification_round_track_place'
    @series.competitors.joins(joins).where(where).order(order).each do |competitor|
      heat_number = final_round ? competitor.final_round_heat.number : competitor.qualification_round_heat.number
      track_place = final_round ? competitor.final_round_track_place : competitor.qualification_round_track_place
      reserved_places[heat_number] ||= Hash.new
      reserved_places[heat_number][track_place] = true
    end
    reserved_places
  end

  def resolve_first_track(concurrent_heats, opts)
    opts[:first_heat_track_number] || 1 if concurrent_heats > 1
  end

  def shuffle_competitors(competitors)
    competitors.shuffle
  end

  def find_or_create_heat(final_round, number, day, time, track)
    if final_round
      heat = FinalRoundHeat.create_with(day: day, time: time, track: track).find_or_create_by!(race: race, number: number)
    else
      heat = QualificationRoundHeat.create_with(day: day, time: time, track: track).find_or_create_by!(race: race, number: number)
    end
    if heat.track.nil? && track
      heat.track = track
      heat.save!
    end
    heat
  end

  def resolve_next_track_place(reserved_places, prev_heat_number, prev_track_place, opts)
    if prev_track_place == race.competitors_per_heat
      heat_number = prev_heat_number + 1
      track_place = 1
    else
      heat_number = prev_heat_number
      track_place = prev_track_place + 1
    end
    try_next_track_place = reserved_places[heat_number] && reserved_places[heat_number][track_place]
    try_next_track_place ||= opts[:skip_first_track_place] && track_place == 1
    try_next_track_place ||= opts[:skip_last_track_place] && track_place == race.competitors_per_heat
    try_next_track_place ||= opts[:only_track_places] == 'odd' && track_place % 2 == 0
    try_next_track_place ||= opts[:only_track_places] == 'even' && track_place % 2 == 1
    try_next_track_place ||= (opts[:skip_track_places] || []).include? track_place
    if try_next_track_place
      resolve_next_track_place reserved_places, heat_number, track_place, opts
    else
      [heat_number, track_place]
    end
  end

  def resolve_next_track(current_track, concurrent_heats, include_tracks)
    next_track = (current_track || 1) + 1
    track = next_track > concurrent_heats ? 1 : next_track
    return track if include_tracks.include? track
    resolve_next_track track, concurrent_heats, include_tracks
  end

  def first_track?(track, include_tracks)
    track.nil? || track == include_tracks[0]
  end
end
