require 'spec_helper'

RSpec.describe QualificationRoundBatch, type: :model do
  it 'create' do
    create :qualification_round_batch
  end

  describe 'associations' do
    it { should belong_to(:race) }
  end

  describe 'validations' do
    it_should_behave_like 'positive integer', :number, false
    it_should_behave_like 'positive integer', :track, true
    it { should validate_presence_of(:time) }

    describe 'uniqueness of number' do
      before do
        create :qualification_round_batch
      end
      it { is_expected.to validate_uniqueness_of(:number).scoped_to(:race_id) }
    end

    describe 'day' do
      it_should_behave_like 'positive integer', :day, false

      before do
        race = build :race
        allow(race).to receive(:days_count).and_return(2)
        @batch = build :batch, race: race, day: 3
      end

      it 'should not be bigger than race days count' do
        expect(@batch).to have(1).errors_on(:day)
      end
    end

    describe 'time' do
      before do
        create :qualification_round_batch
      end

      it { is_expected.to validate_uniqueness_of(:time).scoped_to(:race_id, :track, :day) }
    end
  end
end
