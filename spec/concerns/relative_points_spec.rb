require 'spec_helper'

describe RelativePoints do
  context 'when estimates, time and shooting' do
    let(:sport) { double Sport, only_shooting: false }

    describe "#relative_points" do
      let(:series) { double Series, walking_series?: true }
      let(:dq) { create_competitor(1200, 600, 60*1, Competitor::DQ) }
      let(:dns) { create_competitor(1200, 600, 60*1, Competitor::DNS) }
      let(:dnf) { create_competitor(1200, 600, 60*1, Competitor::DNF) }
      let(:unofficial_1) { create_competitor(1200, 600, 60*5, nil, true) }
      let(:unofficial_2) { create_competitor(1199, 600, 60*5, nil, true) }
      let(:unofficial_3) { create_competitor(1199, 599, 60*5-2, nil, true) }
      let(:unofficial_4) { create_competitor(1199, 599, 60*5-1, nil, true) }
      let(:no_result) { create_competitor(nil, nil, nil) }
      let(:points_1) { create_competitor(1100, 500, 60*20) }
      let(:points_2_shots_1) { create_competitor(1000, 600, 60*20) }
      let(:points_2_shots_2) { create_competitor(1000, 594, 60*20) }
      let(:points_3_time_1) { create_competitor(900, 600, 60*15-1) }
      let(:points_3_time_2) { create_competitor(900, 600, 60*15) }
      let(:points_4_individual_shots_1) { create_competitor(800, 500, 60*20, nil, false, [10,10,10,10,10,10,9,9,9,6]) }
      let(:points_4_individual_shots_2) { create_competitor(800, 500, 60*20, nil, false, [10,10,10,10,10,10,9,9,8,7]) }
      let(:points_4_individual_shots_3) { create_competitor(800, 500, 60*20, nil, false, [10,10,10,10,10,10,9,8,8,8]) }
      let(:competitors_in_random_order) { [unofficial_1, points_3_time_1, dns, points_1, unofficial_4,
                                           unofficial_3, unofficial_2, dq, points_2_shots_1, no_result,
                                           points_3_time_2, points_2_shots_2, points_4_individual_shots_2,
                                           points_4_individual_shots_1, dnf, points_4_individual_shots_3].shuffle }

      it 'should rank best points, best shots points, best time, individual shots, unofficials, DNF, DNS, DQ' do
        expected_order = [dq, dns, dnf, no_result, points_4_individual_shots_3, points_4_individual_shots_2,
                          points_4_individual_shots_1, points_3_time_2, points_3_time_1, points_2_shots_2,
                          points_2_shots_1, points_1, unofficial_4, unofficial_3, unofficial_2, unofficial_1]
        # Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME = default
        expect_relative_points_order competitors_in_random_order, expected_order
      end

      it 'should rank best points, best shots points, best time, individual shots, unofficials, DNF, DNS, DQ' do
        expected_order = [dq, dns, dnf, no_result, unofficial_4, unofficial_3, unofficial_2, unofficial_1,
                          points_4_individual_shots_3, points_4_individual_shots_2, points_4_individual_shots_1,
                          points_3_time_2, points_3_time_1, points_2_shots_2, points_2_shots_1, points_1]
        expect_relative_points_order competitors_in_random_order, expected_order, Series::UNOFFICIALS_EXCLUDED
      end

      it 'should rank unofficial competitors among others when all competitors wanted' do
        expected_order = [dq, dns, dnf, no_result, points_4_individual_shots_3, points_4_individual_shots_2,
                          points_4_individual_shots_1, points_3_time_2, points_3_time_1, points_2_shots_2,
                          points_2_shots_1, points_1, unofficial_4, unofficial_3, unofficial_2, unofficial_1]
        expect_relative_points_order competitors_in_random_order, expected_order, Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME
      end

      it 'yet another test' do
        allow(series).to receive(:walking_series?).and_return(false)
        c1 = create_competitor(927, 6*91, 60*53+6)
        c2 = create_competitor(928, 6*67, 60*37+15)
        expect_relative_points_order [c2, c1], [c1, c2]
      end

      describe 'when walking series' do
        before do
          allow(series).to receive(:walking_series?).and_return(true)
        end

        it 'should make a difference between individual shots' do
          expect(points_4_individual_shots_1.relative_points).to be > points_4_individual_shots_2.relative_points
          expect(points_4_individual_shots_2.relative_points).to be > points_4_individual_shots_3.relative_points
        end

        it 'should not matter if shots have been saved individually or as one number' do
          c1 = create_competitor(1074, 6*84, 0, nil, false, [10, 10, 10, 9, 9, 8, 8, 8, 7, 5])
          c2 = create_competitor(1074, 6*85, 0)
          expect_relative_points_order [c2, c1], [c1, c2]
        end
      end

      describe 'when not walking series' do
        it 'should not make difference between individual shots' do
          allow(series).to receive(:walking_series?).and_return(false)
          expect(points_4_individual_shots_1.relative_points).to eql points_4_individual_shots_2.relative_points
          expect(points_4_individual_shots_2.relative_points).to eql points_4_individual_shots_3.relative_points
        end
      end

      describe 'by shots' do
        let(:sort_by) { Competitor::SORT_BY_SHOTS }

        it 'returns shot points for competitors with result' do
          competitors_in_random_order.each do |competitor|
            unless competitor.no_result_reason
              expect(competitor.relative_points(false, sort_by)).to eq(competitor.shooting_points.to_i)
              expect(competitor.relative_points(true, sort_by)).to eq(competitor.shooting_points.to_i)
            end
          end
        end

        it 'handles DNF, DNS, DQ as usual' do
          some_competitors = [dns, unofficial_3, no_result, dq, dnf, points_2_shots_2]
          expected_order = [dq, dns, dnf, no_result, points_2_shots_2, unofficial_3]
          expect_relative_points_order some_competitors, expected_order, Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, sort_by
          expect_relative_points_order some_competitors, expected_order, Series::UNOFFICIALS_EXCLUDED, sort_by
        end
      end

      describe 'by estimates' do
        let(:sort_by) { Competitor::SORT_BY_ESTIMATES }

        it 'returns estimate points for competitors with result' do
          competitors_in_random_order.each do |competitor|
            unless competitor.no_result_reason
              expect(competitor.relative_points(false, sort_by)).to eq(competitor.estimate_points.to_i)
              expect(competitor.relative_points(true, sort_by)).to eq(competitor.estimate_points.to_i)
            end
          end
        end

        it 'handles DNF, DNS, DQ as usual' do
          some_competitors = [dns, no_result, dq, dnf, points_2_shots_2]
          expected_order = [dq, dns, dnf, no_result, points_2_shots_2]
          expect_relative_points_order some_competitors, expected_order, Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, sort_by
        end
      end

      describe 'by time' do
        let(:sort_by) { Competitor::SORT_BY_TIME }

        it 'returns negative time in seconds for competitors with result' do
          competitors_in_random_order.each do |competitor|
            unless competitor.no_result_reason || competitor.time_in_seconds.nil?
              expect(competitor.relative_points(false, sort_by)).to eq(-competitor.time_in_seconds.to_i)
              expect(competitor.relative_points(true, sort_by)).to eq(-competitor.time_in_seconds.to_i)
            end
          end
        end

        it 'handles DNF, DNS, DQ as usual; does not set nil time to the top' do
          some_competitors = [no_result, dns, points_3_time_1, dq, dnf, points_3_time_2]
          expected_order = [dq, dns, dnf, no_result, points_3_time_2, points_3_time_1]
          expect_relative_points_order some_competitors, expected_order, Series::UNOFFICIALS_EXCLUDED, sort_by
          expect_relative_points_order some_competitors, expected_order, Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, sort_by
        end
      end

      def create_competitor(points, shooting_points, time_in_seconds, no_result_reason=nil, unofficial=false,
                            shots=[0,0,0,0,0,0,0,0,0,0])
        competitor = build :competitor
        allow(competitor).to receive(:sport).and_return(sport)
        allow(competitor).to receive(:series).and_return(series)
        allow(competitor).to receive(:no_result_reason).and_return(no_result_reason)
        allow(competitor).to receive(:points).and_return(points)
        allow(competitor).to receive(:shooting_points).and_return(shooting_points)
        allow(competitor).to receive(:time_in_seconds).and_return(time_in_seconds)
        allow(competitor).to receive(:unofficial?).and_return(unofficial)
        allow(competitor).to receive(:estimate_points).and_return(550)
        allow(competitor).to receive(:shots).and_return(shots)
        competitor
      end

      def expect_relative_points_order(competitors, expected_order, unofficials=Series::UNOFFICIALS_INCLUDED_WITHOUT_BEST_TIME, sort_by=nil)
        expect(competitors.map {|c|c.relative_points(unofficials, sort_by)}.sort)
            .to eq(expected_order.map {|c|c.relative_points(unofficials, sort_by)})
      end
    end

    describe '#relative_shooting_points' do
      context 'when no shots' do
        it 'returns 0' do
          expect(build(:competitor).send(:relative_shooting_points)).to eq 0
        end
      end

      context 'when shots' do
        it 'multiplies each shot by its value' do
          competitor = create :competitor, shots: [10, 10, 8, 7, 3, 3]
          expect(competitor.reload.send(:relative_shooting_points)).to eq(2*10*10 + 8*8 + 7*7 + 2*3*3)
        end
      end
    end
  end

  context 'when only shooting' do
    let(:sport) { double Sport, only_shooting: true }

    it '1. shooting score' do
      competitor1 = build_competitor 97
      competitor2 = build_competitor 98
      competitor3 = build_competitor 96
      expect(competitor2.relative_points).to be > competitor1.relative_points
      expect(competitor1.relative_points).to be > competitor3.relative_points
    end

    it '2. count of hits' do
      competitor1 = build_competitor 90, 9
      competitor2 = build_competitor 90, 8
      competitor3 = build_competitor 89, 13
      expect(competitor1.relative_points).to be > competitor2.relative_points
      expect(competitor1.relative_points).to be > competitor3.relative_points
    end

    it '3. final round score' do
      competitor1 = build_competitor 90, 10, 49
      competitor2 = build_competitor 90, 10, 50
      competitor3 = build_competitor 90, 10, 51
      expect(competitor3.relative_points).to be > competitor2.relative_points
      expect(competitor2.relative_points).to be > competitor1.relative_points
    end

    context 'when two phase qualification round and no results from final round' do
      it '4. second qualification phase score' do
        competitor1 = build_competitor 90, 10, 0, [], [50, 40]
        competitor2 = build_competitor 90, 10, 0, [], [49, 41]
        competitor3 = build_competitor 90, 10, 0, [], [51, 39]
        expect(competitor2.relative_points).to be > competitor1.relative_points
        expect(competitor1.relative_points).to be > competitor3.relative_points
      end
    end

    context 'when two phase qualification round but already results from final round' do
      it '4. second qualification phase score is ignored' do
        competitor1 = build_competitor 90, 10, 0, [9], [50, 40]
        competitor2 = build_competitor 90, 10, 0, [9], [49, 41]
        competitor3 = build_competitor 90, 10, 0, [9], [51, 39]
        expect(competitor2.relative_points).to eql competitor1.relative_points
        expect(competitor1.relative_points).to eql competitor3.relative_points
      end
    end

    it '5. number of tens, number of nines etc.' do
      competitor1 = build_competitor 89, 10, 10, [9], [81], [7, 9, 10, 9, 9, 9, 9, 9, 10, 9]
      competitor2 = build_competitor 91, 10, 10, [9], [81], [9, 8, 9, 10, 9, 9, 9, 9, 10, 9]
      competitor3 = build_competitor 91, 10, 10, [9], [81], [9, 9, 9, 9, 9, 9, 9, 9, 10, 9]
      expect(competitor2.relative_points).to be > competitor3.relative_points
      expect(competitor3.relative_points).to be > competitor1.relative_points
    end

    it '6. last shot, second last shot etc.' do
      competitor1 = build_competitor 90, 10, 10, [9], [81], [10, 10, 8, 9, 9, 9, 9, 8, 9, 9]
      competitor2 = build_competitor 90, 10, 10, [9], [81], [10, 8, 10, 8, 9, 9, 9, 9, 9, 9]
      competitor3 = build_competitor 90, 10, 10, [9], [81], [8, 10, 9, 9, 8, 9, 9, 9, 9, 10]
      expect(competitor3.relative_points).to be > competitor2.relative_points
      expect(competitor2.relative_points).to be > competitor1.relative_points
    end

    it 'DQ, DNS, DNF are the last' do
      competitor = build_competitor 99
      competitor_dnf = build_competitor_with_no_result_reason 100, Competitor::DNF
      competitor_dns = build_competitor_with_no_result_reason 101, Competitor::DNS
      competitor_dq = build_competitor_with_no_result_reason 102, Competitor::DQ
      expect(competitor.relative_points).to be > competitor_dnf.relative_points
      expect(competitor_dnf.relative_points).to be > competitor_dns.relative_points
      expect(competitor_dns.relative_points).to be > competitor_dq.relative_points
    end

    def build_competitor(shooting_score, hits=5, final_round_score=0, final_round_shots=[], qualification_round_sub_scores=[shooting_score], shots=[])
      competitor = build :competitor
      allow(competitor).to receive(:sport).and_return(sport)
      allow(competitor).to receive(:shooting_score).and_return(shooting_score)
      allow(competitor).to receive(:hits).and_return(hits)
      allow(competitor).to receive(:final_round_score).and_return(final_round_score)
      allow(competitor).to receive(:final_round_shots).and_return(final_round_shots)
      allow(competitor).to receive(:qualification_round_sub_scores).and_return(qualification_round_sub_scores)
      allow(competitor).to receive(:shots).and_return(shots)
      competitor
    end

    def build_competitor_with_no_result_reason(shooting_score, no_result_reason)
      competitor = build :competitor
      allow(competitor).to receive(:sport).and_return(sport)
      allow(competitor).to receive(:shooting_score).and_return(shooting_score)
      allow(competitor).to receive(:no_result_reason).and_return(no_result_reason)
      competitor
    end
  end
end
