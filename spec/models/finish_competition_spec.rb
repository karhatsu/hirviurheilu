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
      context "and competitors missing results" do
        let(:competitor1) { create :competitor, series: series }
        let(:competitor2) { create :competitor, series: series }
        let(:competitor3) { create :competitor, series: series }
        let(:competitor4) { create :competitor, series: series }

        context 'and no competitor actions' do
          it "should not be possible to finish the race" do
            competitors_without_result = [competitor1, competitor2, competitor3, competitor4]
            confirm_unsuccessfull_finish race, 'Kaikilla kilpailjoilla ei ole tulosta', competitors_without_result
          end
        end

        context 'and competitor actions for competitors without result' do
          it 'does the actions and finishes the race' do
            actions = [
                { competitor_id: competitor1.id, action: FinishCompetition::ACTION_DNS },
                { competitor_id: competitor2.id, action: FinishCompetition::ACTION_DNF },
                { competitor_id: competitor3.id, action: FinishCompetition::ACTION_DQ },
                { competitor_id: competitor4.id, action: FinishCompetition::ACTION_DELETE },
            ]
            finish_competition = FinishCompetition.new race, actions
            expect(finish_competition.can_finish?).to be_truthy
            expect(finish_competition.error).to be_nil
            finish_competition.finish
            expect(race).to be_finished
            expect(competitor1.reload.no_result_reason).to eql Competitor::DNS
            expect(competitor2.reload.no_result_reason).to eql Competitor::DNF
            expect(competitor3.reload.no_result_reason).to eql Competitor::DQ
            expect(Competitor.where(id: competitor4.id).count).to eql 0
          end
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

      context 'when one competitor was missing result but it was filled in another browser tab' do
        let(:competitor) { create :competitor, series: series, estimate1: 100, estimate2: 150, shooting_score_input: 99,
                                  start_time: '00:00:00', arrival_time: '00:10:00' }

        it 'does not anything to the no result reason field' do
          actions = [{ competitor_id: competitor.id, action: FinishCompetition::ACTION_COMPLETE }]
          finish_competition = FinishCompetition.new race, actions
          finish_competition.finish
          expect(race).to be_finished
          expect(competitor.reload.no_result_reason).to be_nil
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
      let!(:competitor1) { create :competitor, series: series, shots: 20.times.map {|_| 10} }
      let!(:competitor2) { create :competitor, series: series, shots: 10.times.map {|_| 10} }

      it 'should be possible to finish the race' do
        confirm_successfull_finish race
      end

      it 'finishes also the series' do
        finish_competition = FinishCompetition.new race
        finish_competition.finish
        expect(series.reload.finished).to be_truthy
      end
    end

    context 'when competitors missing results' do
      let!(:competitor1) { create :competitor, series: series, shots: [10] }

      it "should not be possible to finish the race" do
        confirm_unsuccessfull_finish race, 'Kaikilla kilpailjoilla ei ole tulosta', [competitor1]
      end
    end
  end

  context 'for three sports series' do
    let(:sport_key) { Sport::SKI }

    it 'raises error on init' do
      expect{ FinishCompetition.new(series) }.to raise_error(RuntimeError)
    end
  end

  context 'for shooting race series' do
    let(:sport_key) { Sport::ILMALUODIKKO }

    before do
      expect(race).not_to receive(:each_competitor_has_correct_estimates?)
    end

    context 'when all competitors have enough shots and they have no result reason' do
      let!(:competitor1) { create :competitor, series: series, shots: 20.times.map {|_| 10} }

      context 'and no other unfinished series with competitors' do
        let(:series2) { create :series, race: race, finished: true }
        let!(:competitor2) { create :competitor, series: series2, shots: 10.times.map {|_| 10} }
        let!(:series3) { create :series, race: race }

        it 'should be possible to finish the series' do
          confirm_successfull_finish series
        end

        it 'marks also the race finished and deletes series without competitors' do
          finish_competition = FinishCompetition.new series
          finish_competition.finish
          expect(race.reload).to be_finished
          expect(Series.where(id: series3.id).count).to eql 0
        end
      end

      context 'and other unfinished series in the race' do
        let(:series2) { create :series, race: race, finished: false }
        let!(:competitor2) { create :competitor, series: series2 }
        let!(:series3) { create :series, race: race }

        it 'should be possible to finish the series' do
          confirm_successfull_finish series
        end

        it 'does not mark race as finished and does not delete other series' do
          finish_competition = FinishCompetition.new series
          finish_competition.finish
          expect(race.reload).not_to be_finished
          expect(Series.where(id: series3.id).count).to eql 1
        end
      end
    end

    context 'when competitors missing results' do
      let!(:competitor1) { create :competitor, series: series, shots: [10] }

      it "should not be possible to finish the series" do
        confirm_unsuccessfull_finish series, 'Kaikilla kilpailjoilla ei ole tulosta', [competitor1]
      end
    end
  end

  def confirm_successfull_finish(competition)
    competition.reload
    finish_competition = FinishCompetition.new competition
    expect(finish_competition.can_finish?).to be_truthy
    expect(finish_competition.error).to be_nil
    finish_competition.finish
    expect(competition).to be_finished
  end

  def confirm_unsuccessfull_finish(competition, error, competitors_without_result)
    competition.reload
    finish_competition = FinishCompetition.new competition
    expect(finish_competition.can_finish?).to be_falsey
    expect(finish_competition.error).to eq error
    expect(finish_competition.competitors_without_result).to eql competitors_without_result
    expect { finish_competition.finish }.to raise_error(RuntimeError)
  end
end
