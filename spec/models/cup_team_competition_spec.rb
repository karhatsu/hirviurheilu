require 'spec_helper'

RSpec.describe CupTeamCompetition, type: :model do
  it 'create' do
    create :cup_team_competition
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
