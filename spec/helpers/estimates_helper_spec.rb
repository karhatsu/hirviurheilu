require 'spec_helper'

describe EstimatesHelper do
  describe '#print_estimate_diff' do
    it 'should return empty string when nil given' do
      expect_estimate_diff nil, '-'
    end

    it 'should return negative diff with minus sign' do
      expect_estimate_diff -12, '-12'
    end

    it 'should return positive diff with plus sign' do
      expect_estimate_diff 13, '+13'
    end

    def expect_estimate_diff(diff, expected)
      expect(helper.print_estimate_diff(diff)).to eq(expected)
    end
  end

  describe '#estimate_diffs' do
    describe '2 estimates' do
      before do
        @series = instance_double(Series, :estimates => 2)
      end

      it 'should return empty string when no estimates' do
        expect_estimate_diffs_2 nil, nil, nil, nil, ''
      end

      it 'should return first and dash when first is available' do
        expect_estimate_diffs_2 50, nil, 10, nil, '+10m/-'
      end

      it 'should return dash and second when second is available' do
        expect_estimate_diffs_2 nil, 60, nil, -5, '-/-5m'
      end

      it 'should return both when both are available' do
        expect_estimate_diffs_2 120, 60, -5, 14, '-5m/+14m'
      end

      def expect_estimate_diffs_2(e1, e2, d1, d2, expected)
        competitor = instance_double(Competitor, :estimate1 => e1, :estimate2 => e2,
                                     :estimate_diff1_m => d1, :estimate_diff2_m => d2, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq(expected)
      end
    end

    describe '4 estimates' do
      before do
        @series = instance_double(Series, :estimates => 4)
      end

      it 'should return empty string when no estimates' do
        competitor = instance_double(Competitor, :estimate1 => nil, :estimate2 => nil,
                                     :estimate3 => nil, :estimate4 => nil, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("")
      end

      it 'should return dash for others when only third is available' do
        expect_estimate_diffs_4 50, nil, nil, nil, 12, nil, '-/-/+12m/-'
      end

      it 'should return dash for others when only fourth is available' do
        expect_estimate_diffs_4 50, nil, nil, nil, nil, -5, '-/-/-/-5m'
      end

      it 'should return dash for third when others are available' do
        expect_estimate_diffs_4 50, nil, 10, -9, nil, 12, '+10m/-9m/-/+12m'
      end

      it 'should return dash for fourth when others are available' do
        expect_estimate_diffs_4 nil, 60, 10, -5, 12, nil, '+10m/-5m/+12m/-'
      end

      it 'should return all diffs when all are available' do
        expect_estimate_diffs_4 120, 60, -5, 14, 12, -1, '-5m/+14m/+12m/-1m'
      end

      def expect_estimate_diffs_4(e1, e2, d1, d2, d3, d4, expected)
        competitor = instance_double(Competitor, :estimate1 => e1, :estimate2 => e2,
                                     :estimate_diff1_m => d1, :estimate_diff2_m => d2,
                                     :estimate_diff3_m => d3, :estimate_diff4_m => d4, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq(expected)
      end
    end
  end

  describe '#estimate_points_print' do
    let(:no_result_reason) { nil }
    let(:estimate_points) { 290 }
    let(:show_correct_distances?) { true }
    let(:fake_meters) { '12m' }
    let(:race) { instance_double Race }
    let(:competitor) { instance_double Competitor }

    before do
      allow(race).to receive(:show_correct_distances?).and_return(show_correct_distances?)
      allow(competitor).to receive(:no_result_reason).and_return(no_result_reason)
      allow(competitor).to receive(:estimate_points).and_return(estimate_points)
      allow(helper).to receive(:estimate_diffs).with(competitor).and_return(fake_meters)
    end

    context 'when no result reason' do
      let(:no_result_reason) { Competitor::DNF }

      it 'should return empty string' do
        expect_points_print''
      end
    end

    context 'when no estimate points available' do
      let(:estimate_points) { nil }

      it 'should return dash' do
        expect_points_print '-'
      end
    end

    context 'when estimate points available' do
      context 'when correct distances cannot be revealed' do
        let(:show_correct_distances?) { false }

        it 'should return only points' do
          expect_points_print estimate_points
        end
      end

      context 'when correct distances can be revealed' do
        it 'should return points and meters' do
          expect_points_print "#{estimate_points} (#{fake_meters})"
        end
      end
    end

    def expect_points_print(expected)
      expect(helper.estimate_points_print(race, competitor)).to eq(expected)
    end
  end

  describe '#correct_estimate' do
    it 'should raise error when index less than 1' do
      expect { helper.correct_estimate(nil, 0, '') }.to raise_error(RuntimeError)
    end

    it 'should raise error when index more than 4' do
      expect { helper.correct_estimate(nil, 5, '') }.to raise_error(RuntimeError)
    end

    context 'when correct estimates cannot be revealed' do
      before do
        race = instance_double(Race, show_correct_distances?: false)
        series = instance_double(Series, :race => race)
        @competitor = instance_double(Competitor, :series => series,
                                      :correct_estimate1 => 100, :correct_estimate2 => 150)
      end

      specify { expect(helper.correct_estimate(@competitor, 1, '-')).to eq('-') }
      specify { expect(helper.correct_estimate(@competitor, 2, '-')).to eq('-') }
      specify { expect(helper.correct_estimate(@competitor, 3, '-')).to eq('-') }
      specify { expect(helper.correct_estimate(@competitor, 4, '-')).to eq('-') }
    end

    context 'when correct estimates can be revealed' do
      context 'estimates available' do
        before do
          race = instance_double(Race, show_correct_distances?: true)
          series = instance_double(Series, :race => race)
          @competitor = instance_double(Competitor, :series => series,
                                        :correct_estimate1 => 100, :correct_estimate2 => 150,
                                        :correct_estimate3 => 110, :correct_estimate4 => 160)
        end

        specify { expect(helper.correct_estimate(@competitor, 1, '-')).to eq(100) }
        specify { expect(helper.correct_estimate(@competitor, 2, '-')).to eq(150) }
        specify { expect(helper.correct_estimate(@competitor, 3, '-')).to eq(110) }
        specify { expect(helper.correct_estimate(@competitor, 4, '-')).to eq(160) }
      end

      context 'estimates not available' do
        before do
          race = instance_double(Race, show_correct_distances?: true)
          series = instance_double(Series, :race => race)
          @competitor = instance_double(Competitor, :series => series,
                                        :correct_estimate1 => nil, :correct_estimate2 => nil,
                                        :correct_estimate3 => nil, :correct_estimate4 => nil)
        end

        specify { expect(helper.correct_estimate(@competitor, 1, '-')).to eq('-') }
        specify { expect(helper.correct_estimate(@competitor, 2, '-')).to eq('-') }
        specify { expect(helper.correct_estimate(@competitor, 3, '-')).to eq('-') }
        specify { expect(helper.correct_estimate(@competitor, 4, '-')).to eq('-') }
      end
    end
  end

  describe '#correct_estimate_range' do
    it 'should return min_number- if no max_number' do
      expect_estimate_range 56, nil, '56-'
    end

    it 'should return min_number if max_number equals to it' do
      expect_estimate_range 57, 57, '57'
    end

    it 'should return min_number-max_number if both defined and different' do
      expect_estimate_range 57, 58, '57-58'
    end

    def expect_estimate_range(min_number, max_number, expected_range)
      ce = build(:correct_estimate, min_number: min_number, max_number: max_number)
      expect(helper.correct_estimate_range(ce)).to eq(expected_range)
    end
  end
end
