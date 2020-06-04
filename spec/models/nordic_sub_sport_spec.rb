require 'spec_helper'

describe NordicSubSport do
  describe "find by key" do
    it 'provides config values as methods' do
      expect(NordicSubSport.by_key(:trap).best_shot_value).to eql 1
      expect(NordicSubSport.by_key(:shotgun).shot_count).to eql 25
      expect(NordicSubSport.by_key(:rifle_moving).shots_per_extra_round).to eql 2
      expect(NordicSubSport.by_key(:rifle_standing).best_shot_value).to eql 10
    end
  end
end
