class CupCompetitor
  include CupPoints

  def initialize(cup_series, competitor)
    @cup_series = cup_series
    @competitors = [competitor]
  end

  def first_name
    @competitors.first.first_name
  end

  def last_name
    @competitors.first.last_name
  end

  def series_name
    @competitors.first.series.name
  end

  def series_names
    @competitors.map {|cc| cc.series.name}.uniq.join(', ')
  end

  def club_name
    @competitors.first.club.name
  end

  def <<(competitor)
    raise "Competitor name (#{name(competitor)}) should be #{name(self)}" unless name(competitor) == name(self)
    @competitors << competitor
  end

  def competitors
    @competitors
  end

  def competitor_for_race(race)
    @competitors.select { |c| c.race == race }.first
  end

  def points
    total_points @cup_series.cup.top_competitions, @cup_series.cup.include_always_last_race?
  end

  def points!
    total_points 1, false
  end

  def points_array
    @points_array ||= points_with_last_race_info_array.map {|item| item[:points]}
  end

  def shots_array
    @shots_array ||= @competitors.map { |c| c.shooting_points }
  end

  def european_rifle_score
    @competitors.map { |c| c.european_rifle_score.to_i }.inject(:+)
  end

  def european_rifle_results
    results = []
    @competitors.each do |competitor|
      competitor.european_rifle_results.each_with_index do |value, i|
        break if value < 0
        results[i] = results[i].to_i + value
      end
    end
    results
  end

  def self.name(competitor)
    "#{competitor.last_name.strip} #{competitor.first_name.strip}".downcase
  end

  def min_points_to_emphasize(race_count, top_competitions, is_rifle = false)
    return nil unless race_count > top_competitions
    points = competitors.map { |c| competitor_points c, is_rifle }
    sorted_points = points.filter {|p| !p.nil?}.sort {|a, b| b <=> a}
    sorted_points[top_competitions - 1]
  end

  private
  def name(competitor)
    CupCompetitor.name(competitor)
  end

  def points_with_last_race_info_array
    @points_array_with_last_race_info ||= @competitors.map { |c|
      {
        points: competitor_points(c),
        last_cup_race: c.series.last_cup_race
      }
    }
  end

  def top_competitions
    @cup_series.cup.top_competitions
  end

  def competitor_points(competitor, is_rifle=false)
    if use_qualification_round_result?
      competitor.qualification_round_score
    elsif is_rifle
      competitor.european_rifle_score
    else
      competitor.points
    end
  end

  def use_qualification_round_result?
    @cup_series.cup.use_qualification_round_result?
  end
end
