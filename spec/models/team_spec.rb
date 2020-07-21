require 'spec_helper'

describe Team do
  let(:sport) { instance_double Sport }
  let(:race) { instance_double Race }
  let(:national_record) { nil }
  let(:extra_shots) { nil }
  let(:team_competition) { instance_double TeamCompetition, race: race, sport: sport, national_record: national_record, extra_shots: extra_shots }
  let(:name) { 'The club' }
  let(:max_extra_shots) { 0 }
  let(:club_id) { 10 }
  let(:team) { Team.new team_competition, name, club_id }

  before do
    allow(team_competition).to receive(:max_extra_shots).and_return(max_extra_shots)
    team << build_competitor(1000, 97, nil, 10, [10, 9, 5, 6, 4, 11])
    team << build_competitor(900, 98, 1201, 8, [1, 10, 5, 2, 2, 3, 8])
    team << build_competitor(800, 96, 1199, 9, [9, 9, 9, 7, 0, 1, 2])
  end

  it 'provides race' do
    expect(team.race).to eql race
  end

  it 'provides team name' do
    expect(team.name).to eql name
  end

  it 'provides club_id' do
    expect(team.club_id).to eql club_id
  end

  it 'provides competitors' do
    expect(team.competitors.length).to eql 3
  end

  it 'total score is the sum of competitor points' do
    expect(team.total_score).to eql 2700
  end

  it 'best competitors score is the first competitor score' do
    expect(team.best_competitor_score).to eql 1000
  end

  it 'provides best shooting score' do
    expect(team.best_shooting_score).to eql 98
  end

  it 'provides fastest time' do
    expect(team.fastest_time).to eql 1199
  end

  it 'hits is the sum of hits' do
    expect(team.hits).to eql 27
  end

  it 'calculates sum of different shots (11 is 10) and provides so that count of tens is first' do
    expect(team.shot_counts).to eql [3, 4, 1, 1, 1, 2, 1, 1, 3, 2]
  end

  context 'when european race team' do
    let(:european_team) { Team.new team_competition, name, club_id }
    let(:competitor1) { build :competitor }

    before do
      allow(competitor1).to receive(:european_total_results).and_return([400, 200, 100, 90])
      european_team << competitor1
    end

    it 'provides results array for european' do
      expect(european_team.european_total_results).to eql [400, 200, 100, 90]
    end
  end

  context 'when european rifle' do
    let(:rifle_team) { Team.new team_competition, name, club_id, true }

    before do
      rifle_team << build_rifle_competitor(200, [200, 50, 50, 50, 50], [10, 9], [1, 2], [4, 5], [8, 8])
      rifle_team << build_rifle_competitor(190, [190, 45, 45, 50, 50], [8, 9], [10, 10], [4, 6], [7, 7])
    end

    it 'total score is total rifle score' do
      expect(rifle_team.total_score).to eql 390
    end

    it 'best competitor score is best rifle score' do
      expect(rifle_team.best_competitor_score).to eql 200
    end

    it 'provides rifle results array' do
      expect(rifle_team.european_rifle_results).to eql [200, 50, 50, 50, 50]
    end

    it 'calculates shot counts from rifle shots' do
      expect(rifle_team.shot_counts).to eql [3, 2, 3, 2, 1, 1, 2, 0, 1, 1]
    end
  end

  context 'when one of the competitors does not have shooting score yet' do
    let(:team2) { Team.new team_competition, 'Team 2', club_id }

    before do
      team2 << build_competitor(300, 570, nil, 10, [9, 9, 9, 9, 9, 9, 9, 9, 9, 9])
      team2 << build_competitor(290, nil, 1500, nil, nil)
    end

    it 'find best shooting score without crash' do
      expect(team2.best_shooting_score).to eql 570
    end

    it 'finds fastest time without crash' do
      expect(team2.fastest_time).to eql 1500
    end

    it 'hits is the sum of hits' do
      expect(team2.hits).to eql 10
    end

    it 'calculates sum of different shots' do
      expect(team2.shot_counts).to eql [0, 10, 0, 0, 0, 0, 0, 0, 0, 0]
    end
  end

  context 'when no national record defined' do
    it 'national record is not reached nor passed' do
      expect(team.national_record_passed?).to be_falsey
      expect(team.national_record_reached?).to be_falsey
    end
  end

  context 'when national record is higher than total score' do
    let(:national_record) { 2701 }

    it 'national record is not reached nor passed' do
      expect(team.national_record_passed?).to be_falsey
      expect(team.national_record_reached?).to be_falsey
    end
  end

  context 'when national record is same as total score' do
    let(:national_record) { 2700 }

    it 'national record is reached but not passed' do
      expect(team.national_record_passed?).to be_falsey
      expect(team.national_record_reached?).to be_truthy
    end
  end

  context 'when national record is higher than total score' do
    let(:national_record) { 2699 }

    it 'national record is not reached but is passed' do
      expect(team.national_record_passed?).to be_truthy
      expect(team.national_record_reached?).to be_falsey
    end
  end

  context 'when no extra shots in use' do
    it 'returns empty extra shots' do
      expect(team.extra_shots).to eql []
    end

    it 'raw extra shots is empty array' do
      expect(team.raw_extra_shots).to eql []
    end
  end

  context 'when extra shots used' do
    let(:max_extra_shots) { 3 }

    context 'and the team has them all' do
      let(:extra_shots) { [{ "club_id" => club_id + 1, "shots1" => [1] }, { "club_id" => club_id, "shots1" => [1, 0, 1], "shots2" => [] }] }

      it 'returns them as such' do
        expect(team.extra_shots).to eql [1, 0, 1]
      end

      it 'raw extra shots is same as shots' do
        expect(team.raw_extra_shots).to eql [1, 0, 1]
      end
    end

    context 'and the team is missing some of them' do
      let(:extra_shots) { [{ "club_id" => club_id, "shots1" => [], "shots2" => [1] }, { "club_id" => club_id + 1, "shots1" => [1, 0, 1] }] }

      it 'returns them filled with zeros to max extra shots' do
        expect(team.extra_shots).to eql [1, 0, 0]
      end

      it 'raw extra shots is original shots' do
        expect(team.raw_extra_shots).to eql [1]
      end
    end

    context 'but the team does not have them' do
      let(:extra_shots) { [{ "club_id" => club_id - 1, "shots1" => [1] }, { "club_id" => club_id + 1, "shots1" => [1, 0, 1] }] }

      it 'returns as many zeros as max extra shots' do
        expect(team.extra_shots).to eql [0, 0, 0]
      end

      it 'raw extra shots is empty array' do
        expect(team.raw_extra_shots).to eql []
      end
    end

    context 'and shots of both shooters saved' do
      context 'and the other has less shots' do
        let(:extra_shots) { [{ "club_id" => club_id, "shots1" => [1], "shots2" => [1, 0] }] }

        it 'returns the one with most shots' do
          expect(team.extra_shots).to eql [1, 0, 0]
        end

        it 'raw extra shots is shots of best' do
          expect(team.raw_extra_shots).to eql [1, 0]
        end

        it 'raw extra shots can be returned for worse competitor as well' do
          expect(team.raw_extra_shots(true)).to eql [1]
        end
      end

      context 'and both have the same amount of shots' do
        let(:max_extra_shots) { 4 }
        let(:extra_shots) { [{ "club_id" => club_id, "shots1" => [1, 0, 1, 1], "shots2" => [1, 0, 1, 0] }] }

        it 'returns the one with best result' do
          expect(team.extra_shots).to eql [1, 0, 1, 1]
        end

        it 'raw extra shots is shots of best' do
          expect(team.raw_extra_shots).to eql [1, 0, 1, 1]
        end
      end
    end
  end

  def build_competitor(score, shooting_score, time_in_seconds, hits, shots)
    competitor = build :competitor
    allow(competitor).to receive(:team_competition_points).with(sport, false).and_return(score)
    allow(competitor).to receive(:shooting_score).and_return(shooting_score)
    allow(competitor).to receive(:time_in_seconds).and_return(time_in_seconds)
    allow(competitor).to receive(:hits).and_return(hits)
    allow(competitor).to receive(:shots).and_return(shots)
    competitor
  end

  def build_rifle_competitor(score, european_rifle_results, rifle1_shots, rifle2_shots, rifle3_shots, rifle4_shots)
    competitor = build :competitor
    allow(competitor).to receive(:team_competition_points).with(sport, true).and_return(score)
    allow(competitor).to receive(:european_rifle_results).and_return(european_rifle_results)
    allow(competitor).to receive(:european_rifle1_shots).and_return(rifle1_shots)
    allow(competitor).to receive(:european_rifle2_shots).and_return(rifle2_shots)
    allow(competitor).to receive(:european_rifle3_shots).and_return(rifle3_shots)
    allow(competitor).to receive(:european_rifle4_shots).and_return(rifle4_shots)
    competitor
  end
end
