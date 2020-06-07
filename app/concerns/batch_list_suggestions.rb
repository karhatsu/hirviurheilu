module BatchListSuggestions
  extend ActiveSupport::Concern

  def next_batch_number(final_round)
    biggest_number = find_batches(final_round).maximum('number') || 0
    biggest_number + 1
  end

  def next_batch_time(final_round)
    min = suggested_min_between_batches final_round
    return nil unless min
    biggest_time = find_batches(final_round).except(:order).order('day DESC, time DESC').first
    biggest_time.time.advance(minutes: min).strftime('%H:%M')
  end

  def first_available_batch_number(final_round)
    batch_number, _, _ = first_available_batch_data final_round
    batch_number
  end

  def first_available_track_place(final_round)
    _, track_place, _ = first_available_batch_data final_round
    track_place
  end

  def suggested_next_track_number(final_round)
    _, _, track = first_available_batch_data final_round
    track
  end

  def suggested_min_between_batches(final_round)
    last_batches = find_batches(final_round).where('track IS NULL OR track = 1').except(:order).order('day DESC, time DESC').limit(2)
    return nil if last_batches.length < 2
    return nil if last_batches[0].day != last_batches[1].day
    (last_batches[0].time - last_batches[1].time).to_i / 60
  end

  def suggested_next_batch_time(final_round)
    last_batch = find_batches(final_round).except(:order).order('day DESC, time DESC, number DESC').first
    return nil unless last_batch
    next_batch, _, track = first_available_batch_data final_round
    if next_batch == last_batch.number || track.to_i > 1
      last_batch.time.strftime('%H:%M')
    else
      minutes = suggested_min_between_batches final_round
      last_batch.time.advance(minutes: minutes).strftime('%H:%M') if minutes
    end
  end

  def suggested_next_batch_day(final_round)
    last_batch = find_batches(final_round).except(:order).order('day DESC').first
    last_batch&.day || 1
  end

  private

  def first_available_batch_data(final_round)
    max_batch = find_batches(final_round).except(:order).order('day DESC, time DESC, number DESC').first
    return [1, 1, 1] unless max_batch
    max_track_place = competitors.where('qualification_round_batch_id=?', max_batch.id).maximum(:qualification_round_track_place) unless final_round
    max_track_place = competitors.where('final_round_batch_id=?', max_batch.id).maximum(:final_round_track_place) if final_round
    if competitors_per_batch && max_track_place.to_i >= competitors_per_batch
      return [max_batch.number + 1, 1, nil] unless max_batch.track
      track = max_batch.track + 1 > track_count ? 1 : max_batch.track + 1
      return [max_batch.number + 1, 1, track]
    end
    [max_batch.number, max_track_place.to_i + 1, max_batch.track]
  end
end
