require 'spec_helper'

describe ResultFormatHelper do
  describe '#points_print' do
    let(:unofficials) { Series::UNOFFICIALS_EXCLUDED }

    it 'should print no result reason if it is defined' do
      competitor = instance_double(Competitor, :no_result_reason => Competitor::DNS)
      allow(competitor).to receive(:points).with(unofficials).and_return(145)
      expect(helper.points_print(competitor, unofficials)).
          to eq("<span class='explanation' title='Kilpailija ei osallistunut kilpailuun'>DNS</span>")
    end

    it 'should print points if competitor finished and has correct estimates' do
      competitor = instance_double(Competitor, :no_result_reason => nil,
                                   :series => nil)
      expect(competitor).to receive(:points).with(unofficials).and_return(145)
      expect(competitor).to receive(:finished?).and_return(true)
      expect(competitor).to receive(:has_correct_estimates?).and_return(true)
      expect(helper.points_print(competitor, unofficials)).to eq('145')
    end

    it 'should print points in brackets if competitor not finished' do
      competitor = instance_double(Competitor, :no_result_reason => nil)
      expect(competitor).to receive(:points).with(unofficials).and_return(100)
      expect(competitor).to receive(:finished?).and_return(false)
      expect(helper.points_print(competitor, unofficials)).to eq('(100)')
    end

    it 'should print points in brackets if competitor has no correct estimates yet' do
      competitor = instance_double(Competitor, :no_result_reason => nil)
      expect(competitor).to receive(:points).with(unofficials).and_return(100)
      expect(competitor).to receive(:finished?).and_return(true)
      expect(competitor).to receive(:has_correct_estimates?).and_return(false)
      expect(helper.points_print(competitor, unofficials)).to eq('(100)')
    end

    it 'should print - if no points at all' do
      competitor = instance_double(Competitor, :no_result_reason => nil,
                                   :series => nil)
      expect(competitor).to receive(:points).with(unofficials).and_return(nil)
      expect(competitor).to receive(:finished?).and_return(false)
      expect(helper.points_print(competitor, unofficials)).to eq('-')
    end
  end

  describe '#relay_time_adjustment_print' do
    before do
      allow(helper).to receive(:time_from_seconds).and_return('00:01')
    end

    it 'should return nothing when nil given' do
      expect(helper.relay_time_adjustment_print(nil)).to eq('')
    end

    it 'should return nothing when 0 seconds given' do
      expect(helper.relay_time_adjustment_print(0)).to eq('')
    end

    it 'should return the html span block when 1 second given' do
      expect(helper.relay_time_adjustment_print(1)).to eq("(<span class='adjustment' title=\"Aika sisältää korjausta 00:01\">00:01</span>)")
    end
  end

  describe '#shot_points_print' do
    context 'when reason for no result' do
      it 'should return empty string' do
        competitor = stub_competitor 500, 88, Competitor::DNS
        expect(helper.shot_points_print(competitor)).to eq('')
      end
    end

    context 'when no shots sum' do
      it 'should return dash' do
        competitor = stub_competitor 150, nil
        expect(helper.shot_points_print(competitor)).to eq('-')
      end
    end

    context 'when no total shots wanted' do
      it 'should return shot points' do
        competitor = stub_competitor 480, 80
        expect(helper.shot_points_print(competitor)).to eq('480')
      end
    end

    context 'when total shots wanted' do
      it 'should return shot points and sum in brackets' do
        competitor = stub_competitor 480, 80
        expect(helper.shot_points_print(competitor, true)).to eq('480 (80)')
      end

      context 'and overtime penalty' do
        it 'should return penalty in brackets after shots sum' do
          competitor = stub_competitor 480, 80, nil, -9
          expect(helper.shot_points_print(competitor, true)).to eq('480 (80-9)')
        end
      end
    end

    def stub_competitor(shot_points, shots_sum, no_result_reason=nil, shooting_overtime_penalty=nil)
      instance_double Competitor, shot_points: shot_points, shots_sum: shots_sum, no_result_reason: no_result_reason,
                      shooting_overtime_penalty: shooting_overtime_penalty
    end
  end

  describe '#shots_list_print' do
    it 'should return dash when no shots sum' do
      competitor = instance_double(Competitor, :shots_sum => nil)
      expect(helper.shots_list_print(competitor)).to eq('-')
    end

    it "should return input total if such is given" do
      competitor = instance_double(Competitor, :shots_sum => 45, :shots_total_input => 45)
      expect(helper.shots_list_print(competitor)).to eq(45)
    end

    it 'should return total shots together with comma separated list of individual shots when they are defined' do
      shots = [10, 1, 9, 5, 5, 6, 4, 0]
      competitor = instance_double(Competitor, shots_sum: 50, shots_total_input: nil, shots: shots)
      expect(helper.shots_list_print(competitor)).to eq('50 (10, 1, 9, 5, 5, 6, 4, 0)')
    end
  end

  describe '#time_points_print' do
    let(:unofficials) { Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME }

    before do
      @series = instance_double(Series, :points_method => Series::POINTS_METHOD_TIME_2_ESTIMATES)
    end

    context 'when reason for no result' do
      it 'should return empty string' do
        competitor = instance_double(Competitor, :series => @series, :no_result_reason => Competitor::DNS)
        expect(helper.time_points_print(competitor)).to eq('')
      end
    end

    context 'when 300 points for all competitors in this series' do
      it 'should return 300' do
        allow(@series).to receive(:points_method).and_return(Series::POINTS_METHOD_300_TIME_2_ESTIMATES)
        competitor = instance_double(Competitor, :series => @series, :no_result_reason => nil)
        expect(helper.time_points_print(competitor)).to eq(300)
      end
    end

    context 'when no time' do
      it 'should return dash' do
        competitor = instance_double(Competitor, :time_in_seconds => nil,
                                     :no_result_reason => nil, :series => @series)
        expect(helper.time_points_print(competitor)).to eq('-')
      end
    end

    context 'when time points and time wanted' do
      it 'should return time points and time in brackets' do
        competitor = instance_double(Competitor, :series => @series,
                                     :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(unofficials).and_return(270)
        expect(helper).to receive(:time_from_seconds).with(2680).and_return('45:23')
        expect(helper.time_points_print(competitor, true, unofficials)).to eq('270 (45:23)')
      end

      it 'should wrap with best time span when full points' do
        competitor = instance_double(Competitor, :series => @series,
                                     :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(unofficials).and_return(300)
        expect(helper).to receive(:time_from_seconds).with(2680).and_return('45:23')
        expect(helper.time_points_print(competitor, true, unofficials)).
            to eq("<span class='series_best_time'>300 (45:23)</span>")
      end
    end

    context 'when time points but no time wanted' do
      it 'should return time points' do
        competitor = instance_double(Competitor, :series => @series,
                                     :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(unofficials).and_return(270)
        expect(helper.time_points_print(competitor, false, unofficials)).to eq('270')
      end

      it 'should wrap with best time span when full points' do
        competitor = instance_double(Competitor, :series => @series,
                                     :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(unofficials).and_return(300)
        expect(helper.time_points_print(competitor, false, unofficials)).
            to eq("<span class='series_best_time'>300</span>")
      end
    end
  end

  describe '#comparison_time_title_attribute' do
    let(:unofficials) { Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME }
    before do
      @competitor = instance_double(Competitor)
      allow(@competitor).to receive(:comparison_time_in_seconds).and_return(1545)
    end

    it 'should return empty string when empty always wanted' do
      expect(helper.comparison_time_title_attribute(@competitor, unofficials, true)).to eq('')
    end

    it 'should return empty string when no comparison time available' do
      allow(@competitor).to receive(:comparison_time_in_seconds).and_return(nil)
      expect(helper.comparison_time_title_attribute(@competitor, unofficials, false)).to eq('')
    end

    it 'should title and comparison time when empty not wanted' do
      expect(helper.comparison_time_title_attribute(@competitor, unofficials, false)).to eq('Vertailuaika: 25:45')
    end

    it 'should use unofficials parameter when getting the comparison time' do
      allow(@competitor).to receive(:comparison_time_in_seconds).with(unofficials).and_return(1550)
      expect(helper.comparison_time_title_attribute(@competitor, unofficials, false)).to eq('Vertailuaika: 25:50')
    end
  end

  describe '#comparison_and_own_time_title_attribute' do
    context 'when no time for competitor' do
      it 'should return empty string' do
        competitor = instance_double(Competitor)
        allow(competitor).to receive(:time_in_seconds).and_return(nil)
        expect(helper.comparison_and_own_time_title_attribute(competitor)).to eq('')
      end
    end

    context 'when no comparison time for competitor' do
      it 'should return space and title attribute with time title and time' do
        competitor = instance_double(Competitor)
        expect(competitor).to receive(:time_in_seconds).and_return(123)
        expect(competitor).to receive(:comparison_time_in_seconds).and_return(nil)
        expect(helper).to receive(:time_from_seconds).with(123).and_return('1:23')
        expect(helper.comparison_and_own_time_title_attribute(competitor)).to eq(" title='Aika: 1:23'")
      end
    end

    context 'when own and comparison time available' do
      it 'should return space and title attribute with time title, time, comparison time title and comparison time' do
        competitor = instance_double(Competitor)
        expect(competitor).to receive(:time_in_seconds).and_return(123)
        expect(competitor).to receive(:comparison_time_in_seconds).and_return(456)
        expect(helper).to receive(:time_from_seconds).with(123).and_return('1:23')
        expect(helper).to receive(:time_from_seconds).with(456).and_return('4:56')
        expect(helper.comparison_and_own_time_title_attribute(competitor)).to eq(" title='Aika: 1:23. Vertailuaika: 4:56.'")
      end
    end
  end

  describe '#national_record_print' do
    before do
      @competitor = instance_double(Competitor)
      @race = instance_double(Race)
      series = instance_double(Series)
      allow(@competitor).to receive(:series).and_return(series)
      allow(series).to receive(:race).and_return(@race)
    end

    context 'when race finished' do
      before do
        allow(@race).to receive(:finished?).and_return(true)
      end

      context 'when national record passed' do
        it 'should return SE' do
          allow(@competitor).to receive(:national_record_passed?).and_return(true)
          expect(helper.national_record_print(@competitor, true)).to eq('SE')
        end
      end

      context 'when national record reached' do
        it 'should return SE(sivuaa)' do
          allow(@competitor).to receive(:national_record_passed?).and_return(false)
          allow(@competitor).to receive(:national_record_reached?).and_return(true)
          expect(helper.national_record_print(@competitor, true)).to eq('SE(sivuaa)')
        end
      end
    end

    context 'when race not finished' do
      before do
        allow(@race).to receive(:finished?).and_return(false)
      end

      context 'when national record passed' do
        it 'should return SE?' do
          allow(@competitor).to receive(:national_record_passed?).and_return(true)
          expect(helper.national_record_print(@competitor, true)).to eq('SE?')
        end
      end

      context 'when national record reached' do
        it 'should return SE(sivuaa)?' do
          allow(@competitor).to receive(:national_record_passed?).and_return(false)
          allow(@competitor).to receive(:national_record_reached?).and_return(true)
          expect(helper.national_record_print(@competitor, true)).to eq('SE(sivuaa)?')
        end
      end
    end

    context 'with decoration' do
      it 'should surround text with span and link' do
        allow(@race).to receive(:finished?).and_return(true)
        allow(@competitor).to receive(:national_record_passed?).and_return(true)
        expect(helper.national_record_print(@competitor, false)).to eq("<span class='explanation'><a href=\"" + NATIONAL_RECORD_URL + "\">SE</a></span>")
      end
    end
  end
end