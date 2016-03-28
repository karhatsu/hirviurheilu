require 'spec_helper'

describe RaceRight do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:race) }
    it { is_expected.to belong_to(:club) }
  end

  describe 'callbacks' do
    describe 'on update' do
      it 'resets club_id when full rights given' do
        club = create :club
        race_right = create :race_right, only_add_competitors: true, club: club
        race_right.only_add_competitors = false
        race_right.save!
        expect(race_right.club_id).to be_nil
      end

      it 'keeps club_id when no full rights' do
        club = create :club
        race_right = create :race_right, only_add_competitors: false
        race_right.club = club
        race_right.only_add_competitors = true
        race_right.save!
        expect(race_right.club_id).to eq(club.id)
      end
    end
  end
end