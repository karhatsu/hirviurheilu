require 'spec_helper'

describe Sport do
  describe "find by key" do
    it 'RUN' do
      expect(Sport.by_key('RUN').name).to eq('Hirvenjuoksu')
      expect(Sport.by_key('RUN').qualification_round).to be_falsey
    end

    it 'SKI' do
      expect(Sport.by_key('SKI').name).to eq('Hirvenhiihto')
      expect(Sport.by_key('SKI').qualification_round).to be_falsey
    end

    it 'ILMAHIRVI' do
      expect(Sport.by_key('ILMAHIRVI').name).to eq('Ilmahirvi')
      expect(Sport.by_key('ILMAHIRVI').qualification_round).to eql [10]
    end

    it 'ILMALUODIKKO' do
      expect(Sport.by_key('ILMALUODIKKO').name).to eq('Ilmaluodikko')
      expect(Sport.by_key('ILMALUODIKKO').qualification_round).to eql [5, 5]
    end
  end

  describe "#default_sport_key" do
    before do
      @time = Time.new
      allow(Time).to receive(:new).and_return(@time)
    end

    it "should return SKI when January" do
      allow(@time).to receive(:month).and_return(1)
      expect(Sport.default_sport_key).to eq(Sport::SKI)
    end
    it "should return SKI when February" do
      allow(@time).to receive(:month).and_return(2)
      expect(Sport.default_sport_key).to eq(Sport::SKI)
    end
    it "should return SKI when March" do
      allow(@time).to receive(:month).and_return(3)
      expect(Sport.default_sport_key).to eq(Sport::SKI)
    end
    it "should return SKI when April" do
      allow(@time).to receive(:month).and_return(4)
      expect(Sport.default_sport_key).to eq(Sport::SKI)
    end
    it "should return RUN when May" do
      allow(@time).to receive(:month).and_return(5)
      expect(Sport.default_sport_key).to eq(Sport::RUN)
    end
    it "should return RUN when June" do
      allow(@time).to receive(:month).and_return(6)
      expect(Sport.default_sport_key).to eq(Sport::RUN)
    end
    it "should return RUN when July" do
      allow(@time).to receive(:month).and_return(7)
      expect(Sport.default_sport_key).to eq(Sport::RUN)
    end
    it "should return RUN when August" do
      allow(@time).to receive(:month).and_return(8)
      expect(Sport.default_sport_key).to eq(Sport::RUN)
    end
    it "should return RUN when September" do
      allow(@time).to receive(:month).and_return(9)
      expect(Sport.default_sport_key).to eq(Sport::RUN)
    end
    it "should return RUN when October" do
      allow(@time).to receive(:month).and_return(10)
      expect(Sport.default_sport_key).to eq(Sport::RUN)
    end
    it "should return SKI when November" do
      allow(@time).to receive(:month).and_return(11)
      expect(Sport.default_sport_key).to eq(Sport::SKI)
    end
    it "should return SKI when December" do
      allow(@time).to receive(:month).and_return(12)
      expect(Sport.default_sport_key).to eq(Sport::SKI)
    end
  end
end

