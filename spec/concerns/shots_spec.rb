require 'spec_helper'

describe Shots do
  let(:sport) { double Sport }

  context 'when sport has no qualification round' do
    let(:competitor) { FakeCompetitor.new sport, [10, 9, 0, 8] }

    before do
      allow(sport).to receive(:qualification_round).and_return(false)
      allow(sport).to receive(:final_round).and_return(false)
    end

    it 'hits is count of non-zeros' do
      expect(competitor.hits).to eql [10, 9, 8].length
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

    it 'extra round shots is nil' do
      expect(competitor.extra_round_shots).to be_nil
    end

    it 'extra round score is nil' do
      expect(competitor.extra_round_score).to be_nil
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
      it 'shooting score is sum of all shots' do
        expect(competitor.shooting_score).to eql 10 + 9 + 0 + 8
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
    end
  end

  context 'when sport has qualification and final rounds in one part' do
    before do
      allow(sport).to receive(:qualification_round).and_return([5])
      allow(sport).to receive(:final_round).and_return([5])
    end

    context 'and no shots available' do
      let(:competitor) { FakeCompetitor.new sport, nil }

      it 'hits is nil' do
        expect(competitor.hits).to be_nil
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

      it 'extra round shots is nil' do
        expect(competitor.extra_round_shots).to be_nil
      end

      it 'extra round score is nil' do
        expect(competitor.extra_round_score).to be_nil
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

      it 'final round shots is nil' do
        expect(competitor.final_round_shots).to be_nil
      end

      it 'final round sub scores is nil' do
        expect(competitor.final_round_sub_scores).to be_nil
      end

      it 'final round score is nil' do
        expect(competitor.final_round_score).to be_nil
      end

      it 'extra round shots is nil' do
        expect(competitor.extra_round_shots).to be_nil
      end

      it 'shooting score is sum of shots' do
        expect(competitor.shooting_score).to eql 10 + 9 + 4 + 3
      end
    end

    context 'and all qualification round shots available' do
      context 'but not all final round shots' do
        let(:competitor) { FakeCompetitor.new sport, [10, 9, 4, 3, 9, 2, 6] }

        it 'qualification round shots is an array with one shots array having the correct amount of shots' do
          expect(competitor.qualification_round_shots).to eql [[10, 9, 4, 3, 9]]
        end

        it 'qualification round sub scores is an array with one item being the sum of qualification round shots' do
          expect(competitor.qualification_round_sub_scores).to eql [10 + 9 + 4 + 3 + 9]
        end

        it 'qualification round score sum of qualification round shots' do
          expect(competitor.qualification_round_score).to eql 10 + 9 + 4 + 3 + 9
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

      context 'and exactly all final round shots available as well' do
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

        it 'extra round shots is an empty array' do
          expect(competitor.extra_round_shots).to eql []
        end
      end

      context 'and all final round and also extra shots available' do
        let(:competitor) { FakeCompetitor.new sport, [10, 9, 4, 3, 9, 2, 6, 9, 8, 10, 9, 8] }

        it 'final round score is sum of final round shots' do
          expect(competitor.final_round_score).to eql 2 + 6 + 9 + 8 + 10
        end

        it 'extra round shots is an array of extra shots' do
          expect(competitor.extra_round_shots).to eql [9, 8]
        end

        it 'extra round score is sum of extra shots' do
          expect(competitor.extra_round_score).to eql 9 + 8
        end
      end
    end
  end

  context 'when sport has qualification round in two parts and final round in two parts' do
    before do
      allow(sport).to receive(:qualification_round).and_return([4, 6])
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

  class FakeCompetitor
    include Shots

    def initialize(sport, shots)
      @sport = sport
      @shots = shots
    end

    attr_reader :sport
    attr_accessor :shots, :shooting_score_input
  end
end
