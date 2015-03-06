require 'spec_helper'

describe EstimatesHelper do
  describe '#print_estimate_diff' do
    it 'should return empty string when nil given' do
      expect(helper.print_estimate_diff(nil)).to eq('-')
    end

    it 'should return negative diff with minus sign' do
      expect(helper.print_estimate_diff(-12)).to eq('-12')
    end

    it 'should return positive diff with plus sign' do
      expect(helper.print_estimate_diff(13)).to eq('+13')
    end
  end

  describe '#estimate_diffs' do
    describe '2 estimates' do
      before do
        @series = instance_double(Series, :estimates => 2)
      end

      it 'should return empty string when no estimates' do
        competitor = instance_double(Competitor, :estimate1 => nil, :estimate2 => nil,
                                     :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq('')
      end

      it 'should return first and dash when first is available' do
        competitor = instance_double(Competitor, :estimate1 => 50, :estimate2 => nil,
                                     :estimate_diff1_m => 10, :estimate_diff2_m => nil, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq('+10m/-')
      end

      it 'should return dash and second when second is available' do
        competitor = instance_double(Competitor, :estimate1 => nil, :estimate2 => 60,
                                     :estimate_diff1_m => nil, :estimate_diff2_m => -5, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq('-/-5m')
      end

      it 'should return both when both are available' do
        competitor = instance_double(Competitor, :estimate1 => 120, :estimate2 => 60,
                                     :estimate_diff1_m => -5, :estimate_diff2_m => 14, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq('-5m/+14m')
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
        competitor = instance_double(Competitor, :estimate1 => 50, :estimate2 => nil,
                                     :estimate_diff1_m => nil, :estimate_diff2_m => nil,
                                     :estimate_diff3_m => 12, :estimate_diff4_m => nil, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("-/-/+12m/-")
      end

      it 'should return dash for others when only fourth is available' do
        competitor = instance_double(Competitor, :estimate1 => 50, :estimate2 => nil,
                                     :estimate_diff1_m => nil, :estimate_diff2_m => nil,
                                     :estimate_diff3_m => nil, :estimate_diff4_m => -5, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("-/-/-/-5m")
      end

      it 'should return dash for third when others are available' do
        competitor = instance_double(Competitor, :estimate1 => 50, :estimate2 => nil,
                                     :estimate_diff1_m => 10, :estimate_diff2_m => -9,
                                     :estimate_diff3_m => nil, :estimate_diff4_m => 12, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("+10m/-9m/-/+12m")
      end

      it 'should return dash for fourth when others are available' do
        competitor = instance_double(Competitor, :estimate1 => nil, :estimate2 => 60,
                                     :estimate_diff1_m => 10, :estimate_diff2_m => -5,
                                     :estimate_diff3_m => 12, :estimate_diff4_m => nil, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("+10m/-5m/+12m/-")
      end

      it 'should return all diffs when all are available' do
        competitor = instance_double(Competitor, :estimate1 => 120, :estimate2 => 60,
                                     :estimate_diff1_m => -5, :estimate_diff2_m => 14,
                                     :estimate_diff3_m => 12, :estimate_diff4_m => -1, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("-5m/+14m/+12m/-1m")
      end
    end
  end

  describe '#estimate_points' do
    it 'should print empty string if no result reason defined' do
      competitor = instance_double(Competitor, :shots_sum => 88,
                                   :no_result_reason => Competitor::DNS)
      expect(helper.estimate_points(competitor)).to eq('')
    end

    it 'should return dash if no estimate points' do
      competitor = instance_double(Competitor, :estimate_points => nil,
                                   :no_result_reason => nil)
      expect(helper.estimate_points(competitor)).to eq("-")
    end

    it 'should return points otherwise' do
      competitor = instance_double(Competitor, :estimate_points => 189,
                                   :no_result_reason => nil)
      expect(helper.estimate_points(competitor)).to eq(189)
    end
  end

  describe '#estimate_points_and_diffs' do
    it 'should print empty string if no result reason defined' do
      competitor = instance_double(Competitor, :shots_sum => 88,
                                   :no_result_reason => Competitor::DNS)
      expect(helper.estimate_points_and_diffs(competitor)).to eq('')
    end

    it 'should return dash if no estimate points' do
      competitor = instance_double(Competitor, :estimate_points => nil,
                                   :no_result_reason => nil)
      expect(helper.estimate_points_and_diffs(competitor)).to eq("-")
    end

    it 'should return points and diffs when points available' do
      competitor = instance_double(Competitor, :estimate_points => 189,
                                   :no_result_reason => nil)
      expect(helper).to receive(:estimate_diffs).with(competitor).and_return("3m")
      expect(helper.estimate_points_and_diffs(competitor)).to eq("189 (3m)")
    end
  end

  describe '#correct_estimate' do
    it 'should raise error when index less than 1' do
      expect { helper.correct_estimate(nil, 0, '') }.to raise_error
    end

    it 'should raise error when index more than 4' do
      expect { helper.correct_estimate(nil, 5, '') }.to raise_error
    end

    context 'race not finished' do
      before do
        race = instance_double(Race, :finished => false)
        series = instance_double(Series, :race => race)
        @competitor = instance_double(Competitor, :series => series,
                                      :correct_estimate1 => 100, :correct_estimate2 => 150)
      end

      specify { expect(helper.correct_estimate(@competitor, 1, '-')).to eq('-') }
      specify { expect(helper.correct_estimate(@competitor, 2, '-')).to eq('-') }
      specify { expect(helper.correct_estimate(@competitor, 3, '-')).to eq('-') }
      specify { expect(helper.correct_estimate(@competitor, 4, '-')).to eq('-') }
    end

    context 'race finished' do
      context 'estimates available' do
        before do
          race = instance_double(Race, :finished => true)
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
          race = instance_double(Race, :finished => true)
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
end