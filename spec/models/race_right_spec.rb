require 'spec_helper'

describe RaceRight do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:race) }
    it { is_expected.to belong_to(:club) }
  end

  describe 'validations' do
    let(:club) { create :club }

    it 'prevent new club creation and club limitation at the same time' do
      rr = build :race_right, new_clubs: true, club: club
      expect(rr).not_to be_valid
    end

    it 'allows new club creation to be true when no club limitation' do
      rr = build :race_right, new_clubs: true, club: nil
      expect(rr).to be_valid
    end

    it 'allows new club limitation to be true when no new club creation' do
      rr = build :race_right, new_clubs: false, club: club
      expect(rr).to be_valid
    end
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