require 'spec_helper'

describe RelativePoints do
  context 'when only shooting' do
    let(:sport) { double Sport, only_shooting?: true }

    it 'is 0 when no shots' do
      competitor = build_competitor nil
      expect(competitor.relative_points).to eql 0
    end

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
        competitor1 = build_competitor 90, 10, 0, nil, [50, 40]
        competitor2 = build_competitor 90, 10, 0, nil, [49, 41]
        competitor3 = build_competitor 90, 10, 0, nil, [51, 39]
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

    def build_competitor(shooting_score, hits=5, final_round_score=nil, final_round_shots=nil, qualification_round_sub_scores=[shooting_score], shots=[])
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
