require 'spec_helper'

describe CompetitorsHelper do
  describe '#set_shots' do
    let(:shots_column) { :shots }
    let(:original_shots) { [10, 8, 9] }
    let(:competitor) { build :competitor, shots: original_shots }

    context 'when all shots are blank' do
      it 'sets shots to nil and returns true' do
        ret = helper.set_shots competitor, shots_column, ['', '', '']
        expect(competitor.shots).to be_nil
        expect(competitor).to have(0).errors
        expect(ret).to be_truthy
      end
    end

    context 'when all shots are non-nil' do
      it 'sets shots to given values and returns true' do
        ret = helper.set_shots competitor, shots_column, %w(10 10 5)
        expect(competitor.shots).to eql %w(10 10 5)
        expect(competitor).to have(0).errors
        expect(ret).to be_truthy
      end
    end

    context 'when shots contain blank values at the end' do
      it 'takes only non-empty values and returns true' do
        ret = helper.set_shots competitor, shots_column, ['8', '7', '10', '', '']
        expect(competitor.shots).to eql %w(8 7 10)
        expect(competitor).to have(0).errors
        expect(ret).to be_truthy
      end
    end

    context 'when shots contain blank values in the beginning' do
      it 'keeps the original shots, sets error to competitor, and returns false' do
        ret = helper.set_shots competitor, shots_column, ['', '8', '7', '10']
        expect(competitor.shots).to eql original_shots
        expect(competitor).to have(1).errors
        expect(ret).to be_falsey
      end
    end

    context 'when shots contain blank values in the middle' do
      it 'keeps the original shots, sets error to competitor, and returns false' do
        ret = helper.set_shots competitor, shots_column, ['8', '7', '', '10']
        expect(competitor.shots).to eql original_shots
        expect(competitor).to have(1).errors
        expect(ret).to be_falsey
      end
    end

    context 'when extra_shots column used' do
      it 'sets shots to extra_shots' do
        ret = helper.set_shots competitor, :extra_shots, %w(10 10 5)
        expect(competitor.extra_shots).to eql %w(10 10 5)
        expect(competitor).to have(0).errors
        expect(ret).to be_truthy
      end
    end
  end
end
