require 'spec_helper'

describe Sport do
  let(:race) { build :race }
  describe "find by key" do
    it 'RUN' do
      expect(Sport.by_key('RUN', race).name).to eq('Hirvenjuoksu')
      expect(Sport.by_key('RUN', race).qualification_round).to be_falsey
      expect(Sport.by_key('RUN', race).best_shot_value).to eql 10
    end

    it 'SKI' do
      expect(Sport.by_key('SKI', race).name).to eq('Hirvenhiihto')
      expect(Sport.by_key('SKI', race).qualification_round).to be_falsey
      expect(Sport.by_key('SKI', race).best_shot_value).to eql 10
    end

    describe 'ILMAHIRVI' do
      let(:race) { nil }
      let(:sport) { Sport.by_key('ILMAHIRVI', race) }

      it 'returns common values' do
        expect(sport.name).to eq('Ilmahirvi')
        expect(sport.best_shot_value).to eql 10
        expect(sport.inner_ten?).to eql false
      end

      context 'when race before 2022' do
        let(:race) { build :race, start_date: '2021-12-31' }

        it 'has 10 shots in qualification round' do
          expect(sport.qualification_round).to eql [10]
          expect(sport.qualification_round_shot_count).to eql 10
          expect(sport.qualification_round_max_score).to eql 100
          expect(sport.final_round).to eql [10]
          expect(sport.final_round_shot_count).to eql 10
          expect(sport.shot_count).to eql 20
        end
      end

      context 'when race 2022 or after' do
        let(:race) { build :race, start_date: '2022-01-01' }

        it 'has 20 shots in qualification round' do
          expect(sport.qualification_round).to eql [20]
          expect(sport.qualification_round_shot_count).to eql 20
          expect(sport.qualification_round_max_score).to eql 200
          expect(sport.final_round).to eql [10]
          expect(sport.final_round_shot_count).to eql 10
          expect(sport.shot_count).to eql 30
        end
      end
    end

    describe 'ILMALUODIKKO' do
      let(:sport) { Sport.by_key('ILMALUODIKKO', race) }

      it 'returns common values' do
        expect(sport.name).to eq('Ilmaluodikko')
        expect(sport.best_shot_value).to eql 11
        expect(sport.inner_ten?).to eql true
      end

      context 'when race before 2022' do
        let(:race) { build :race, start_date: '2021-12-31' }

        it 'has 5+5 shots in qualification round' do
          expect(sport.qualification_round).to eql [5, 5]
          expect(sport.qualification_round_shot_count).to eql 10
          expect(sport.qualification_round_max_score).to eql 100
          expect(sport.final_round).to eql [10]
          expect(sport.final_round_shot_count).to eql 10
          expect(sport.shot_count).to eql 20
        end
      end

      context 'when race 2022 or after' do
        let(:race) { build :race, start_date: '2022-01-01' }

        it 'has 5+5+5+5 shots in qualification round' do
          expect(sport.qualification_round).to eql [5, 5, 5, 5]
          expect(sport.qualification_round_shot_count).to eql 20
          expect(sport.qualification_round_max_score).to eql 200
          expect(sport.final_round).to eql [10]
          expect(sport.final_round_shot_count).to eql 10
          expect(sport.shot_count).to eql 30
        end
      end
    end

    it 'METSASTYSHAULIKKO' do
      expect(Sport.by_key('METSASTYSHAULIKKO', race).name).to eq('Metsästyshaulikko')
      expect(Sport.by_key('METSASTYSHAULIKKO', race).qualification_round).to eql [25]
      expect(Sport.by_key('METSASTYSHAULIKKO', race).best_shot_value).to eql 1
    end
  end

  it 'find key by name' do
    expect(Sport.key_by_name('Hirvenhiihto')).to eq Sport::SKI
    expect(Sport.key_by_name('Metsästyshaulikko')).to eq Sport::METSASTYSHAULIKKO
    expect(Sport.key_by_name('foo')).to be_nil
  end
end
