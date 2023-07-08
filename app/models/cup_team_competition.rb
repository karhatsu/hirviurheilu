class CupTeamCompetition < ApplicationRecord
  belongs_to :cup

  validates :name, presence: true

  def team_competitions
    @team_competitions ||= pick_team_competitions_with_given_name
  end

  def cup_teams
    @cup_teams ||= pick_teams_with_same_name_in_all_races
  end

  def results
    cup_teams.sort do |a, b|
      b.points!.to_i <=> a.points!.to_i
    end
  end

  private

  def pick_team_competitions_with_given_name
    team_competitions = []
    cup_races = cup.races.order(:start_date)
    race_count = cup_races.count
    cup_races.each_with_index do |race, i|
      last_cup_race = cup.include_always_last_race? && i + 1 == race_count
      race.team_competitions.where(name: name).each do |tc|
        tc.last_cup_race = last_cup_race
        team_competitions << tc
      end
    end
    team_competitions
  end

  def pick_teams_with_same_name_in_all_races
    name_to_team = Hash.new
    team_competitions.each do |tc|
      tc.results.each do |team|
        #team.last_cup_race = tc.last_cup_race
        name = CupTeam.name team
        if name_to_team.has_key? name
          name_to_team[name] << team
        else
          name_to_team[name] = CupTeam.new self, team
        end
      end
    end
    name_to_team.values
  end
end
