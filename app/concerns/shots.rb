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
    qualification_shots.map {|shots| sum_of_array shots}
  end

  def qualification_round_score
    sub_scores = qualification_round_sub_scores
    return nil unless sub_scores
    sum_of_array sub_scores
  end

  def final_round_shots
    qualification_round_rules = sport.qualification_round
    final_round_rules = sport.final_round
    return nil unless qualification_round_rules && final_round_rules
    qualification_round_shot_count = sum_of_array qualification_round_rules
    split_shots final_round_rules, qualification_round_shot_count
  end

  def final_round_sub_scores
    final_shots = final_round_shots
    return nil unless final_shots
    final_shots.map {|shots| sum_of_array shots}
  end

  def final_round_score
    sub_scores = final_round_sub_scores
    return nil unless sub_scores
    sum_of_array sub_scores
  end

  def extra_round_shots
    qualification_round_rules = sport.qualification_round
    final_round_rules = sport.final_round
    return nil unless qualification_round_rules && final_round_rules
    regular_shot_count = sum_of_array(qualification_round_rules) + sum_of_array(final_round_rules)
    shots[regular_shot_count..-1] || []
  end

  def extra_round_score
    extra_shots = extra_round_shots
    return nil unless extra_shots
    sum_of_array extra_shots
  end

  def shooting_score
    return shooting_score_input if shooting_score_input
    shots.map(&:to_i).inject(:+) || 0 if shots
  end

  private

  def split_shots(rules, start_index)
    return nil unless rules
    part1 = shots[start_index, rules[0]] || []
    return [part1] if rules.length == 1
    part2 = shots[start_index + rules[0], rules[1]] || []
    [part1, part2]
  end

  def sum_of_array(array)
    array&.inject(:+) || 0
  end
end
