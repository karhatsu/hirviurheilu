require 'spec_helper'

describe Shots do
  let(:sport) { double Sport }
  let(:shooting_rules_penalty) { 2 }

  context 'when sport has no qualification round' do
    let(:competitor) { FakeCompetitor.new sport, [10, 9, 0, 8] }

    before do
      allow(sport).to receive(:qualification_round).and_return(false)
      allow(sport).to receive(:final_round).and_return(false)
    end

    it 'hits is count of non-zeros' do
      expect(competitor.hits).to eql [10, 9, 8].length
    end

    it 'qualification_round_hits is nil' do
      expect(competitor.qualification_round_hits).to be_nil
    end

    it 'qualification round shots is nil' do
      expect(competitor.qualification_round_shots).to be_nil
    end

    it 'qualification round sub scores is nil' do
      expect(competitor.qualification_round_sub_scores).to be_nil
    end

    it 'qualification round score is nil' do
      expect(competitor.qualification_round_score).to be_nil
    end

    it 'final round shots is nil' do
      expect(competitor.final_round_shots).to be_nil
    end

    it 'final round sub scores is nil' do
      expect(competitor.final_round_sub_scores).to be_nil
    end

    it 'final round score is nil' do
      expect(competitor.final_round_score).to be_nil
    end

    context 'and no shots nor shooting score input given' do
      let(:competitor) { FakeCompetitor.new sport, nil }

      it 'hits is nil' do
        expect(competitor.hits).to be_nil
      end

      it 'shooting score is nil' do
        expect(competitor.shooting_score).to be_nil
      end
    end

    context 'and shots given' do
      context 'without rules penalty' do
        it 'shooting score is sum of all shots' do
          expect(competitor.shooting_score).to eql 10 + 9 + 0 + 8
        end
      end

      context 'with rules penalty' do
        it 'shooting score is sum of all shots - rules penalty' do
          competitor.shooting_rules_penalty = shooting_rules_penalty
          expect(competitor.shooting_score).to eql 10 + 9 + 0 + 8
          expect(competitor.shooting_score(true)).to eql 10 + 9 + 0 + 8 - shooting_rules_penalty
        end
      end
    end

    context 'and shooting score input given' do
      before do
        competitor.shots = nil
        competitor.shooting_score_input = 94
      end

      it 'hits is nil' do
        expect(competitor.hits).to be_nil
      end

      it 'shooting score is the given input value' do
        expect(competitor.shooting_score).to eql 94
      end

      context 'with rules penalty' do
        it 'shooting score is the given input value - rules penalty' do
          competitor.shooting_rules_penalty = shooting_rules_penalty
          expect(competitor.shooting_score).to eql 94
          expect(competitor.shooting_score(true)).to eql 94 - shooting_rules_penalty
        end
      end
    end
  end

  context 'when qualification and final round shooting score inputs given' do
    let(:competitor) { FakeCompetitor.new sport, nil }

    before do
      allow(sport).to receive(:qualification_round).and_return([10])
      allow(sport).to receive(:qualification_round_shot_count).and_return(10)
      allow(sport).to receive(:final_round).and_return([10])
      competitor.qualification_round_shooting_score_input = 91
      competitor.final_round_shooting_score_input = 88
      competitor.shooting_rules_penalty = shooting_rules_penalty
    end

    it 'hits is nil' do
      expect(competitor.hits).to be_nil
    end

    it 'qualification_round_hits is nil' do
      expect(competitor.qualification_round_hits).to be_nil
    end

    it 'qualification round shots is nil' do
      expect(competitor.qualification_round_shots).to be_nil
    end

    it 'qualification round sub scores is nil' do
      expect(competitor.qualification_round_sub_scores).to be_nil
    end

    it 'qualification round score is given value' do
      expect(competitor.qualification_round_score).to eql 91
    end

    it 'final round shots is nil' do
      expect(competitor.final_round_shots).to be_nil
    end

    it 'final round sub scores is nil' do
      expect(competitor.final_round_sub_scores).to be_nil
    end

    it 'final round score is given value' do
      expect(competitor.final_round_score).to eql 88
    end

    it 'shooting score is sum of input values - rules penalty' do
      expect(competitor.shooting_score).to eql 91 + 88
      expect(competitor.shooting_score(true)).to eql 91 + 88 - shooting_rules_penalty
    end
  end

  context 'when sport has qualification and final rounds in one part' do
    before do
      allow(sport).to receive(:qualification_round).and_return([5])
      allow(sport).to receive(:qualification_round_shot_count).and_return(5)
      allow(sport).to receive(:final_round).and_return([5])
    end

    context 'and no shots available' do
      let(:competitor) { FakeCompetitor.new sport, nil }

      it 'hits is nil' do
        expect(competitor.hits).to be_nil
      end

      it 'qualification_round_hits is nil' do
        expect(competitor.qualification_round_hits).to be_nil
      end

      it 'qualification round shots is nil' do
        expect(competitor.qualification_round_shots).to be_nil
      end

      it 'qualification round sub scores is nil' do
        expect(competitor.qualification_round_sub_scores).to be_nil
      end

      it 'qualification round score is nil' do
        expect(competitor.qualification_round_score).to be_nil
      end

      it 'final round shots is nil' do
        expect(competitor.final_round_shots).to be_nil
      end

      it 'final round sub scores is nil' do
        expect(competitor.final_round_sub_scores).to be_nil
      end

      it 'final round score is nil' do
        expect(competitor.final_round_score).to be_nil
      end

      it 'shooting score is nil' do
        expect(competitor.shooting_score).to be_nil
      end
    end

    context 'and some qualification round shots available' do
      let(:competitor) { FakeCompetitor.new sport, [10, 9, 4, 3] }

      it 'qualification round shots is an array with one shots array having available shots' do
        expect(competitor.qualification_round_shots).to eql [[10, 9, 4, 3]]
      end

      it 'qualification round sub scores is an array with one item being the sum of available shots' do
        expect(competitor.qualification_round_sub_scores).to eql [10 + 9 + 4 + 3]
      end

      it 'qualification round score is sum of available shots' do
        expect(competitor.qualification_round_score).to eql 10 + 9 + 4 + 3
      end

      it 'qualification round hits is number of shots' do
        expect(competitor.qualification_round_hits).to eql 4
      end

      it 'final round shots is nil' do
        expect(competitor.final_round_shots).to be_nil
      end

      it 'final round sub scores is nil' do
        expect(competitor.final_round_sub_scores).to be_nil
      end

      it 'final round score is nil' do
        expect(competitor.final_round_score).to be_nil
      end

      it 'shooting score is sum of shots' do
        expect(competitor.shooting_score).to eql 10 + 9 + 4 + 3
      end
    end

    context 'and all qualification round shots available' do
      context 'but no any of the final round shots' do
        let(:competitor) { FakeCompetitor.new sport, [10, 9, 4, 3, 9] }

        it 'qualification round shots is an array with one shots array having the correct amount of shots' do
          expect(competitor.qualification_round_shots).to eql [[10, 9, 4, 3, 9]]
        end

        it 'qualification round sub scores is an array with one item being the sum of qualification round shots' do
          expect(competitor.qualification_round_sub_scores).to eql [10 + 9 + 4 + 3 + 9]
        end

        it 'qualification round score sum of qualification round shots' do
          expect(competitor.qualification_round_score).to eql 10 + 9 + 4 + 3 + 9
        end

        it 'final round shots is nil' do
          expect(competitor.final_round_shots).to be_nil
        end

        it 'final round sub scores is nil' do
          expect(competitor.final_round_sub_scores).to be_nil
        end

        it 'final round score is nil' do
          expect(competitor.final_round_score).to be_nil
        end
      end

      context 'and some final round shots too' do
        let(:competitor) { FakeCompetitor.new sport, [10, 9, 0, 3, 9, 2, 6] }

        it 'qualification round shots is an array with one shots array having the correct amount of shots' do
          expect(competitor.qualification_round_shots).to eql [[10, 9, 0, 3, 9]]
        end

        it 'qualification round hits is number of non-zero qualification round shots' do
          expect(competitor.qualification_round_hits).to eql 4
        end

        it 'final round shots is an array with an array containing available final round shots' do
          expect(competitor.final_round_shots).to eql [[2, 6]]
        end

        it 'final round sub scores is an array containing sum of available final round shots' do
          expect(competitor.final_round_sub_scores).to eql [8]
        end

        it 'final round score is sum of available final round shots' do
          expect(competitor.final_round_score).to eql 8
        end
      end

      context 'and all final round shots available as well' do
        let(:competitor) { FakeCompetitor.new sport, [10, 9, 4, 3, 9, 2, 6, 9, 8, 10] }

        it 'final round shots is an array with an array containing final round shots' do
          expect(competitor.final_round_shots).to eql [[2, 6, 9, 8, 10]]
        end

        it 'final round sub scores is an array of one value being sum of final round shots' do
          expect(competitor.final_round_sub_scores).to eql [2 + 6 + 9 + 8 + 10]
        end

        it 'final round score is sum of final round shots' do
          expect(competitor.final_round_score).to eql 2 + 6 + 9 + 8 + 10
        end

        it 'shooting score is sum of shots' do
          expect(competitor.shooting_score).to eql 10 + 9 + 4 + 3 + 9 + 2 + 6 + 9 + 8 + 10
        end
      end
    end

    context 'when qualification and final round shots sums are both 11' do
      let(:competitor) { FakeCompetitor.new sport, [3, 6, 0, 2, 0, 6, 1, 1, 3, 0] }

      it 'qualification round score is 11 (not 10)' do
        expect(competitor.qualification_round_score).to eql 11
      end

      it 'final round score is 11 (not 10)' do
        expect(competitor.final_round_score).to eql 11
      end
    end
  end

  context 'when sport has qualification round in two parts and final round in two parts' do
    before do
      allow(sport).to receive(:qualification_round).and_return([4, 6])
      allow(sport).to receive(:qualification_round_shot_count).and_return(10)
      allow(sport).to receive(:final_round).and_return([3, 2])
    end

    context 'and no shots not available' do
      let(:competitor) { FakeCompetitor.new sport, nil }

      it 'qualification round shots is nil' do
        expect(competitor.qualification_round_shots).to be_nil
      end

      it 'qualification round sub scores is nil' do
        expect(competitor.qualification_round_sub_scores).to be_nil
      end

      it 'qualification round score is nil' do
        expect(competitor.qualification_round_score).to be_nil
      end
    end

    context 'and all qualification round shots not available' do
      let(:competitor) { FakeCompetitor.new sport, [9, 4, 3] }

      it 'qualification round returns an array with one shots array having available shots and another array being empty' do
        expect(competitor.qualification_round_shots).to eql [[9, 4, 3], []]
      end

      it 'qualification round first item in sub scores is sum of available shots and other one is 0' do
        expect(competitor.qualification_round_sub_scores).to eql [9 + 4 + 3, 0]
      end

      it 'qualification round score is sum of available shots' do
        expect(competitor.qualification_round_score).to eql 9 + 4 + 3
      end
    end

    context 'and all qualification round shots available' do
      context 'but not all final round shots' do
        let(:competitor) { FakeCompetitor.new sport, [10, 9, 4, 3, 9, 12, 6, 8, 7, 2, 10] }

        it 'qualification round returns an array with one shots array having the correct amount of shots' do
          expect(competitor.qualification_round_shots).to eql [[10, 9, 4, 3], [9, 12, 6, 8, 7, 2]]
        end

        it 'qualification round first item in sub scores is sum of available shots and other one is 0' do
          expect(competitor.qualification_round_sub_scores).to eql [10 + 9 + 4 + 3, 9 + 12 + 6 + 8 + 7 + 2]
        end

        it 'qualification round score sum of qualification round shots' do
          expect(competitor.qualification_round_score).to eql 10 + 9 + 4 + 3 + 9 + 12 + 6 + 8 + 7 + 2
        end
      end

      context 'and all final round shots available as well' do
        let(:competitor) { FakeCompetitor.new sport, [10, 9, 4, 3, 9, 12, 6, 8, 7, 2, 10, 0, 3, 4, 9] }

        it 'final round shots is an array with an two arrays containing final round shots' do
          expect(competitor.final_round_shots).to eql [[10, 0, 3], [4, 9]]
        end

        it 'final round sub scores is an array of sums of final round shots' do
          expect(competitor.final_round_sub_scores).to eql [10 + 0 + 3, 4 + 9]
        end

        it 'final round score is sum of final round shots' do
          expect(competitor.final_round_score).to eql 10 + 0 + 3 + 4 + 9
        end

        it 'shooting score is sum of all shots' do
          expect(competitor.shooting_score).to eql 10 + 9 + 4 + 3 + 9 + 12 + 6 + 8 + 7 + 2 + 10 + 0 + 3 + 4 + 9
        end
      end
    end
  end

  context 'when sport has qualification round in four parts' do
    before do
      allow(sport).to receive(:qualification_round).and_return([5, 5, 5, 5])
      allow(sport).to receive(:qualification_round_shot_count).and_return(20)
      allow(sport).to receive(:final_round).and_return([10])
    end

    context 'and all qualification round shots not available' do
      let(:competitor) { FakeCompetitor.new sport, [9, 9, 8, 8, 7, 7, 10] }

      it 'qualification round returns an array with shots correctly split into slots' do
        expect(competitor.qualification_round_shots).to eql [[9, 9, 8, 8, 7], [7, 10], [], []]
      end

      it 'qualification round sub scores are the sum of existing shots and zeros when no shots' do
        expect(competitor.qualification_round_sub_scores).to eql [9 + 9 + 8 + 8 + 7, 7 + 10, 0, 0]
      end

      it 'qualification round score is sum of available shots' do
        expect(competitor.qualification_round_score).to eql 9 + 9 + 8 + 8 + 7 + 7 + 10
      end
    end

    context 'and all qualification round shots available' do
      context 'but not all final round shots' do
        let(:competitor) { FakeCompetitor.new sport, [9, 9, 9, 9, 9, 8, 8, 8, 8, 8, 7, 7, 7, 7, 7, 10, 10, 10, 10, 10] }

        it 'qualification round returns an array including arrays' do
          expect(competitor.qualification_round_shots).to eql [[9, 9, 9, 9, 9], [8, 8, 8, 8, 8], [7, 7, 7, 7, 7], [10, 10, 10, 10, 10]]
        end

        it 'qualification round sub scores are the sum of shots' do
          expect(competitor.qualification_round_sub_scores).to eql [5 * 9, 5 * 8, 5 * 7, 5 * 10]
        end

        it 'qualification round score sum of qualification round shots' do
          expect(competitor.qualification_round_score).to eql 5 * 9 + 5 * 8 + 5 * 7 + 5 * 10
        end
      end
    end
  end

  context 'when shots contain value 11 (inner 10)' do
    let(:competitor) { FakeCompetitor.new sport, [9, 11, 11, 5, 10, 11, 8, 11, 11, 10] }

    before do
      allow(sport).to receive(:qualification_round).and_return([2, 2])
      allow(sport).to receive(:qualification_round_shot_count).and_return(4)
      allow(sport).to receive(:final_round).and_return([2, 2])
    end

    it 'value 11 is sent as 11 in shot arrays' do
      expect(competitor.qualification_round_shots).to eql [[9, 11], [11, 5]]
      expect(competitor.final_round_shots).to eql [[10, 11], [8, 11]]
    end

    it 'value 11 is calculated as 10 in scores' do
      expect(competitor.qualification_round_sub_scores).to eql [19, 15]
      expect(competitor.qualification_round_score).to eql 19 + 15
      expect(competitor.final_round_sub_scores).to eql [20, 18]
      expect(competitor.final_round_score).to eql 20 + 18
      expect(competitor.shooting_score).to eql 19 + 15 + 20 + 18
    end
  end

  describe 'extra shots' do
    let(:competitor) { FakeCompetitor.new sport, [10, 10, 10, 10, 10] }
    context 'when no extra shots' do
      it 'extra score is nil' do
        expect(competitor.extra_score).to be_nil
      end
    end

    context 'when extra shots' do
      it 'extra score is sum of shots' do
        competitor.extra_shots = [10, 9]
        expect(competitor.extra_score).to eql 19
      end
    end
  end

  describe 'nordic' do
    let(:competitor) { Competitor.new }

    context 'when no values' do
      it 'trap score is nil' do
        expect(competitor.nordic_trap_score).to be_nil
      end

      it 'shotgun score is nil' do
        expect(competitor.nordic_shotgun_score).to be_nil
      end

      it 'moving rifle score is nil' do
        expect(competitor.nordic_rifle_moving_score).to be_nil
      end

      it 'standind rifle score is nil' do
        expect(competitor.nordic_rifle_standing_score).to be_nil
      end

      it 'nordic score is nil' do
        expect(competitor.nordic_score).to be_nil
      end
    end

    context 'when some scores defined' do
      before do
        competitor.nordic_rifle_moving_score_input = 89
      end

      it 'nordic score assumes 0 for others' do
        expect(competitor.nordic_score).to eql 89
      end
    end

    context 'when score inputs given' do
      before do
        competitor.nordic_trap_score_input = 23
        competitor.nordic_shotgun_score_input = 20
        competitor.nordic_rifle_moving_score_input = 89
        competitor.nordic_rifle_standing_score_input = 97
        competitor.shooting_rules_penalty = shooting_rules_penalty
      end

      it 'trap score is given input' do
        expect(competitor.nordic_trap_score).to eql 23
      end

      it 'shotgun score is given input' do
        expect(competitor.nordic_shotgun_score).to eql 20
      end

      it 'moving rifle score is given input' do
        expect(competitor.nordic_rifle_moving_score).to eql 89
      end

      it 'standind rifle score is given input' do
        expect(competitor.nordic_rifle_standing_score).to eql 97
      end

      it 'nordic score is 4 x trap and shotgun + rifle scores - rules penalty' do
        expect(competitor.nordic_score).to eql 4 * 23 + 4 * 20 + 89 + 97
        expect(competitor.nordic_score(true)).to eql 4 * 23 + 4 * 20 + 89 + 97 - shooting_rules_penalty
      end
    end

    context 'when shots given' do
      before do
        competitor.nordic_trap_shots = [1, 1, 0, 1, 0, 1]
        competitor.nordic_shotgun_shots = [0, 1, 1, 1, 1, 1, 1, 0]
        competitor.nordic_rifle_moving_shots = [10, 9, 8, 10]
        competitor.nordic_rifle_standing_shots = [10, 10, 10, 8]
      end

      it 'trap score is sum of shots' do
        expect(competitor.nordic_trap_score).to eql 4
      end

      it 'shotgun score is sum of shots' do
        expect(competitor.nordic_shotgun_score).to eql 6
      end

      it 'moving rifle score is sum of shots' do
        expect(competitor.nordic_rifle_moving_score).to eql 37
      end

      it 'standind rifle score is sum of shots' do
        expect(competitor.nordic_rifle_standing_score).to eql 38
      end

      it 'nordic score is 4 x trap and shotgun + rifle scores' do
        expect(competitor.nordic_score).to eql 4 * 4 + 4 * 6 + 37 + 38
      end
    end
  end

  describe 'european' do
    let(:competitor) { Competitor.new }

    context 'when no values' do
      it 'trap score is nil' do
        expect(competitor.european_trap_score).to be_nil
      end

      it 'compak score is nil' do
        expect(competitor.european_compak_score).to be_nil
      end

      it 'rifle scores are nil' do
        expect(competitor.european_rifle1_score).to be_nil
        expect(competitor.european_rifle2_score).to be_nil
        expect(competitor.european_rifle3_score).to be_nil
        expect(competitor.european_rifle4_score).to be_nil
      end

      it 'european rifle score is nil' do
        expect(competitor.european_score).to be_nil
      end

      it 'european score is nil' do
        expect(competitor.european_score).to be_nil
      end
    end

    context 'when some scores defined' do
      before do
        competitor.european_rifle2_score_input = 43
        competitor.shooting_rules_penalty = shooting_rules_penalty
      end

      it 'european rifle score assumes 0 for others' do
        expect(competitor.european_rifle_score).to eql 43
      end

      it 'european score assumes 0 for others' do
        expect(competitor.european_score).to eql 43
        expect(competitor.european_score(true)).to eql 43 - shooting_rules_penalty
      end
    end

    context 'when score inputs given' do
      before do
        competitor.european_trap_score_input = 25
        competitor.european_compak_score_input = 21
        competitor.european_rifle1_score_input = 49
        competitor.european_rifle2_score_input = 50
        competitor.european_rifle3_score_input = 40
        competitor.european_rifle4_score_input = 38
      end

      it 'trap score is given input' do
        expect(competitor.european_trap_score).to eql 25
      end

      it 'compak score is given input' do
        expect(competitor.european_compak_score).to eql 21
      end

      it 'rifle scores are their given inputs' do
        expect(competitor.european_rifle1_score).to eql 49
        expect(competitor.european_rifle2_score).to eql 50
        expect(competitor.european_rifle3_score).to eql 40
        expect(competitor.european_rifle4_score).to eql 38
      end

      it 'european rifle score is sum of rifle scores' do
        expect(competitor.european_rifle_score).to eql 49 + 50 + 40 + 38
      end

      it 'european score is 4 x trap and compak + rifle scores' do
        expect(competitor.european_score).to eql 4 * 25 + 4 * 21 + 49 + 50 + 40 + 38
      end

      it 'returns empty all rifle shots array' do
        expect(competitor.european_rifle_shots).to eql []
      end
    end

    context 'when shots given' do
      before do
        competitor.european_trap_shots = [1, 1, 0, 1]
        competitor.european_compak_shots = [0, 1, 1, 1, 1, 1, 0]
        competitor.european_rifle1_shots = [10, 9, 9, 10, 0]
        competitor.european_rifle2_shots = [10, 8, 10]
        competitor.european_rifle3_shots = [9, 5]
        competitor.european_rifle4_shots = [10, 10, 10, 10, 10]
      end

      it 'trap score is sum of shots' do
        expect(competitor.european_trap_score).to eql 3
      end

      it 'compak score is sum of shots' do
        expect(competitor.european_compak_score).to eql 5
      end

      it 'rifle scores are sums of shots' do
        expect(competitor.european_rifle1_score).to eql 38
        expect(competitor.european_rifle2_score).to eql 28
        expect(competitor.european_rifle3_score).to eql 14
        expect(competitor.european_rifle4_score).to eql 50
      end

      it 'european rifle score is sum of rifle scores' do
        expect(competitor.european_rifle_score).to eql 38 + 28 + 14 + 50
      end

      it 'european score is 4 x trap and compak + rifle scores' do
        expect(competitor.european_score).to eql 4 * 3 + 4 * 5 + 38 + 28 + 14 + 50
      end

      it 'returns all rifle shots in one array' do
        expect(competitor.european_rifle_shots).to eql [10, 9, 9, 10, 0, 10, 8, 10, 9, 5, 10, 10, 10, 10, 10]
      end
    end
  end

  class FakeCompetitor
    include Shots

    def initialize(sport, shots)
      @sport = sport
      @shots = shots
    end

    attr_reader :sport
    attr_accessor :shots, :shooting_score_input, :qualification_round_shooting_score_input, :final_round_shooting_score_input, :extra_shots, :shooting_rules_penalty
  end
end
