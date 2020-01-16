module Shots
  extend ActiveSupport::Concern

  def hits
    shots.select {|shot| shot > 0}.length if shots
  end

  def qualification_round_shots
    split_shots sport.qualification_round, 0
  end

  def qualification_round_sub_scores
    qualification_shots = qualification_round_shots
    return nil unless qualification_shots
    qualification_shots.map {|shots| sum_of_array shots, true}
  end

  def qualification_round_score
    sub_scores = qualification_round_sub_scores
    return nil unless sub_scores
    sum_of_array sub_scores, true
  end

  def final_round_shots
    qualification_round_rules = sport.qualification_round
    final_round_rules = sport.final_round
    return nil unless qualification_round_rules && final_round_rules
    qualification_round_shot_count = sum_of_array qualification_round_rules, false
    split_shots final_round_rules, qualification_round_shot_count
  end

  def final_round_sub_scores
    final_shots = final_round_shots
    return nil unless final_shots
    final_shots.map {|shots| sum_of_array shots, true}
  end

  def final_round_score
    sub_scores = final_round_sub_scores
    return nil unless sub_scores
    sum_of_array sub_scores, true
  end

  def extra_round_shots
    return nil unless shots
    qualification_round_rules = sport.qualification_round
    final_round_rules = sport.final_round
    return nil unless qualification_round_rules && final_round_rules
    regular_shot_count = sum_of_array(qualification_round_rules, false) + sum_of_array(final_round_rules, false)
    extra_shots = shots[regular_shot_count..-1]
    extra_shots if extra_shots && extra_shots.length > 0 or nil
  end

  def extra_round_score
    extra_shots = extra_round_shots
    return nil unless extra_shots
    sum_of_array extra_shots, true
  end

  def shooting_score
    return shooting_score_input if shooting_score_input
    return qualification_round_score + final_round_score.to_i if sport.qualification_round && qualification_round_score
    shots.map(&:to_i).inject(:+) || 0 if shots
  end

  private

  def split_shots(rules, start_index)
    return nil unless rules && shots
    part1 = shots[start_index, rules[0]]
    return nil unless part1 && part1.length > 0
    return [part1] if rules.length == 1
    part2 = shots[start_index + rules[0], rules[1]] || []
    [part1, part2]
  end

  def sum_of_array(array, eleven_as_ten)
    array = array.map {|value| value == 11 ? 10 : value} if eleven_as_ten
    array&.inject(:+) || 0
  end
end
