module HeatListSuggestions
  extend ActiveSupport::Concern

  def next_heat_number(final_round)
    biggest_number = find_heats(final_round).maximum('number') || 0
    biggest_number + 1
  end

  def next_heat_time(final_round)
    min = suggested_min_between_heats final_round
    return nil unless min
    biggest_time = find_heats(final_round).except(:order).order('day DESC, time DESC').first
    biggest_time.time.advance(minutes: min).strftime('%H:%M')
  end

  def first_available_heat_number(final_round)
    heat_number, _, _ = first_available_heat_data final_round
    heat_number
  end

  def first_available_track_place(final_round)
    _, track_place, _ = first_available_heat_data final_round
    track_place
  end

  def suggested_next_track_number(final_round)
    _, _, track = first_available_heat_data final_round
    track
  end

  def suggested_min_between_heats(final_round)
    last_heats = find_heats(final_round).where('track IS NULL OR track = 1').except(:order).order('day DESC, time DESC').limit(2)
    return nil if last_heats.length < 2
    return nil if last_heats[0].day != last_heats[1].day
    (last_heats[0].time - last_heats[1].time).to_i / 60
  end

  def suggested_next_heat_time(final_round)
    last_heat = find_heats(final_round).except(:order).order('day DESC, time DESC, number DESC').first
    return nil unless last_heat
    next_heat, _, track = first_available_heat_data final_round
    if next_heat == last_heat.number || track.to_i > 1
      last_heat.time.strftime('%H:%M')
    else
      minutes = suggested_min_between_heats final_round
      last_heat.time.advance(minutes: minutes).strftime('%H:%M') if minutes
    end
  end

  def suggested_next_heat_day(final_round)
    last_heat = find_heats(final_round).except(:order).order('day DESC').first
    last_heat&.day || 1
  end

  private

  def first_available_heat_data(final_round)
    max_heat = find_heats(final_round).except(:order).order('day DESC, time DESC, number DESC').first
    return [1, 1, 1] unless max_heat
    max_track_place = competitors.where('qualification_round_heat_id=?', max_heat.id).maximum(:qualification_round_track_place) unless final_round
    max_track_place = competitors.where('final_round_heat_id=?', max_heat.id).maximum(:final_round_track_place) if final_round
    if competitors_per_heat && max_track_place.to_i >= competitors_per_heat
      return [max_heat.number + 1, 1, nil] unless max_heat.track
      track = max_heat.track + 1 > track_count ? 1 : max_heat.track + 1
      return [max_heat.number + 1, 1, track]
    end
    [max_heat.number, max_track_place.to_i + 1, max_heat.track]
  end
end
