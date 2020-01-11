module Shots
  extend ActiveSupport::Concern

  def qualification_round_shots
    rules = sport.qualification_round
    return nil unless rules
    part1 = shots[0, rules[0]]
    return [part1] if rules.length == 1
    part2 = shots[rules[0], rules[1]] || []
    [part1, part2]
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

  private

  def sum_of_array(array)
    array&.inject(:+) || 0
  end
end
