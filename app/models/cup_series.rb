class CupSeries < ApplicationRecord
  belongs_to :cup

  validates :name, :presence => true

  def series
    @series ||= pick_series_with_given_name
  end

  def has_single_series_with_same_name?
    series_names.blank? || name == series_names
  end

  def cup_competitors
    @cup_competitors ||= pick_competitors_with_same_name_in_all_races
  end

  def results
    cup_competitors.sort do |a, b|
      a_scores = a.score_array.map {|p| p.to_i}.sort {|p1, p2| p2 <=> p1}
      b_scores = b.score_array.map {|p| p.to_i}.sort {|p1, p2| p2 <=> p1}
      a_shooting_points = a.shots_array.map {|p| p.to_i}.sort {|p1, p2| p2 <=> p1}
      b_shooting_points = b.shots_array.map {|p| p.to_i}.sort {|p1, p2| p2 <=> p1}
      [b.score!.to_i, b_scores, b_shooting_points] <=> [a.score!.to_i, a_scores, a_shooting_points]
    end
  end

  def european_rifle_results
    cup_competitors.sort { |a, b| b.european_rifle_results <=> a.european_rifle_results }
  end

  private
  def pick_series_with_given_name
    series = []
    cup_races = cup.races.order(:start_date)
    race_count = cup_races.count
    cup_races.each_with_index do |race, i|
      last_cup_race = cup.include_always_last_race? && i + 1 == race_count
      race.series.where("LOWER(name) IN (?)", series_names_as_array.map(&:downcase)).each do |s|
        s.last_cup_race = last_cup_race
        series << s
      end
    end
    series
  end

  def series_names_as_array
    return series_names.split(',').map(&:strip) unless series_names.blank?
    [name]
  end

  def pick_competitors_with_same_name_in_all_races
    name_to_competitor = Hash.new
    series.each do |s|
      s.competitors.each do |competitor|
        competitor.series.last_cup_race = s.last_cup_race
        name = CupCompetitor.name(competitor)
        if name_to_competitor.has_key?(name)
          name_to_competitor[name] << competitor
        else
          name_to_competitor[name] = CupCompetitor.new(self, competitor)
        end
      end
    end
    name_to_competitor.values
  end
end
