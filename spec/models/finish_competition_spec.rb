require 'spec_helper'

describe FinishCompetition do
  let(:race) { create :race, sport_key: sport_key }
  let!(:series) { create :series, race: race }
  let!(:empty_series) { create :series, race: race, name: 'Empty series, will be deleted' }

  context 'for three sports race' do
    let(:sport_key) { Sport::SKI }

    before do
      allow(race).to receive(:each_competitor_has_correct_estimates?).and_return(true)
    end

    context "when competitors missing correct estimates" do
      before do
        expect(race).to receive(:each_competitor_has_correct_estimates?).and_return(false)
      end

      it "should not be possible to finish the race" do
        confirm_unsuccessfull_finish race, 'Osalta kilpailijoista puuttuu oikea arviomatka', []
      end
    end

    context "when competitors not missing correct estimates" do
      context "when competitors missing results" do
        let!(:competitor1) { create :competitor, series: series }
        let!(:competitor2) { create :competitor, series: series }

        it "should not be possible to finish the race" do
          confirm_unsuccessfull_finish race, 'Kaikilla kilpailjoilla ei ole tulosta', [competitor1, competitor2]
        end
      end

      context "when all competitors have results filled" do
        before do
          series.competitors << build(:competitor, series: series, no_result_reason: Competitor::DNF)
          # Counter cache is not reliable. Make sure that one is not used.
          conn = ActiveRecord::Base.connection
          conn.execute("update series set competitors_count=0 where id=#{series.id}")
          conn.execute("update series set competitors_count=1 where id=#{empty_series.id}")
        end

        it "should be possible to finish the race" do
          confirm_successfull_finish(race)
        end

        it 'should delete the series that have no competitors' do
          finish_competition = FinishCompetition.new race
          finish_competition.finish
          expect(race.reload.series.count).to eq(1)
          expect(race.series.first.name).to eq(series.name)
          confirm_successfull_finish race
        end
      end
    end
  end

  context 'for shooting race' do
    let(:sport_key) { Sport::ILMAHIRVI }

    before do
      expect(race).not_to receive(:each_competitor_has_correct_estimates?)
    end

    context 'when all competitors have enough shots and they have no result reason' do
      it 'should be possible to finish the race' do
        confirm_successfull_finish race
      end
    end

    context 'when competitors missing results' do
      let!(:competitor1) { create :competitor, series: series, shots: [10] }

      it "should not be possible to finish the race" do
        confirm_unsuccessfull_finish race, 'Kaikilla kilpailjoilla ei ole tulosta', [competitor1]
      end
    end
  end

  def confirm_successfull_finish(race)
    race.reload
    finish_competition = FinishCompetition.new race
    expect(finish_competition.can_finish?).to be_truthy
    expect(finish_competition.error).to be_nil
    finish_competition.finish
    expect(race).to be_finished
  end

  def confirm_unsuccessfull_finish(race, error, competitors_without_result)
    race.reload
    finish_competition = FinishCompetition.new race
    expect(finish_competition.can_finish?).to be_falsey
    expect(finish_competition.error).to eq error
    expect(finish_competition.competitors_without_result).to eql competitors_without_result
    expect { finish_competition.finish }.to raise_error(RuntimeError)
  end
end
