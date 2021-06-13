require 'spec_helper'

describe CompetitorResults do
  context '#three_sports_race_results' do
    let(:unofficials) { nil } # same as UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME
    let(:series) { build :series }
    let(:competitor) { build :competitor, series: series }

    context 'when no result reason' do
      it 'returns array of one item with negative value' do
        expect(competitor_with_no_result_reason(Competitor::DNF).three_sports_race_results).to eql [-10000]
        expect(competitor_with_no_result_reason(Competitor::DNS).three_sports_race_results).to eql [-20000]
        expect(competitor_with_no_result_reason(Competitor::DQ).three_sports_race_results).to eql [-30000]
      end
    end

    context 'when no results yet' do
      context 'and walking series' do
        it 'returns array of official flag, zeros for points, shooting points, and different shot counts' do
          allow(series).to receive(:walking_series?).and_return(true)
          expect(competitor.three_sports_race_results(unofficials)).to eql [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        end
      end

      context 'and running series' do
        it 'returns array of official flag, zeros for points, shooting points, and time' do
          allow(series).to receive(:walking_series?).and_return(false)
          expect(competitor.three_sports_race_results(unofficials)).to eql [1, 0, 0, 0]
        end
      end
    end

    context 'when results' do
      let(:points) { 1110 }
      let(:shooting_points) { 594 }
      let(:time_in_seconds) { 630 }
      let(:estimate_points) { 255 }
      let(:shots) { [10, 9, 10, 8, 1, 5, 5, 5, 10, 1] }

      before do
        allow(competitor).to receive(:points).with(unofficials).and_return(points)
        allow(competitor).to receive(:shooting_points).and_return(shooting_points)
        allow(competitor).to receive(:time_in_seconds).and_return(time_in_seconds)
        allow(competitor).to receive(:estimate_points).and_return(estimate_points)
        allow(competitor).to receive(:shots).and_return(shots)
        allow(competitor).to receive(:unofficial?).and_return(false)
        allow(series).to receive(:walking_series?).and_return(false)
      end

      context 'for walking series' do
        before do
          allow(series).to receive(:walking_series?).and_return(true)
        end

        it 'returns array of official flag, points, shooting points, count of different shots, and flag for official competitor' do
          shot_counts_desc = [3, 1, 1, 0, 0, 3, 0, 0, 0, 2]
          expect(competitor.three_sports_race_results(unofficials)).to eql [1, points, shooting_points] + shot_counts_desc
        end
      end

      context 'for running series' do
        it 'returns array of official flag, points, shooting points, negative time in seconds, and flag for official competitor' do
          expect(competitor.three_sports_race_results(unofficials)).to eql [1, points, shooting_points, -time_in_seconds]
        end
      end

      context 'when UNOFFICIALS_EXCLUDED' do
        let(:unofficials) { Series::UNOFFICIALS_EXCLUDED }

        context 'and official competitor' do
          it 'returns with official flag' do
            expect(competitor.three_sports_race_results(unofficials)).to eql [1, points, shooting_points, -time_in_seconds]
          end
        end

        context 'and unofficial competitor' do
          before do
            allow(competitor).to receive(:unofficial?).and_return(true)
          end

          it 'returns without official flag' do
            expect(competitor.three_sports_race_results(unofficials)).to eql [0, points, shooting_points, -time_in_seconds]
          end
        end
      end
    end
  end

  context '#shooting_race_results' do
    let(:competitor) { build :competitor }
    let(:competitor2) { build :competitor }
    let(:competitors) { [competitor2, competitor] }
    let(:sport) { Sport.by_key Sport::ILMALUODIKKO }

    before do
      allow(competitor).to receive(:sport).and_return(sport)
      allow(competitor2).to receive(:extra_shots).and_return([8, 10, 7, 6, 5, 9])
    end

    context 'when no result reason' do
      it 'returns array of one item with negative value' do
        expect(competitor_with_no_result_reason(Competitor::DNF).shooting_race_results(competitors)).to eql [-10000]
        expect(competitor_with_no_result_reason(Competitor::DNS).shooting_race_results(competitors)).to eql [-20000]
        expect(competitor_with_no_result_reason(Competitor::DQ).shooting_race_results(competitors)).to eql [-30000]
      end
    end

    context 'when no shots yet' do
      it 'returns array of zeros' do
        expect(competitor.shooting_race_results(competitors)).to eql [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      end
    end

    context 'when shots' do
      let(:shooting_score) { 185 }
      let(:hits) { 19 }
      let(:final_round_score) { 97 }
      let(:second_qualification_round_sub_score) { 42 }
      let(:qualification_round_sub_scores) { [39, second_qualification_round_sub_score] }
      let(:shots) { [2, 9, 10, 11, 6, 0, 1, 10, 10, 1] }
      let(:extra_shots) { [8, 11, 10, 6] }

      before do
        allow(competitor).to receive(:shooting_score).and_return(shooting_score)
        allow(competitor).to receive(:hits).and_return(hits)
        allow(competitor).to receive(:qualification_round_sub_scores).and_return(qualification_round_sub_scores)
        allow(competitor).to receive(:shots).and_return(shots)
      end

      context 'and final round score and extra round shots available' do
        before do
          allow(competitor).to receive(:final_round_score).and_return(final_round_score)
          allow(competitor).to receive(:extra_shots).and_return(extra_shots)
        end

        context 'and 1 shot per extra round' do
          it 'returns array of shooting score, extra round filled sum, hits, final round score, 0, count of different shots (11 as 10), and shots in reverse order' do
            extra_shots_filled = [8, 11, 10, 6, 0, 0]
            expected = [shooting_score] + extra_shots_filled + [hits, final_round_score, 0, 4, 1, 0, 0, 1, 0, 0, 0, 1, 2] + shots.reverse
            expect(competitor.shooting_race_results(competitors)).to eql expected
          end
        end

        context 'and 2 shots per extra round' do
          let(:sport) { Sport.by_key Sport::ILMAHIRVI }

          it 'groups extra shots into sums of two' do
            extra_shots_filled = [19, 16, 0]
            expected = [shooting_score] + extra_shots_filled + [hits, final_round_score, 0, 4, 1, 0, 0, 1, 0, 0, 0, 1, 2] + shots.reverse
            expect(competitor.shooting_race_results(competitors)).to eql expected
          end
        end
      end

      context 'and no final round score' do
        before do
          allow(competitor).to receive(:final_round_score).and_return(nil)
          allow(competitor).to receive(:extra_shots).and_return(nil)
        end

        it 'returns array of shooting score, zeros for extra shots, hits, 0, second qualification round score, count of different shots (11 as 10), and shots in reverse order' do
          expected = [shooting_score, 0, 0, 0, 0, 0, 0, hits, 0, second_qualification_round_sub_score, 4, 1, 0, 0, 1, 0, 0, 0, 1, 2] + shots.reverse
          expect(competitor.shooting_race_results(competitors)).to eql expected
        end
      end
    end
  end

  context '#shooting_race_qualification_results' do
    let(:competitor) { build :competitor }

    context 'when no result reason' do
      it 'returns array of one item with negative value' do
        expect(competitor_with_no_result_reason(Competitor::DNF).shooting_race_qualification_results).to eql [-10000]
        expect(competitor_with_no_result_reason(Competitor::DNS).shooting_race_qualification_results).to eql [-20000]
        expect(competitor_with_no_result_reason(Competitor::DQ).shooting_race_qualification_results).to eql [-30000]
      end
    end

    context 'without no result reason' do
      let(:qualification_round_score) { 78 }
      let(:qualification_round_hits) { 9 }
      let(:second_qualification_round_sub_score) { 42 }
      let(:qualification_round_sub_scores) { [39, second_qualification_round_sub_score] }
      let(:qualification_round_shots) { [[2, 9, 10, 11, 6], [0, 1, 10, 10, 1]] }

      before do
        allow(competitor).to receive(:qualification_round_score).and_return(qualification_round_score)
        allow(competitor).to receive(:qualification_round_hits).and_return(qualification_round_hits)
        allow(competitor).to receive(:second_qualification_round_sub_score).and_return(second_qualification_round_sub_score)
        allow(competitor).to receive(:qualification_round_sub_scores).and_return(qualification_round_sub_scores)
        allow(competitor).to receive(:qualification_round_shots).and_return(qualification_round_shots)
      end

      it 'returns array of QR score, QR hits, second QR score, count of different QR shots (11 as 10), and QR shots in reverse order' do
        expected = [qualification_round_score, qualification_round_hits, second_qualification_round_sub_score, 4, 1, 0, 0, 1, 0, 0, 0, 1, 2] + qualification_round_shots.reverse
        expect(competitor.shooting_race_qualification_results).to eql expected
      end
    end
  end

  context '#nordic_total_results' do
    context 'when no result reason' do
      it 'returns array of one item with negative value' do
        expect(competitor_with_no_result_reason(Competitor::DNF).nordic_total_results).to eql [-10000]
        expect(competitor_with_no_result_reason(Competitor::DNS).nordic_total_results).to eql [-20000]
        expect(competitor_with_no_result_reason(Competitor::DQ).nordic_total_results).to eql [-30000]
      end
    end

    context 'without no result reason' do
      let(:competitor) { build :competitor }

      context 'and without results' do
        before do
          allow(competitor).to receive(:nordic_score).and_return(nil)
          allow(competitor).to receive(:nordic_extra_score).and_return(nil)
        end

        it 'returns array of two zeros' do
          expect(competitor.nordic_total_results).to eql [0, 0]
        end
      end

      context 'and with results' do
        before do
          allow(competitor).to receive(:nordic_score).and_return(350)
          allow(competitor).to receive(:nordic_extra_score).and_return(195)
        end

        it 'returns array of nordic score and extra score' do
          expect(competitor.nordic_total_results).to eql [350, 195]
        end
      end
    end
  end

  context '#nordic_sub_results' do
    context 'when no result reason' do
      it 'returns array of one item with negative value' do
        expect(competitor_with_no_result_reason(Competitor::DNF).nordic_sub_results(:trap)).to eql [-10000]
        expect(competitor_with_no_result_reason(Competitor::DNS).nordic_sub_results(:shotgun)).to eql [-20000]
        expect(competitor_with_no_result_reason(Competitor::DQ).nordic_sub_results(:rifle_moving)).to eql [-30000]
      end
    end

    context 'without no result reason' do
      let(:competitor) { build :competitor }

      context 'and without results' do
        it 'returns array of zero' do
          expect(competitor.nordic_sub_results(:trap)).to eql [0]
          expect(competitor.nordic_sub_results(:shotgun)).to eql [0]
          expect(competitor.nordic_sub_results(:rifle_moving)).to eql [0]
          expect(competitor.nordic_sub_results(:rifle_standing)).to eql [0]
        end
      end

      context 'and with results' do
        before do
          competitor.nordic_trap_score_input = 23
          competitor.nordic_trap_extra_shots = [1, 1, 0]
          competitor.nordic_shotgun_score_input = 20
          competitor.nordic_shotgun_extra_shots = [0, 1, 1, 0]
          competitor.nordic_rifle_moving_score_input = 97
          competitor.nordic_rifle_moving_extra_shots = [10, 9, 8, 9]
          competitor.nordic_rifle_standing_score_input = 100
          competitor.nordic_rifle_standing_extra_shots = [10, 10, 8, 10, 9, 10]
        end

        context 'shotgun sports' do
          it 'returns array of score and extra shots' do
            expect(competitor.nordic_sub_results(:trap)).to eql [23, 1, 1, 0]
            expect(competitor.nordic_sub_results(:shotgun)).to eql [20, 0, 1, 1, 0]
          end
        end

        context 'rifle sports' do
          it 'returns array of score and extra shots in sums of two shots' do
            expect(competitor.nordic_sub_results(:rifle_moving)).to eql [97, 19, 17]
            expect(competitor.nordic_sub_results(:rifle_standing)).to eql [100, 20, 18, 19]
          end
        end
      end
    end
  end

  describe 'european results' do
    context 'when no result reason' do
      it 'rifle returns array of one item with negative value' do
        expect(competitor_with_no_result_reason(Competitor::DNF).european_rifle_results).to eql [-10000]
        expect(competitor_with_no_result_reason(Competitor::DNS).european_rifle_results).to eql [-20000]
        expect(competitor_with_no_result_reason(Competitor::DQ).european_rifle_results).to eql [-30000]
      end

      it 'total returns array of one item with negative value' do
        expect(competitor_with_no_result_reason(Competitor::DNF).european_total_results).to eql [-10000]
        expect(competitor_with_no_result_reason(Competitor::DNS).european_total_results).to eql [-20000]
        expect(competitor_with_no_result_reason(Competitor::DQ).european_total_results).to eql [-30000]
      end
    end

    context 'without no result reason' do
      let(:competitor) { build :competitor }

      context 'and without results' do
        it 'return array of zeros' do
          expect(competitor.european_rifle_results).to eql [0, 0, 0, 0, 0, 0]
          expect(competitor.european_total_results).to eql [0, 0, 0, 0, 0, 0, 0, 0]
        end
      end

      context 'and with results' do
        context 'when shots not used' do
          before do
            competitor.european_trap_score_input = 25
            competitor.european_compak_score_input = 25
            competitor.european_rifle1_score_input = 40
            competitor.european_rifle2_score_input = 45
            competitor.european_rifle3_score_input = 50
            competitor.european_rifle4_score_input = 48
            competitor.european_rifle_extra_shots = [10, 9, 8]
            competitor.european_extra_score = 199
          end

          it 'rifle returns array of total rifle score, single scores in reverse order, 0, and extra shots' do
            expect(competitor.european_rifle_results).to eql [rifle_score, 48, 50, 45, 40, 0, 10, 9, 8]
          end

          it 'total returns array of total score, rifle score, single rifle scores in reverse order, 0, and extra score' do
            expect(competitor.european_total_results).to eql [100 + 100 + rifle_score, rifle_score, 48, 50, 45, 40, 0, 199]
          end

          def rifle_score
            40 + 45 + 50 + 48
          end
        end

        context 'when shots used' do
          before do
            competitor.european_trap_score_input = 25
            competitor.european_compak_score_input = 24
            competitor.european_rifle1_shots = [10, 10, 10, 10, 10]
            competitor.european_rifle2_shots = [10, 9, 9, 9, 9]
            competitor.european_rifle3_shots = [9, 8, 10]
            competitor.european_rifle4_shots = [10, 10]
          end

          it 'rifle returns sum of tens after the rifle sub sport scores' do
            expect(competitor.european_rifle_results).to eql [rifle_score, 20, 27, 46, 50, 9]
          end

          it 'total returns sum of tens after the rifle sub sport scores' do
            expect(competitor.european_total_results).to eql [100 + 96 + rifle_score, rifle_score, 20, 27, 46, 50, 9, 0]
          end

          def rifle_score
            50 + 46 + 27 + 20
          end
        end
      end
    end
  end

  def competitor_with_no_result_reason(no_result_reason)
    build :competitor, no_result_reason: no_result_reason
  end
end
