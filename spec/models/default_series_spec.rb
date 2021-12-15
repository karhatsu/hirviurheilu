require 'spec_helper'

describe DefaultSeries do
  describe "#initialize" do
    it "should accept name and no default age groups" do
      ds = DefaultSeries.new 'M'
      expect(ds.name).to eq 'M'
      expect(ds.default_age_groups).to eql []
    end

    it "should accept name with age group names" do
      ds = DefaultSeries.new 'S15', ['P15', 'T15']
      expect(ds.name).to eq 'S15'
      expect(ds.default_age_groups[0].name).to eql 'P15'
      expect(ds.default_age_groups[0].min_competitors).to eql 0
    end
  end

  describe ".all" do
    context 'when three sports race' do
      let(:sport) { Sport.by_key Sport::SKI }

      it "should have S13 with T13,0/P13,0 as first series" do
        ds = DefaultSeries.all(sport).first
        expect(ds.name).to eq('S13')
        expect(ds.default_age_groups[0].name).to eq('T13')
        expect(ds.default_age_groups[0].min_competitors).to eq(0)
        expect(ds.default_age_groups[1].name).to eq('P13')
        expect(ds.default_age_groups[1].min_competitors).to eq(0)
      end

      it "should have N65 with several age groups as last series" do
        ds = DefaultSeries.all(sport).last
        expect(ds.name).to eq('N65')
        expect(ds.default_age_groups.length).to eq(5)
      end
    end

    context 'when ilmahirvi' do
      let(:sport) { Sport.by_key Sport::ILMAHIRVI }

      it "should have S16 with P16/T16 as first series" do
        ds = DefaultSeries.all(sport).first
        expect(ds.name).to eq('S16')
        expect(ds.default_age_groups[0].name).to eq('T16')
        expect(ds.default_age_groups[1].name).to eq('P16')
      end

      it "should have N65 without age groups as last series" do
        ds = DefaultSeries.all(sport).last
        expect(ds.name).to eq('N65')
        expect(ds.default_age_groups.length).to eq(0)
      end
    end

    context 'when ilmaluodikko' do
      let(:sport) { Sport.by_key Sport::ILMALUODIKKO }

      it "should have S13 with P13/T13 as first series" do
        ds = DefaultSeries.all(sport).first
        expect(ds.name).to eq('S13')
        expect(ds.default_age_groups[0].name).to eq('T13')
        expect(ds.default_age_groups[1].name).to eq('P13')
      end

      it "should have N65 without age groups as last series" do
        ds = DefaultSeries.all(sport).last
        expect(ds.name).to eq('N65')
        expect(ds.default_age_groups.length).to eq(0)
      end
    end
  end
end
