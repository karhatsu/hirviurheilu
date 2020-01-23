require 'spec_helper'

describe Team do
  let(:sport) { instance_double Sport }
  let(:name) { 'The club' }
  let(:team) { Team.new sport, name }

  before do
    team << build_competitor(1000, 97, nil)
    team << build_competitor(900, 98, 1201)
    team << build_competitor(800, 96, 1199)
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

  def build_competitor(score, shooting_score, time_in_seconds)
    competitor = build :competitor
    allow(competitor).to receive(:team_competition_points).with(sport).and_return(score)
    allow(competitor).to receive(:shooting_score).and_return(shooting_score)
    allow(competitor).to receive(:time_in_seconds).and_return(time_in_seconds)
    competitor
  end
end
