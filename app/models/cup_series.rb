class CupSeries < ApplicationRecord
  belongs_to :cup

  validates :name, :presence => true

  def series
    @series ||= pick_series_with_given_name
  end

  def has_single_series_with_same_name?
    series_names.blank? or name == series_names
  end

  def cup_competitors
    @cup_competitors ||= pick_competitors_with_same_name_in_all_races
  end

  def ordered_competitors
    cup_competitors.sort do |a, b|
      a_points = a.points_array.map {|p| p.to_i}.sort {|p1, p2| p2 <=> p1}
      b_points = b.points_array.map {|p| p.to_i}.sort {|p1, p2| p2 <=> p1}
      a_shot_points = a.shots_array.map {|p| p.to_i}.sort {|p1, p2| p2 <=> p1}
      b_shot_points = b.shots_array.map {|p| p.to_i}.sort {|p1, p2| p2 <=> p1}
      [b.points!.to_i, b_points, b_shot_points] <=> [a.points!.to_i, a_points, a_shot_points]
    end
  end

  private
  def pick_series_with_given_name
    series = []
    cup_races = cup.races.order(:start_date)
    race_count = cup_races.count
    cup_races.each_with_index do |race, i|
      last_cup_race = cup.include_always_last_race? && i + 1 == race_count
      race.series.where(:name => series_names_as_array).each do |s|
        s.last_cup_race = last_cup_race
        series << s
      end
    end
    series
  end

  def series_names_as_array
    return series_names.strip.split(',') unless series_names.blank?
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
