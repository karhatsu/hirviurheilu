module CupPoints
  extend ActiveSupport::Concern

  private

  def total_points(min_competitions, last_race_required)
    return nil if (last_race_required && last_race_missing?) || count_non_nil_points < min_competitions
    sum_of_top_competitions + points_of_last_race
  end

  def last_race_missing?
    last_race_points = points_with_last_race_info_array.find {|item| item[:last_cup_race] }
    !last_race_points || !last_race_points[:points]
  end

  def count_non_nil_points
    points_with_last_race_info_array.select { |p| p[:points] && !p[:last_cup_race] }.length
  end

  def sum_of_top_competitions
    points_with_last_race_info_array.select{|p| !p[:last_cup_race]}.map {|p| p[:points].to_i }.
      sort.reverse[0, top_competitions].inject(:+)
  end

  def points_of_last_race
    last_race = points_with_last_race_info_array.find {|p| p[:last_cup_race]}
    return 0 unless last_race
    last_race[:points].to_i
  end
end
