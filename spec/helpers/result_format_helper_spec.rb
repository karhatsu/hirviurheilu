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
    context 'when no adjustments' do
      it 'returns empty string' do
        source = double adjustment: nil, estimate_adjustment: nil, shooting_adjustment: nil
        expect(helper.relay_time_adjustment_print(source)).to eq ''
      end
    end

    context 'when 0 adjustments' do
      it 'returns empty string' do
        source = double adjustment: 0, estimate_adjustment: 0, shooting_adjustment: 0
        expect(helper.relay_time_adjustment_print(source)).to eq ''
      end
    end


    context 'when adjustments defined' do
      it 'returns span block with total adjustment and individual adjustments in title' do
        source = double adjustment: 35, estimate_adjustment: -20, shooting_adjustment: -100
        expected = "(<span class='adjustment' title=\"Aika sisältää arviokorjausta -00:20. Aika sisältää ammuntakorjausta -01:40. Aika sisältää muuta korjausta +00:35.\">-01:25</span>)"
        expect(helper.relay_time_adjustment_print(source)).to eq expected
      end
    end
  end

  describe '#shooting_points_print' do
    context 'when reason for no result' do
      it 'should return empty string' do
        competitor = stub_competitor 500, 88, Competitor::DNS
        expect(helper.shooting_points_print(competitor)).to eq('')
      end
    end

    context 'when no shots sum' do
      it 'should return dash' do
        competitor = stub_competitor 150, nil
        expect(helper.shooting_points_print(competitor)).to eq('-')
      end
    end

    context 'when no total shots wanted' do
      it 'should return shot points' do
        competitor = stub_competitor 480, 80
        expect(helper.shooting_points_print(competitor)).to eq('480')
      end
    end

    context 'when total shots wanted' do
      it 'should return shot points and sum in brackets' do
        competitor = stub_competitor 480, 80
        expect(helper.shooting_points_print(competitor, true)).to eq('480 (80)')
      end

      context 'and overtime penalty' do
        it 'should return penalty in brackets after shots sum' do
          competitor = stub_competitor 480, 80, nil, -9
          expect(helper.shooting_points_print(competitor, true)).to eq('480 (80-9)')
        end
      end
    end

    def stub_competitor(shooting_points, shots_sum, no_result_reason=nil, shooting_overtime_penalty=nil)
      instance_double Competitor, shooting_points: shooting_points, shots_sum: shots_sum, no_result_reason: no_result_reason,
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
            to eq("<span class='series-best-time'>300 (45:23)</span>")
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
            to eq("<span class='series-best-time'>300</span>")
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

  describe '#relay_time_print' do
    let(:relay) { instance_double Relay, penalty_seconds?: penalty_seconds? }
    let(:team) { instance_double RelayTeam }
    let(:penalty_seconds?) { nil }

    context 'when no penalty seconds' do
      before do
        expect(team).to receive(:time_in_seconds).with(nil).and_return(13 * 60 + 59)
      end

      it 'prints just relay time' do
        expect(helper.relay_time_print(relay, team)).to eql '13:59'
      end
    end

    context 'when penalty seconds' do
      let(:penalty_seconds?) { 45 }

      before do
        expect(team).to receive(:time_in_seconds).and_return(13 * 60 + 59)
        expect(team).to receive(:time_in_seconds).with(nil, true).and_return(18 * 60 + 7)
      end

      it 'prints team time with and without penalty seconds' do
        expect(helper.relay_time_print(relay, team)).to eql '18:07 (13:59)'
      end
    end

    context 'with leg' do
      let(:leg) { 2 }

      before do
        expect(team).to receive(:time_in_seconds).with(leg).and_return(9 * 60 + 58)
      end

      it 'returns leg time' do
        expect(helper.relay_time_print(relay, team, leg)).to eql '09:58'
      end
    end
  end

  describe '#relay_leg_time_print' do
    let(:relay) { instance_double Relay, penalty_seconds?: penalty_seconds? }
    let(:competitor) { instance_double RelayCompetitor }

    context 'when no penalty seconds' do
      let(:penalty_seconds?) { nil }

      before do
        expect(competitor).to receive(:time_in_seconds).and_return(4 * 60 + 12)
      end

      it 'prints just leg time' do
        expect(helper.relay_leg_time_print(relay, competitor)).to eql '04:12'
      end
    end

    context 'when penalty seconds' do
      let(:penalty_seconds?) { true }

      before do
        expect(competitor).to receive(:time_in_seconds).and_return(4 * 60 + 6)
        expect(competitor).to receive(:time_in_seconds).with(true).and_return(5 * 60 + 6)
      end

      it 'prints leg times with and without penalty seconds' do
        expect(helper.relay_leg_time_print(relay, competitor)).to eql '05:06 (04:06)'
      end
    end
  end
end
