class CupCompetitor
  include CupScore

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

  def score
    total_score @cup_series.cup.top_competitions, @cup_series.cup.include_always_last_race?
  end

  def score!
    total_score 1, false
  end

  def score_array
    @score_array ||= score_with_last_race_info_array.map {|item| item[:score]}
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

  def min_score_to_emphasize(race_count, top_competitions, is_rifle = false)
    return nil unless race_count > top_competitions
    scores = competitors.map { |c| competitor_score c, is_rifle }
    sorted_scores = scores.filter {|p| !p.nil?}.sort {|a, b| b <=> a}
    sorted_scores[top_competitions - 1]
  end

  private
  def name(competitor)
    CupCompetitor.name(competitor)
  end

  def score_with_last_race_info_array
    @score_array_with_last_race_info ||= @competitors.map { |c|
      {
        score: competitor_score(c),
        last_cup_race: c.series.last_cup_race
      }
    }
  end

  def top_competitions
    @cup_series.cup.top_competitions
  end

  def competitor_score(competitor, is_rifle=false)
    if use_qualification_round_result?
      competitor.qualification_round_score
    elsif is_rifle
      competitor.european_rifle_score
    else
      competitor.total_score
    end
  end

  def use_qualification_round_result?
    @cup_series.cup.use_qualification_round_result?
  end
end
