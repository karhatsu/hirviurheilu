require 'spec_helper'

describe Sport do
  describe "find by key" do
    it 'RUN' do
      expect(Sport.by_key('RUN').name).to eq('Hirvenjuoksu')
      expect(Sport.by_key('RUN').qualification_round).to be_falsey
      expect(Sport.by_key('RUN').best_shot_value).to eql 10
    end

    it 'SKI' do
      expect(Sport.by_key('SKI').name).to eq('Hirvenhiihto')
      expect(Sport.by_key('SKI').qualification_round).to be_falsey
      expect(Sport.by_key('SKI').best_shot_value).to eql 10
    end

    it 'ILMAHIRVI' do
      expect(Sport.by_key('ILMAHIRVI').name).to eq('Ilmahirvi')
      expect(Sport.by_key('ILMAHIRVI').qualification_round).to eql [10]
      expect(Sport.by_key('ILMAHIRVI').best_shot_value).to eql 10
    end

    it 'ILMALUODIKKO' do
      expect(Sport.by_key('ILMALUODIKKO').name).to eq('Ilmaluodikko')
      expect(Sport.by_key('ILMALUODIKKO').qualification_round).to eql [5, 5]
      expect(Sport.by_key('ILMALUODIKKO').best_shot_value).to eql 11
    end

    it 'METSASTYSHAULIKKO' do
      expect(Sport.by_key('METSASTYSHAULIKKO').name).to eq('Metsästyshaulikko')
      expect(Sport.by_key('METSASTYSHAULIKKO').qualification_round).to eql [25]
      expect(Sport.by_key('METSASTYSHAULIKKO').best_shot_value).to eql 1
    end
  end
end
