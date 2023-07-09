require 'spec_helper'

describe CupTeam do
  let(:name) { 'The Team' }
  let(:team_competition_name) { 'Team Competition' }

  before do
    @cup = double Cup, include_always_last_race?: false
    @ctc = double CupTeamCompetition, cup: @cup, name: 'Women'
    @team = valid_team
    @ct = CupTeam.new @ctc, @team
  end

  describe "#name" do
    it "should be the name of the first team" do
      expect(@ct.name).to eq(@team.name)
    end
  end

  describe "#team_competition_name" do
    it "should be the name of the team competition of the first competitor" do
      expect(@ct.team_competition_name).to eq(team_competition_name)
    end
  end

  describe "#team_competition_names" do
    it "should be the unique names of all team competitions" do
      tc1 = instance_double TeamCompetition, name: 'Men'
      expect(@team).to receive(:team_competition).and_return(tc1)
      tc2 = instance_double(TeamCompetition, name: 'Women')
      team2 = valid_team
      expect(team2).to receive(:team_competition).and_return(tc2)
      @ct << team2
      tc3 = instance_double(TeamCompetition, name: 'Young people')
      team3 = valid_team
      expect(team3).to receive(:team_competition).and_return(tc3)
      @ct << team3
      expect(@ct.team_competition_names).to eq('Men, Women, Young people')
    end
  end

  describe "other teams" do
    it "should accept other teams when their name is the same as the first one's" do
      @ct << valid_team
      expect(@ct.teams.length).to eq(2)
    end

    it "should not accept another competitor when names differs" do
      expect { @ct << instance_double(Team, name: 'Other') }.to raise_error(RuntimeError)
      expect(@ct.teams.length).to eq(1)
    end
  end

  describe 'points calculation' do
    context 'when the last race is not necessarily included to the results' do
      before do
        @team2 = valid_team
        @team3 = valid_team
        @ct << @team2
        @ct << @team3
        allow(@cup).to receive(:top_competitions).and_return(3)
      end

      context 'when no points available in any of the competitions' do
        before do
          allow(@team).to receive(:total_score).and_return(nil)
          allow(@team2).to receive(:total_score).and_return(nil)
          allow(@team3).to receive(:total_score).and_return(nil)
        end

        it '#points should be nil' do
          expect(@ct.points).to be_nil
        end

        it '#points! should be nil' do
          expect(@ct.points!).to be_nil
        end
      end

      context 'when points available only in some of the competitions' do
        context 'but in less than top competitions' do
          before do
            allow(@team).to receive(:total_score).and_return(3000)
            allow(@team2).to receive(:total_score).and_return(nil)
            allow(@team3).to receive(:total_score).and_return(4100)
          end

          it '#points should be nil' do
            expect(@ct.points).to be_nil
          end

          it '#points! should be sum of those that have points' do
            expect(@ct.points!).to eq(3000 + 0 + 4100)
          end
        end

        context 'and in at least top competitions' do
          before do
            allow(@team).to receive(:total_score).and_return(3000)
            allow(@team2).to receive(:total_score).and_return(nil)
            allow(@team3).to receive(:total_score).and_return(4100)
            allow(@cup).to receive(:top_competitions).and_return(2)
          end

          it '#points should be sum of those that have points' do
            expect(@ct.points).to eq(3000 + 0 + 4100)
          end

          it '#points! should be sum of those that have points' do
            expect(@ct.points!).to eq(3000 + 0 + 4100)
          end
        end
      end

      context 'when points available in all the competitions' do
        before do
          allow(@team).to receive(:total_score).and_return(3000)
          allow(@team2).to receive(:total_score).and_return(4000)
          allow(@team3).to receive(:total_score).and_return(5000)
        end

        context 'and when all competitions matter' do
          before do
            allow(@cup).to receive(:top_competitions).and_return(3)
          end

          it '#points should be sum of points in individual competitions' do
            expect(@ct.points).to eq(3000 + 4000 + 5000)
          end

          it '#points! should be sum of points in individual competitions when all competitions matter' do
            expect(@ct.points!).to eq(3000 + 4000 + 5000)
          end
        end

        context 'and when top two of all three matter' do
          before do
            allow(@cup).to receive(:top_competitions).and_return(2)
          end

          it '#points should be sum of top two points in individual competitions' do
            expect(@ct.points).to eq(4000 + 5000)
          end

          it '#points! should be sum of top two points in individual competitions when top two of them matter' do
            expect(@ct.points!).to eq(4000 + 5000)
          end
        end
      end
    end

    context 'when the last race is always included to the results' do
      before do
        @team = valid_team false
        @team2 = valid_team false
        @team3 = valid_team false
        @team4 = valid_team true
        @ct = CupTeam.new @ctc, @team
        @ct << @team2
        @ct << @team3
        @ct << @team4
        allow(@cup).to receive(:top_competitions).and_return(2)
        allow(@cup).to receive(:include_always_last_race?).and_return(true)
        allow(@team).to receive(:total_score).and_return(1000)
        allow(@team2).to receive(:total_score).and_return(2000)
        allow(@team3).to receive(:total_score).and_return(3000)
      end

      context 'and points not available for the last race' do
        before do
          allow(@team4).to receive(:total_score).and_return(nil)
        end

        it '#points returns nil' do
          expect(@ct.points).to be_nil
        end

        it '#points! returns sum of points in top competitions' do
          expect(@ct.points!).to eq(2000+3000)
        end
      end

      context 'and points available for the last race' do
        before do
          allow(@team4).to receive(:total_score).and_return(500)
        end

        it '#points return the points of last race and sum of points in top competitions' do
          expect(@ct.points).to eq(500+2000+3000)
        end

        it '#points! return the points of last race and sum of points in top competitions' do
          expect(@ct.points).to eq(500+2000+3000)
        end
      end
    end
  end

  describe "#team_for_race" do
    before do
      allow(@team).to receive(:race).and_return(instance_double(Race))
    end

    it "should be nil when no match" do
      expect(@ct.team_for_race(build(:race))).to be_nil
    end

    it "should be the team that belongs to the given race" do
      team = valid_team
      race = build(:race)
      allow(team).to receive(:race).and_return(race)
      @ct << team
      expect(@ct.team_for_race(race)).to eq(team)
    end
  end

  describe ".name for team" do
    it "should be team name in lower case" do
      team = instance_double Team, name: 'Team'
      expect(CupTeam.name(team)).to eq('team')
    end

    it "should trim spaces" do
      team = instance_double Team, name: ' The team  '
      expect(CupTeam.name(team)).to eq('the team')
    end
  end

  def valid_team(last_cup_race=false)
    team_competition = instance_double TeamCompetition, name: team_competition_name, last_cup_race: last_cup_race, sport: Sport.by_key(Sport::RUN, last_cup_race)
    club_id = 123
    Team.new team_competition, name, club_id
  end

  describe '#min_points_to_emphasize' do
    let(:team_name) { 'Team name' }
    let(:cup_team_competition) { build :cup_team_competition }
    let(:team_competition) { build :team_competition }
    let(:team) { build_team(1000) }
    let(:cup_team) { CupTeam.new cup_team_competition, team }

    context 'when race count is less than top competitions count' do
      it 'returns nil' do
        expect(cup_team.min_points_to_emphasize(1, 2)).to be_nil
      end
    end

    context 'when race count equals top competitions count' do
      before do
        cup_team << build_team(500)
      end

      it 'returns nil' do
        expect(cup_team.min_points_to_emphasize(2, 2)).to be_nil
      end
    end

    context 'when race count is bigger than top competitions count' do
      let(:race_count) { 3 }
      let(:top_competitions) { 2 }

      context 'but not enough team results compared to min competitions' do
        before do
          cup_team << build_team(nil)
        end

        it 'returns nil' do
          expect(cup_team.min_points_to_emphasize(race_count, top_competitions)).to be_nil
        end
      end

      context 'and enough cup team results compared to min competitions' do
        before do
          cup_team << build_team(449)
          cup_team << build_team(450)
        end

        it 'returns the smallest points that are counted to the total result' do
          expect(cup_team.min_points_to_emphasize(race_count, top_competitions)).to eql 450
        end
      end
    end

    def build_team(total_score)
      cup_team = double Team
      allow(cup_team).to receive(:name).and_return(team_name)
      allow(cup_team).to receive(:total_score).and_return(total_score)
      cup_team
    end
  end
end
