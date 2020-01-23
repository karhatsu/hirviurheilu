require 'spec_helper'

describe CompetitorResults do
  context '#three_sports_race_results' do
    let(:unofficials) { nil } # same as UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME
    let(:series) { build :series }
    let(:competitor) { build :competitor, series: series }

    context 'when no result reason' do
      it 'returns array of one time with negative value' do
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

      context 'and sort by shots' do
        it 'returns array of zero' do
          expect(competitor.three_sports_race_results(unofficials, Competitor::SORT_BY_SHOTS)).to eql [0]
        end
      end

      context 'and sort by estimates' do
        it 'returns array of zero' do
          expect(competitor.three_sports_race_results(unofficials, Competitor::SORT_BY_ESTIMATES)).to eql [0]
        end
      end

      context 'and sort by time' do
        it 'returns array of zero' do
          expect(competitor.three_sports_race_results(unofficials, Competitor::SORT_BY_TIME)).to eql [0]
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

      context 'and sort by shots' do
        it 'returns array with shooting points' do
          expect(competitor.three_sports_race_results(unofficials, Competitor::SORT_BY_SHOTS)).to eql [shooting_points]
        end
      end

      context 'and sort by estimates' do
        it 'returns array with estimate points' do
          expect(competitor.three_sports_race_results(unofficials, Competitor::SORT_BY_ESTIMATES)).to eql [estimate_points]
        end
      end

      context 'and sort by time' do
        it 'returns array with negative time' do
          expect(competitor.three_sports_race_results(unofficials, Competitor::SORT_BY_TIME)).to eql [-time_in_seconds]
        end
      end
    end
  end

  context '#shooting_race_results' do
    let(:competitor) { build :competitor }
    let(:competitor2) { build :competitor }
    let(:competitors) { [competitor2, competitor] }

    before do
      allow(competitor2).to receive(:extra_round_shots).and_return([8, 10, 7, 6, 5])
    end

    context 'when no result reason' do
      it 'returns array of one time with negative value' do
        expect(competitor_with_no_result_reason(Competitor::DNF).shooting_race_results(competitors)).to eql [-10000]
        expect(competitor_with_no_result_reason(Competitor::DNS).shooting_race_results(competitors)).to eql [-20000]
        expect(competitor_with_no_result_reason(Competitor::DQ).shooting_race_results(competitors)).to eql [-30000]
      end
    end

    context 'when no shots yet' do
      it 'returns array of zeros' do
        expect(competitor.shooting_race_results(competitors)).to eql [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      end
    end

    context 'when shots' do
      let(:shooting_score) { 185 }
      let(:hits) { 19 }
      let(:final_round_score) { 97 }
      let(:second_qualification_round_sub_score) { 42 }
      let(:qualification_round_sub_scores) { [39, second_qualification_round_sub_score] }
      let(:shots) { [2, 9, 10, 11, 6, 0, 1, 10, 10, 1] }
      let(:extra_round_shots) { [8, 11] }

      before do
        allow(competitor).to receive(:shooting_score).and_return(shooting_score)
        allow(competitor).to receive(:hits).and_return(hits)
        allow(competitor).to receive(:qualification_round_sub_scores).and_return(qualification_round_sub_scores)
        allow(competitor).to receive(:shots).and_return(shots)
      end

      context 'and final round score and extra round shots available' do
        before do
          allow(competitor).to receive(:final_round_score).and_return(final_round_score)
          allow(competitor).to receive(:extra_round_shots).and_return(extra_round_shots)
        end

        it 'returns array of shooting score, extra round filled sum, hits, final round score, 0, count of different shots (11 as 10), and shots in reverse order' do
          extra_round_filled_sum = [8, 11, 12, 12, 12].inject(:+)
          expected = [shooting_score, extra_round_filled_sum, hits, final_round_score, 0, 4, 1, 0, 0, 1, 0, 0, 0, 1, 2] + shots.reverse
          expect(competitor.shooting_race_results(competitors)).to eql expected
        end
      end

      context 'and no final round score' do
        before do
          allow(competitor).to receive(:final_round_score).and_return(nil)
          allow(competitor).to receive(:extra_round_shots).and_return(nil)
        end

        it 'returns array of shooting score, 0, hits, 0, second qualification round score, count of different shots (11 as 10), and shots in reverse order' do
          expected = [shooting_score, 0, hits, 0, second_qualification_round_sub_score, 4, 1, 0, 0, 1, 0, 0, 0, 1, 2] + shots.reverse
          expect(competitor.shooting_race_results(competitors)).to eql expected
        end
      end
    end
  end

  context '#shooting_race_team_results' do
    let(:competitor) { build :competitor }

    context 'when no result reason' do
      it 'returns array of one time with negative value' do
        expect(competitor_with_no_result_reason(Competitor::DNF).shooting_race_team_results).to eql [-10000]
        expect(competitor_with_no_result_reason(Competitor::DNS).shooting_race_team_results).to eql [-20000]
        expect(competitor_with_no_result_reason(Competitor::DQ).shooting_race_team_results).to eql [-30000]
      end
    end

    context 'without no result reason' do
      let(:normal_results) { [150, 80, 0, 5] }
      let(:qualification_round_score) { 78 }

      before do
        allow(competitor).to receive(:shooting_race_results).with([]).and_return(normal_results)
        allow(competitor).to receive(:qualification_round_score).and_return(qualification_round_score)
      end

      it 'returns qualification round score prepended to the normal results' do
        expect(competitor.shooting_race_team_results).to eql [qualification_round_score] + normal_results
      end
    end
  end

  def competitor_with_no_result_reason(no_result_reason)
    build :competitor, no_result_reason: no_result_reason
  end
end
