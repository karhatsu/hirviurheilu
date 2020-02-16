require 'spec_helper'

describe Team do
  let(:sport) { instance_double Sport }
  let(:name) { 'The club' }
  let(:team) { Team.new sport, name }

  before do
    team << build_competitor(1000, 97, nil, 10, [10, 9, 5, 6, 4, 11])
    team << build_competitor(900, 98, 1201, 8, [1, 10, 5, 2, 2, 3, 8])
    team << build_competitor(800, 96, 1199, 9, [9, 9, 9, 7, 0, 1, 2])
  end

  it 'provides team name' do
    expect(team.name).to eql name
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

  context 'when one of the competitors does not have shooting score yet' do
    let(:team2) { Team.new sport, 'Team 2' }

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

  def build_competitor(score, shooting_score, time_in_seconds, hits, shots)
    competitor = build :competitor
    allow(competitor).to receive(:team_competition_points).with(sport).and_return(score)
    allow(competitor).to receive(:shooting_score).and_return(shooting_score)
    allow(competitor).to receive(:time_in_seconds).and_return(time_in_seconds)
    allow(competitor).to receive(:hits).and_return(hits)
    allow(competitor).to receive(:shots).and_return(shots)
    competitor
  end
end
