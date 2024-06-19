module CupScore
  extend ActiveSupport::Concern

  private

  def total_score(min_competitions, last_race_required)
    return nil if (last_race_required && last_race_missing?) || count_non_nil_scores < min_competitions
    sum_of_top_competitions + score_of_last_race
  end

  def last_race_missing?
    last_race_score = score_with_last_race_info_array.find {|item| item[:last_cup_race] }
    !last_race_score || !last_race_score[:score]
  end

  def count_non_nil_scores
    score_with_last_race_info_array.select { |p| p[:score] && !p[:last_cup_race] }.length
  end

  def sum_of_top_competitions
    score_with_last_race_info_array.select{|p| !p[:last_cup_race]}.map {|p| p[:score].to_i }.
      sort.reverse[0, top_competitions].inject(:+)
  end

  def score_of_last_race
    last_race = score_with_last_race_info_array.find {|p| p[:last_cup_race]}
    return 0 unless last_race
    last_race[:score].to_i
  end
end
