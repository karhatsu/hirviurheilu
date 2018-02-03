require 'spec_helper'

describe UnofficialsHelper do
  describe '#unofficials_result_rule' do
    context 'when race in year 2018 or later' do
      it 'returns UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME' do
        race = build :race, start_date: '2018-01-01'
        expect(unofficials_result_rule(race)).to eql Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME
      end
    end

    context 'when race in year 2017 or before' do
      let(:race) { build :race, start_date: '2017-12-31' }

      context 'and no all_competitors query param' do
        it 'returns UNOFFICIALS_EXCLUDED' do
          expect(unofficials_result_rule(race)).to eql Series::UNOFFICIALS_EXCLUDED
        end
      end

      context 'and all_competitors query param' do
        it 'returns UNOFFICIALS_INCLUDED_WITH_BEST_TIME' do
          params[:all_competitors] = 'true'
          expect(unofficials_result_rule(race)).to eql Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME
        end
      end
    end
  end
end
