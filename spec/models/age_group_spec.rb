require 'spec_helper'

describe AgeGroup do
  it "should create age_group with valid attrs" do
    create(:age_group)
  end

  describe "validation" do
    it "should require name" do
      expect(build(:age_group, :name => nil)).to have(1).errors_on(:name)
    end

    describe "min_competitors" do
      it "should change nil to 0" do
        ag = create(:age_group, :min_competitors => nil)
        expect(ag.min_competitors).to eq(0)
      end

      it "should require number" do
        expect(build(:age_group, :min_competitors => 'xxx')).to have(1).errors_on(:min_competitors)
      end

      it "should require integer" do
        expect(build(:age_group, :min_competitors => 1.1)).to have(1).errors_on(:min_competitors)
      end

      it "should require non-negative number" do
        expect(build(:age_group, :min_competitors => -1)).to have(1).errors_on(:min_competitors)
      end
    end
  end

  describe "#competitors_count" do
    let(:start_date) { '2021-12-31' }

    before do
      @race = create :race, start_date: start_date
      series = create :series, race: @race
      @age_group = create :age_group, series: series
      create :competitor, series: series, age_group: @age_group # 1
      create :competitor, series: series, age_group: @age_group # 2
      create :competitor, series: series
      create :competitor, series: series, age_group: @age_group, no_result_reason: 'DNS'
      create :competitor, series: series, age_group: @age_group, no_result_reason: 'DNF' # 3
      create :competitor, series: series, age_group: @age_group, no_result_reason: 'DNF' # 4
      create :competitor, series: series, age_group: @age_group, no_result_reason: 'DQ' # 5
      create :competitor, series: series, age_group: @age_group, no_result_reason: 'DQ' # 6
      create :competitor, series: series, age_group: @age_group, unofficial: true # (7)
      @age_group.reload
    end

    context "when all competitors" do
      it "should count all competitors for the age group that started" do
        expect(@age_group.competitors_count(Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME)).to eq(7)
        expect(@age_group.competitors_count(Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)).to eq(7)
      end
    end

    context "when unofficial competitors are excluded" do
      it "should count all official competitors for the age group that started" do
        expect(@age_group.competitors_count(Series::UNOFFICIALS_EXCLUDED)).to eq(6)
      end
    end

    context 'when race is 2022 or later' do
      let(:start_date) { '2022-01-01' }

      it 'should not count competitors without result' do
        expect(@age_group.competitors_count(Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME)).to eq(3)
        expect(@age_group.competitors_count(Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME)).to eq(3)
        expect(@age_group.competitors_count(Series::UNOFFICIALS_EXCLUDED)).to eq(2)
      end
    end
  end
end
