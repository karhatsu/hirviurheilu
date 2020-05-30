module Shots
  extend ActiveSupport::Concern

  def hits
    non_zero_shots shots
  end

  def qualification_round_shots
    split_shots sport.qualification_round, 0
  end

  def qualification_round_hits
    non_zero_shots qualification_round_shots
  end

  def qualification_round_sub_scores
    qualification_shots = qualification_round_shots
    return nil unless qualification_shots
    qualification_shots.map {|shots| sum_of_array shots, true}
  end

  def qualification_round_score
    return qualification_round_shooting_score_input if qualification_round_shooting_score_input
    sub_scores = qualification_round_sub_scores
    return nil unless sub_scores
    sum_of_array sub_scores
  end

  def final_round_shots
    qualification_round_rules = sport.qualification_round
    final_round_rules = sport.final_round
    return nil unless qualification_round_rules && final_round_rules
    split_shots final_round_rules, sport.qualification_round_shot_count
  end

  def final_round_sub_scores
    final_shots = final_round_shots
    return nil unless final_shots
    final_shots.map {|shots| sum_of_array shots, true}
  end

  def final_round_score
    return final_round_shooting_score_input if final_round_shooting_score_input
    sub_scores = final_round_sub_scores
    return nil unless sub_scores
    sum_of_array sub_scores
  end

  def shooting_score
    return shooting_score_input if shooting_score_input
    return qualification_round_score + final_round_score.to_i if sport.qualification_round && qualification_round_score
    shots.map(&:to_i).inject(:+) || 0 if shots
  end

  def nordic_trap_score
    resolve_nordic_score nordic_trap_score_input, nordic_trap_shots
  end

  def nordic_shotgun_score
    resolve_nordic_score nordic_shotgun_score_input, nordic_shotgun_shots
  end

  def nordic_rifle_moving_score
    resolve_nordic_score nordic_rifle_moving_score_input, nordic_rifle_moving_shots
  end

  def nordic_rifle_standing_score
    resolve_nordic_score nordic_rifle_standing_score_input, nordic_rifle_standing_shots
  end

  def nordic_score
    return nil unless nordic_trap_score || nordic_shotgun_score || nordic_rifle_moving_score || nordic_rifle_standing_score
    4 * (nordic_trap_score.to_i + nordic_shotgun_score.to_i) + nordic_rifle_moving_score.to_i + nordic_rifle_standing_score.to_i
  end

  private

  def non_zero_shots(shots)
    shots.flatten.select {|shot| shot > 0}.length if shots
  end

  def split_shots(rules, start_index)
    return nil unless rules && shots
    part1 = shots[start_index, rules[0]]
    return nil unless part1 && part1.length > 0
    return [part1] if rules.length == 1
    part2 = shots[start_index + rules[0], rules[1]] || []
    [part1, part2]
  end

  def sum_of_array(array, eleven_as_ten = false)
    array = array.map {|value| value == 11 ? 10 : value} if eleven_as_ten
    array&.inject(:+) || 0
  end

  def resolve_nordic_score(score_input, shots)
    return score_input if score_input
    return sum_of_array shots if shots
  end
end
