require 'spec_helper'

describe ApplicationHelper do
  describe "#points_print" do
    before do
      @all_competitors = true
    end

    it "should print no result reason if it is defined" do
      competitor = instance_double(Competitor, :no_result_reason => Competitor::DNS)
      allow(competitor).to receive(:points).with(@all_competitors).and_return(145)
      expect(helper.points_print(competitor, @all_competitors)).to eq(
        "<span class='explanation' title='Kilpailija ei osallistunut kilpailuun'>DNS</span>"
      )
    end

    it "should print points in case they are available" do
      competitor = instance_double(Competitor, :no_result_reason => nil,
        :series => nil)
      expect(competitor).to receive(:points).with(@all_competitors).and_return(145)
      expect(helper.points_print(competitor, @all_competitors)).to eq("145")
    end

    it "should print points in brackets if only partial points are available" do
      competitor = instance_double(Competitor, :no_result_reason => nil)
      expect(competitor).to receive(:points).with(@all_competitors).and_return(nil)
      expect(competitor).to receive(:points!).with(@all_competitors).and_return(100)
      expect(helper.points_print(competitor, @all_competitors)).to eq("(100)")
    end

    it "should print - if no points at all" do
      competitor = instance_double(Competitor, :no_result_reason => nil,
        :series => nil)
      expect(competitor).to receive(:points).with(@all_competitors).and_return(nil)
      expect(competitor).to receive(:points!).with(@all_competitors).and_return(nil)
      expect(helper.points_print(competitor, @all_competitors)).to eq("-")
    end
  end
  
  describe "#cup_points_print" do
    it "should print points in case they are available" do
      competitor = double(CupCompetitor)
      expect(competitor).to receive(:points).and_return(2000)
      expect(helper.cup_points_print(competitor)).to eq("2000")
    end
    
    it "should print points in brackets if only partial points are available" do
      competitor = double(CupCompetitor)
      expect(competitor).to receive(:points).and_return(nil)
      expect(competitor).to receive(:points!).and_return(1000)
      expect(helper.cup_points_print(competitor)).to eq("(1000)")
    end
    
    it "should print '-' if no points at all" do
      competitor = double(CupCompetitor)
      expect(competitor).to receive(:points).and_return(nil)
      expect(competitor).to receive(:points!).and_return(nil)
      expect(helper.cup_points_print(competitor)).to eq("-")
    end
  end

  describe "#datetime_print" do
    before do
      @time = Time.local(2010, 5, 8, 9, 8, 1)
    end

    it "should print empty string if nil given" do
      expect(helper.datetime_print(nil)).to eq('')
    end

    it "should print d.m.Y as default format" do
      expect(helper.datetime_print(@time)).to eq('08.05.2010')
    end

    it "should include hours and minutes if asked" do
      expect(helper.datetime_print(@time, true)).to eq('08.05.2010 09:08')
    end

    it "should include hours, minutes and seconds if asked" do
      expect(helper.datetime_print(@time, true, true)).to eq('08.05.2010 09:08:01')
    end

    it "should not print seconds if H/M not wanted and seconds wanted" do
      expect(helper.datetime_print(@time, false, true)).to eq('08.05.2010')
    end

    it "should print given string instead of empty string if defined and nil" do
      expect(helper.datetime_print(nil, true, false, 'none')).to eq('none')
    end
  end

  describe "#series_start_time_print" do
    it "should call datetime_print with series date and time" do
      series = instance_double(Series)
      datetime = 'some date time'
      allow(series).to receive(:start_datetime).and_return(datetime)
      expect(helper).to receive(:datetime_print).with(datetime, true).and_return('result')
      expect(helper.series_start_time_print(series)).to eq('result')
    end
  end

  describe "#date_print" do
    it "should return DD.MM.YYYY" do
      time = Time.local(2010, 5, 8, 9, 8, 1)
      expect(helper.date_print(time)).to eq('08.05.2010')
    end
  end

  describe "#time_print" do
    before do
      @time = Time.local(2010, 5, 8, 9, 8, 1)
    end

    it "should print empty string if nil given" do
      expect(helper.time_print(nil)).to eq('')
    end

    it "should print HH:MM as default format" do
      expect(helper.time_print(@time)).to eq('09:08')
    end

    it "should include seconds if asked" do
      expect(helper.time_print(@time, true)).to eq('09:08:01')
    end

    it "should print given string instead of empty string if defined and nil" do
      expect(helper.time_print(nil, true, 'none')).to eq('none')
    end

    it "should print given string as raw instead of empty string if defined and nil" do
      expect(helper.time_print(nil, true, '&nbsp;')).to eq('&nbsp;')
    end
  end

  describe "#time_from_seconds" do
    it "should return dash when nil given" do
      expect(helper.time_from_seconds(nil)).to eq("-")
    end

    it "should return seconds when less than 60" do
      expect(helper.time_from_seconds(59)).to eq("00:59")
    end

    it "should return minutes and seconds when more than 60" do
      expect(helper.time_from_seconds(60)).to eq("01:00")
      expect(helper.time_from_seconds(61)).to eq("01:01")
      expect(helper.time_from_seconds(131)).to eq("02:11")
    end

    it "should return hours, minutes and seconds when at least 1 hour" do
      expect(helper.time_from_seconds(3600)).to eq("1:00:00")
      expect(helper.time_from_seconds(3601)).to eq("1:00:01")
    end

    it "should convert decimal seconds to integer" do
      expect(helper.time_from_seconds(60.0)).to eq("01:00")
      expect(helper.time_from_seconds(61.1)).to eq("01:01")
      expect(helper.time_from_seconds(131.2)).to eq("02:11")
      expect(helper.time_from_seconds(3601.6)).to eq("1:00:01")
    end

    it "should return negative hours, minutes and seconds when at least 1 hour" do
      expect(helper.time_from_seconds(-3600)).to eq("-1:00:00")
      expect(helper.time_from_seconds(-3601)).to eq("-1:00:01")
    end
    it "should return hours, minutes and seconds with minus or plus sign when alwayssigned" do
      expect(helper.time_from_seconds(3600, true)).to eq("+1:00:00")
      expect(helper.time_from_seconds(3601, true)).to eq("+1:00:01")
      expect(helper.time_from_seconds(-3601, true)).to eq("-1:00:01")
    end
  end

  describe "#relay_time_adjustment" do
    before do
      allow(helper).to receive(:time_from_seconds).and_return('00:01')
    end

    it "should return nothing when nil given" do
      expect(helper.relay_time_adjustment(nil)).to eq("")
    end

    it "should return nothing when 0 seconds given" do
      expect(helper.relay_time_adjustment(0)).to eq("")
    end

    it "should return the html span block when 1 second given" do
      expect(helper.relay_time_adjustment(1)).to eq("(<span class='adjustment' title=\"Aika sisältää korjausta 00:01\">00:01</span>)")
    end
  end

  describe "#shot_points" do
    context "when reason for no result" do
      it "should return empty string" do
        competitor = instance_double(Competitor, :shots_sum => 88,
          :no_result_reason => Competitor::DNS)
        expect(helper.shot_points(competitor)).to eq('')
      end
    end

    context "when no shots sum" do
      it "should return dash" do
        competitor = instance_double(Competitor, :shots_sum => nil,
          :no_result_reason => nil)
        expect(helper.shot_points(competitor)).to eq("-")
      end
    end

    context "when no total shots wanted" do
      it "should return shot points" do
        competitor = instance_double(Competitor, :shot_points => 480, :shots_sum => 80,
          :no_result_reason => nil)
        expect(helper.shot_points(competitor, false)).to eq("480")
      end
    end

    context "when total shots wanted" do
      it "should return shot points and sum in brackets" do
        competitor = instance_double(Competitor, :shot_points => 480, :shots_sum => 80,
          :no_result_reason => nil)
        expect(helper.shot_points(competitor, true)).to eq("480 (80)")
      end
    end
  end

  describe "#shots_list" do
    it "should return dash when no shots sum" do
      competitor = instance_double(Competitor, :shots_sum => nil)
      expect(helper.shots_list(competitor)).to eq("-")
    end

    it "should return input total if such is given" do
      competitor = instance_double(Competitor, :shots_sum => 45, :shots_total_input => 45)
      expect(helper.shots_list(competitor)).to eq(45)
    end

    it "should return comma separated list if individual shots defined" do
      shots = [10, 1, 9, 5, 5, nil, nil, 6, 4, 0]
      competitor = instance_double(Competitor, :shots_sum => 50,
        :shots_total_input => nil, :shot_values => shots)
      expect(helper.shots_list(competitor)).to eq("10,1,9,5,5,0,0,6,4,0")
    end
  end

  describe "#print_estimate_diff" do
    it "should return empty string when nil given" do
      expect(helper.print_estimate_diff(nil)).to eq("-")
    end

    it "should return negative diff with minus sign" do
      expect(helper.print_estimate_diff(-12)).to eq("-12")
    end

    it "should return positive diff with plus sign" do
      expect(helper.print_estimate_diff(13)).to eq("+13")
    end
  end

  describe "#estimate_diffs" do
    describe "2 estimates" do
      before do
        @series = instance_double(Series, :estimates => 2)
      end

      it "should return empty string when no estimates" do
        competitor = instance_double(Competitor, :estimate1 => nil, :estimate2 => nil,
          :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("")
      end

      it "should return first and dash when first is available" do
        competitor = instance_double(Competitor, :estimate1 => 50, :estimate2 => nil,
          :estimate_diff1_m => 10, :estimate_diff2_m => nil, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("+10m/-")
      end

      it "should return dash and second when second is available" do
        competitor = instance_double(Competitor, :estimate1 => nil, :estimate2 => 60,
          :estimate_diff1_m => nil, :estimate_diff2_m => -5, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("-/-5m")
      end

      it "should return both when both are available" do
        competitor = instance_double(Competitor, :estimate1 => 120, :estimate2 => 60,
          :estimate_diff1_m => -5, :estimate_diff2_m => 14, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("-5m/+14m")
      end
    end

    describe "4 estimates" do
      before do
        @series = instance_double(Series, :estimates => 4)
      end

      it "should return empty string when no estimates" do
        competitor = instance_double(Competitor, :estimate1 => nil, :estimate2 => nil,
          :estimate3 => nil, :estimate4 => nil, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("")
      end

      it "should return dash for others when only third is available" do
        competitor = instance_double(Competitor, :estimate1 => 50, :estimate2 => nil,
          :estimate_diff1_m => nil, :estimate_diff2_m => nil,
          :estimate_diff3_m => 12, :estimate_diff4_m => nil, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("-/-/+12m/-")
      end

      it "should return dash for others when only fourth is available" do
        competitor = instance_double(Competitor, :estimate1 => 50, :estimate2 => nil,
          :estimate_diff1_m => nil, :estimate_diff2_m => nil,
          :estimate_diff3_m => nil, :estimate_diff4_m => -5, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("-/-/-/-5m")
      end

      it "should return dash for third when others are available" do
        competitor = instance_double(Competitor, :estimate1 => 50, :estimate2 => nil,
          :estimate_diff1_m => 10, :estimate_diff2_m => -9,
          :estimate_diff3_m => nil, :estimate_diff4_m => 12, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("+10m/-9m/-/+12m")
      end

      it "should return dash for fourth when others are available" do
        competitor = instance_double(Competitor, :estimate1 => nil, :estimate2 => 60,
          :estimate_diff1_m => 10, :estimate_diff2_m => -5,
          :estimate_diff3_m => 12, :estimate_diff4_m => nil, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("+10m/-5m/+12m/-")
      end

      it "should return all diffs when all are available" do
        competitor = instance_double(Competitor, :estimate1 => 120, :estimate2 => 60,
          :estimate_diff1_m => -5, :estimate_diff2_m => 14,
          :estimate_diff3_m => 12, :estimate_diff4_m => -1, :series => @series)
        expect(helper.estimate_diffs(competitor)).to eq("-5m/+14m/+12m/-1m")
      end
    end
  end

  describe "#estimate_points" do
    it "should print empty string if no result reason defined" do
      competitor = instance_double(Competitor, :shots_sum => 88,
        :no_result_reason => Competitor::DNS)
      expect(helper.estimate_points(competitor)).to eq('')
    end

    it "should return dash if no estimate points" do
      competitor = instance_double(Competitor, :estimate_points => nil,
        :no_result_reason => nil)
      expect(helper.estimate_points(competitor)).to eq("-")
    end

    it "should return points otherwise" do
      competitor = instance_double(Competitor, :estimate_points => 189,
        :no_result_reason => nil)
      expect(helper.estimate_points(competitor)).to eq(189)
    end
  end

  describe "#estimate_points_and_diffs" do
    it "should print empty string if no result reason defined" do
      competitor = instance_double(Competitor, :shots_sum => 88,
        :no_result_reason => Competitor::DNS)
      expect(helper.estimate_points_and_diffs(competitor)).to eq('')
    end

    it "should return dash if no estimate points" do
      competitor = instance_double(Competitor, :estimate_points => nil,
        :no_result_reason => nil)
      expect(helper.estimate_points_and_diffs(competitor)).to eq("-")
    end

    it "should return points and diffs when points available" do
      competitor = instance_double(Competitor, :estimate_points => 189,
        :no_result_reason => nil)
      expect(helper).to receive(:estimate_diffs).with(competitor).and_return("3m")
      expect(helper.estimate_points_and_diffs(competitor)).to eq("189 (3m)")
    end
  end

  describe "#correct_estimate" do
    it "should raise error when index less than 1" do
      expect { helper.correct_estimate(nil, 0, '') }.to raise_error
    end

    it "should raise error when index more than 4" do
      expect { helper.correct_estimate(nil, 5, '') }.to raise_error
    end

    context "race not finished" do
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

    context "race finished" do
      context "estimates available" do
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

      context "estimates not available" do
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

  describe "#time_points" do
    before do
      @series = instance_double(Series, :time_points_type => Series::TIME_POINTS_TYPE_NORMAL)
    end

    context "when reason for no result" do
      it "should return empty string" do
        competitor = instance_double(Competitor, :series => @series,
          :no_result_reason => Competitor::DNS)
        expect(helper.time_points(competitor)).to eq('')
      end
    end
  
    context "when 300 points for all competitors in this series" do
      it "should return 300" do
        allow(@series).to receive(:time_points_type).and_return(Series::TIME_POINTS_TYPE_ALL_300)
        competitor = instance_double(Competitor, :series => @series, :no_result_reason => nil)
        expect(helper.time_points(competitor)).to eq(300)
      end
    end
  
    context "when no time" do
      it "should return dash" do
        competitor = instance_double(Competitor, :time_in_seconds => nil,
          :no_result_reason => nil, :series => @series)
        expect(helper.time_points(competitor)).to eq("-")
      end
    end
  
    context "when time points and time wanted" do
      it "should return time points and time in brackets" do
        all_competitors = true
        competitor = instance_double(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(all_competitors).and_return(270)
        expect(helper).to receive(:time_from_seconds).with(2680).and_return("45:23")
        expect(helper.time_points(competitor, true, all_competitors)).to eq("270 (45:23)")
      end
  
      it "should wrap with best time span when full points" do
        all_competitors = true
        competitor = instance_double(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(all_competitors).and_return(300)
        expect(helper).to receive(:time_from_seconds).with(2680).and_return("45:23")
        expect(helper.time_points(competitor, true, all_competitors)).
          to eq("<span class='series_best_time'>300 (45:23)</span>")
      end
    end
    
    context "when time points but no time wanted" do
      it "should return time points" do
        all_competitors = true
        competitor = instance_double(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(all_competitors).and_return(270)
        expect(helper.time_points(competitor, false, all_competitors)).to eq("270")
      end
  
      it "should wrap with best time span when full points" do
        all_competitors = true
        competitor = instance_double(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        expect(competitor).to receive(:time_points).with(all_competitors).and_return(300)
        expect(helper.time_points(competitor, false, all_competitors)).
          to eq("<span class='series_best_time'>300</span>")
      end
    end
  end

  describe "#full_name" do
    specify { expect(helper.full_name(instance_double(Competitor, :last_name => "Tester",
        :first_name => "Tim"))).to eq("Tester Tim") }

    describe "first name first" do
      specify { expect(helper.full_name(instance_double(Competitor, :last_name => "Tester",
          :first_name => "Tim"), true)).to eq("Tim Tester") }
    end
  end

  describe "#date_interval" do
    it "should print start - end when dates differ" do
      expect(helper.date_interval("2010-08-01".to_date, "2010-08-03".to_date, false)).
        to eq("01.08.2010 - 03.08.2010")
    end

    it "should print only start date when end date is same" do
      expect(helper.date_interval("2010-08-03".to_date, "2010-08-03".to_date, false)).
        to eq("03.08.2010")
    end

    it "should print only start date when end date is nil" do
      expect(helper.date_interval("2010-08-03".to_date, nil, false)).to eq("03.08.2010")
    end

    it 'should include time tag if it is wanted' do
      expect(helper.date_interval("2015-01-18".to_date, nil)).to eq("<time itemprop='startDate' datetime='2015-01-18'>18.01.2015</time>")
    end
  end

  describe "#race_date_interval" do
    it "should call date_interval with race dates" do
      race = FactoryGirl.build(:race)
      expect(helper).to receive(:date_interval).with(race.start_date, race.end_date, true).
        and_return('result')
      expect(helper.race_date_interval(race)).to eq('result')
    end
  end

  describe "#yes_or_empty" do
    context "when boolean is true" do
      it "should return yes icon" do
        expect(helper.yes_or_empty('test')).to match(/<img.* src=.*icon_yes.gif.*\/>/)
      end
    end

    context "when boolean is false" do
      it "should return html space when no block given" do
        expect(helper.yes_or_empty(nil)).to eq('&nbsp;')
      end

      it "should call block when block given" do
        s = double(Series)
        expect(s).to receive(:id)
        helper.yes_or_empty(false) do s.id end
      end
    end
  end

  describe "#value_or_space" do
    it "should return value when value is available" do
      expect(helper.value_or_space('test')).to eq('test')
    end

    it "should return html space when value not available" do
      expect(helper.value_or_space(nil)).to eq('&nbsp;')
      expect(helper.value_or_space(false)).to eq('&nbsp;')
    end
  end

  describe "#start_days_form_field" do
    before do
      @f = double(String)
      @race = instance_double(Race, :start_date => '2010-12-20')
      @series = instance_double(Series, :race => @race)
    end

    context "when only one start day" do
      it "should return hidden field with value 1" do
        expect(@series).to receive(:start_day=).with(1)
        expect(@f).to receive(:hidden_field).with(:start_day).and_return("input")
        allow(@race).to receive(:days_count).and_return(1)
        expect(helper.start_days_form_field(@f, @series)).to eq("input")
      end
    end

    context "when more than one day" do
      it "should return dropdown menu with different dates" do
        expect(@series).to receive(:start_day).and_return(2)
        options = options_for_select([['20.12.2010', 1], ['21.12.2010', 2]], 2)
        expect(@f).to receive(:select).with(:start_day, options).and_return("select")
        allow(@race).to receive(:days_count).and_return(2)
        expect(helper.start_days_form_field(@f, @series)).to eq("select")
      end
    end
  end

  describe "#offline?" do
    it "should return true when Mode.offline? returns true" do
      allow(Mode).to receive(:offline?).and_return(true)
      expect(helper).to be_offline
    end

    it "should return true when Mode.offline? returns false" do
      allow(Mode).to receive(:offline?).and_return(false)
      expect(helper).not_to be_offline
    end
  end

  describe "#link_with_protocol" do
    it "should return the given link if it starts with http://" do
      expect(helper.link_with_protocol('http://www.test.com')).to eq('http://www.test.com')
    end

    it "should return the given link if it starts with https://" do
      expect(helper.link_with_protocol('https://www.test.com')).to eq('https://www.test.com')
    end

    it "should return http protocol + the given link if the protocol is missing" do
      expect(helper.link_with_protocol('www.test.com')).to eq('http://www.test.com')
    end
  end

  describe "#next_result_rotation" do
    let(:request) { double }
    let(:race) { instance_double Race }

    before do
      allow(helper).to receive(:request).and_return(request)
    end

    context "when url list is empty" do
      before do
        expect(helper).to receive(:result_rotation_list).with(race).and_return([])
      end

      it "should return the current url" do
        allow(request).to receive(:fullpath).and_return('/here/i/am')
        expect(helper.next_result_rotation(race)).to eq('/here/i/am')
      end
    end
    
    context "when url list is not empty" do
      before do
        @result_rotation_list = ['/first', '/second', '/third']
        expect(helper).to receive(:result_rotation_list).with(race).and_return(@result_rotation_list)
      end

      context "when current url is unknown" do
        it "should return first url from url rotation" do
          allow(request).to receive(:fullpath).and_return('/unknown')
          expect(helper.next_result_rotation(race)).to eq(@result_rotation_list[0])
        end
      end

      context "when existing url is given" do
        it "should return next url from url rotation" do
          allow(request).to receive(:fullpath).and_return(@result_rotation_list[0])
          expect(helper.next_result_rotation(race)).to eq(@result_rotation_list[1])
        end
      end

      context "when another existing url is given" do
        it "should return next url from url rotation" do
          allow(request).to receive(:fullpath).and_return(@result_rotation_list[1])
          expect(helper.next_result_rotation(race)).to eq(@result_rotation_list[2])
        end
      end

      context "when last url is given" do
        it "should return first url from url rotation" do
          allow(request).to receive(:fullpath).and_return(@result_rotation_list[2])
          expect(helper.next_result_rotation(race)).to eq(@result_rotation_list[0])
        end
      end
    end
  end

  describe "#result_rotation_list" do
    describe "aggregate" do
      before do
        @race = instance_double(Race)
        allow(helper).to receive(:result_rotation_series_list).with(@race).and_return(['series1', 'series2'])
        allow(helper).to receive(:result_rotation_tc_list).with(@race).and_return(['tc1', 'tc2'])
        allow(helper).to receive(:result_rotation_tc_cookie).and_return(true)
      end

      context "when offline" do
        it "should return an empty list when offline" do
          allow(Mode).to receive(:offline?).and_return(true)
          expect(helper.result_rotation_list(@race)).to be_empty
        end
      end

      context "when online" do
        before do
          allow(Mode).to receive(:offline?).and_return(false)
        end

        it "should return all paths when all available" do
          list = helper.result_rotation_list(@race)
          expect(list.size).to eq(4)
          expect(list[0]).to eq('series1')
          expect(list[1]).to eq('series2')
          expect(list[2]).to eq('tc1')
          expect(list[3]).to eq('tc2')
        end

        it "should not return series paths nor team competition paths if no series" do
          expect(helper).to receive(:result_rotation_series_list).with(@race).and_return([])
          expect(helper.result_rotation_list(@race)).to be_empty
        end

        it "should not return team competition paths unless cookie for that" do
          allow(helper).to receive(:result_rotation_tc_cookie).and_return(false)
          list = helper.result_rotation_list(@race)
          expect(list.size).to eq(2)
          expect(list[0]).to eq('series1')
          expect(list[1]).to eq('series2')
        end
      end
    end

    describe "#result_rotation_series_list" do
      it "should return an empty list when race in the future" do
        race = FactoryGirl.create(:race, :start_date => Date.today - 1)
        race.series << build_series(race, 1, '0:00')
        expect(result_rotation_series_list(race).size).to eq(0)
      end

      it "should return an empty list when race was in the past" do
        race = FactoryGirl.create(:race, :start_date => Date.today - 2,
          :end_date => Date.today - 1)
        race.series << build_series(race, 1, '0:00')
        expect(result_rotation_series_list(race).size).to eq(0)
      end

      context "when race is ongoing today" do
        before do
          @race = FactoryGirl.create(:race, :start_date => Date.today,
            :end_date => Date.today + 1)
          @series1_1 = build_series(@race, 1, '0:00')
          @series1_2 = build_series(@race, 1, '0:00')
          @series1_3 = build_series(@race, 1, '23:59')
          @series2_1 = build_series(@race, 2, '0:00')
          @series2_2 = build_series(@race, 2, '23:59')
          @race.series << @series1_1
          @race.series << @series1_2
          @race.series << @series1_3
          @race.series << @series2_1
          @race.series << @series2_2
        end

        context "when race has started today" do
          it "should return the paths for started series today" do
            list = result_rotation_series_list(@race)
            expect(list.size).to eq(2)
            expect(list[0]).to eq(series_competitors_path(nil, @series1_1))
            expect(list[1]).to eq(series_competitors_path(nil, @series1_2))
          end
        end

        context "when race started yesterday" do
          it "should return the paths for started series today" do
            @race.start_date = Date.today - 1
            @race.end_date = Date.today
            @race.save!
            list = result_rotation_series_list(@race)
            expect(list.size).to eq(1)
            expect(list[0]).to eq(series_competitors_path(nil, @series2_1))
          end
        end
      end

      def build_series(race, start_day, start_time)
        series = FactoryGirl.build(:series, :race => race, :start_day => start_day,
          :start_time => start_time)
        series.competitors << FactoryGirl.build(:competitor, :series => series, :estimate1 => 100)
        series
      end
    end

    describe "#result_rotation_tc_list" do
      before do
        @race = FactoryGirl.create(:race, :start_date => Date.today,
          :end_date => Date.today + 1)
        @tc1 = build_team_competition(@race)
        @tc2 = build_team_competition(@race)
        @race.team_competitions << @tc1
        @race.team_competitions << @tc2
      end

      it "should return the paths for team competitions" do
        list = result_rotation_tc_list(@race)
        expect(list.size).to eq(2)
        expect(list[0]).to eq(race_team_competition_path(nil, @race, @tc1))
        expect(list[1]).to eq(race_team_competition_path(nil, @race, @tc2))
      end

      def build_team_competition(race)
        FactoryGirl.build(:team_competition, :race => race)
      end
    end
  end

  describe "#series_result_title" do
    before do
      @competitors = double(Array)
      allow(@competitors).to receive(:empty?).and_return(false)
      @race = instance_double(Race, :finished? => false)
      @series = instance_double(Series, :race => @race, :competitors => @competitors, :started? => true)
    end
    
    it "should return '(Ei kilpailijoita)' when no competitors" do
      expect(@competitors).to receive(:empty?).and_return(true)
      expect(series_result_title(@series)).to eq('(Ei kilpailijoita)')
    end
    
    it "should return '(Sarja ei ole vielä alkanut)' when the series has not started yet" do
      expect(@series).to receive(:started?).and_return(false)
      expect(series_result_title(@series)).to eq('(Sarja ei ole vielä alkanut)')
    end
    
    it "should return 'Tulokset' when competitors and the race is finished" do
      expect(@race).to receive(:finished?).and_return(true)
      expect(series_result_title(@series)).to eq('Tulokset')
    end

    it "should return 'Tilanne (päivitetty: <time>)' when series still active" do
      original_zone = Time.zone
      Time.zone = 'Tokyo' # UTC+9 (without summer time so that test settings won't change) 
      time = Time.utc(2011, 5, 13, 13, 45, 58)
      expect(@series).to receive(:competitors).and_return(@competitors)
      expect(@competitors).to receive(:maximum).with(:updated_at).and_return(time) # db return UTC
      expect(series_result_title(@series)).to eq('Tilanne (päivitetty: 13.05.2011 22:45:58)')
      Time.zone = original_zone
    end

    it "should return 'Tulokset - Kaikki kilpailijat' when all competitors and the race is finished" do
      expect(@race).to receive(:finished?).and_return(true)
      expect(series_result_title(@series, true)).to eq('Tulokset - Kaikki kilpailijat')
    end

    it "should return 'Tilanne (päivitetty: <time>) - Kaikki kilpailijat' when all competitors and series still active" do
      original_zone = Time.zone
      Time.zone = 'Tokyo' # UTC+9 (without summer time so that test settings won't change)
      time = Time.utc(2011, 5, 13, 13, 45, 58)
      expect(@series).to receive(:competitors).and_return(@competitors)
      expect(@competitors).to receive(:maximum).with(:updated_at).and_return(time) # db return UTC
      expect(series_result_title(@series, true)).to eq('Tilanne (päivitetty: 13.05.2011 22:45:58) - Kaikki kilpailijat')
      Time.zone = original_zone
    end
  end

  describe "#series_result_title" do
    before do
      @competitors = double(Array)
      @teams = double(Array)
      allow(@teams).to receive(:empty?).and_return(false)
      @race = instance_double(Race)
      @relay = instance_double(Relay, :race => @race, :started? => true,
        :relay_teams => @teams, :finished? => false)
    end
    
    it "should return '(Ei joukkueita)' when no teams" do
      expect(@teams).to receive(:empty?).and_return(true)
      expect(relay_result_title(@relay)).to eq('(Ei joukkueita)')
    end
    
    it "should return '(Viesti ei ole vielä alkanut)' when the relay has not started yet" do
      expect(@relay).to receive(:started?).and_return(false)
      expect(relay_result_title(@relay)).to eq('(Viesti ei ole vielä alkanut)')
    end
    
    it "should return 'Tulokset' when teams and the race is finished" do
      expect(@relay).to receive(:finished?).and_return(true)
      expect(relay_result_title(@relay)).to eq('Tulokset')
    end

    it "should return 'Tilanne (päivitetty: <time>)' when relay still active" do
      original_zone = Time.zone
      Time.zone = 'Tokyo' # UTC+9 (without summer time so that test settings won't change) 
      time = Time.utc(2011, 5, 13, 13, 45, 58)
      expect(@relay).to receive(:relay_competitors).and_return(@competitors)
      expect(@competitors).to receive(:maximum).with(:updated_at).and_return(time) # db return UTC
      expect(relay_result_title(@relay)).to eq('Tilanne (päivitetty: 13.05.2011 22:45:58)')
      Time.zone = original_zone
    end
  end

  describe "#correct_estimate_range" do
    it "should return min_number- if no max_number" do
      ce = FactoryGirl.build(:correct_estimate, :min_number => 56, :max_number => nil)
      expect(helper.correct_estimate_range(ce)).to eq("56-")
    end

    it "should return min_number if max_number equals to it" do
      ce = FactoryGirl.build(:correct_estimate, :min_number => 57, :max_number => 57)
      expect(helper.correct_estimate_range(ce)).to eq(57)
    end

    it "should return min_number-max_number if both defined and different" do
      ce = FactoryGirl.build(:correct_estimate, :min_number => 57, :max_number => 58)
      expect(helper.correct_estimate_range(ce)).to eq("57-58")
    end
  end
  
  describe "#time_title" do
    before do
      @sport = instance_double(Sport)
      @race = instance_double(Race, :sport => @sport)
    end
    
    it "should be 'Juoksu' when run sport" do
      allow(@sport).to receive(:run?).and_return(true)
      expect(helper.time_title(@race)).to eq('Juoksu')
    end
    
    it "should be 'Hiihto' when no run sport" do
      allow(@sport).to receive(:run?).and_return(false)
      expect(helper.time_title(@race)).to eq('Hiihto')
    end
  end

  describe "#club_title" do
    it "should be 'Piiri' when club level such" do
      race = FactoryGirl.build(:race, :club_level => Race::CLUB_LEVEL_PIIRI)
      expect(helper.club_title(race)).to eq('Piiri')
    end

    it "should be 'Seura' when club level such" do
      race = FactoryGirl.build(:race, :club_level => Race::CLUB_LEVEL_SEURA)
      expect(helper.club_title(race)).to eq('Seura')
    end

    it "should throw exception when unknown club level" do
      race = FactoryGirl.build(:race, :club_level => 100)
      expect { helper.club_title(race) }.to raise_error
    end
  end

  describe "#clubs_title" do
    it "should be 'Piirit' when club level such" do
      race = FactoryGirl.build(:race, :club_level => Race::CLUB_LEVEL_PIIRI)
      expect(helper.clubs_title(race)).to eq('Piirit')
    end

    it "should be 'Seurat' when club level such" do
      race = FactoryGirl.build(:race, :club_level => Race::CLUB_LEVEL_SEURA)
      expect(helper.clubs_title(race)).to eq('Seurat')
    end

    it "should throw exception when unknown club level" do
      race = FactoryGirl.build(:race, :club_level => 100)
      expect { helper.clubs_title(race) }.to raise_error
    end
  end
  
  describe "#comparison_time_title" do
    before do
      @competitor = instance_double(Competitor)
      allow(@competitor).to receive(:comparison_time_in_seconds).and_return(1545)
    end
    
    it "should return empty string when empty always wanted" do
      expect(helper.comparison_time_title(@competitor, true, true)).to eq('')
    end
    
    it "should return empty string when no comparison time available" do
      allow(@competitor).to receive(:comparison_time_in_seconds).and_return(nil)
      expect(helper.comparison_time_title(@competitor, true, false)).to eq('')
    end
    
    it "should return space and title attribute with title and comparison time when empty not wanted" do
      expect(helper.comparison_time_title(@competitor, true, false)).to eq(" title='Vertailuaika: 25:45'")
    end
    
    it "should use all_competitors parameter when getting the comparison time" do
      allow(@competitor).to receive(:comparison_time_in_seconds).with(false).and_return(1550)
      expect(helper.comparison_time_title(@competitor, false, false)).to eq(" title='Vertailuaika: 25:50'")
    end
  end
  
  describe "#comparison_and_own_time_title" do
    context "when no time for competitor" do
      it "should return empty string" do
        competitor = instance_double(Competitor)
        allow(competitor).to receive(:time_in_seconds).and_return(nil)
        expect(helper.comparison_and_own_time_title(competitor)).to eq('')
      end
    end
  
    context "when no comparison time for competitor" do
      it "should return space and title attribute with time title and time" do
        competitor = instance_double(Competitor)
        expect(competitor).to receive(:time_in_seconds).and_return(123)
        expect(competitor).to receive(:comparison_time_in_seconds).with(false).and_return(nil)
        expect(helper).to receive(:time_from_seconds).with(123).and_return('1:23')
        expect(helper.comparison_and_own_time_title(competitor)).to eq(" title='Aika: 1:23'")
      end
    end

    context "when own and comparison time available" do
      it "should return space and title attribute with time title, time, comparison time title and comparison time" do
        competitor = instance_double(Competitor)
        expect(competitor).to receive(:time_in_seconds).and_return(123)
        expect(competitor).to receive(:comparison_time_in_seconds).with(false).and_return(456)
        expect(helper).to receive(:time_from_seconds).with(123).and_return('1:23')
        expect(helper).to receive(:time_from_seconds).with(456).and_return('4:56')
        expect(helper.comparison_and_own_time_title(competitor)).to eq(" title='Aika: 1:23. Vertailuaika: 4:56.'")
      end
    end
  end
  
  describe "#shots_total_title" do
    it "should return empty string when no shots sum for competitor" do
      competitor = instance_double(Competitor)
      expect(competitor).to receive(:shots_sum).and_return(nil)
      expect(helper.shots_total_title(competitor)).to eq('')
    end
    
    it "should return space and title attribute with title and shots sum when sum available" do
      competitor = instance_double(Competitor)
      expect(competitor).to receive(:shots_sum).and_return(89)
      expect(helper.shots_total_title(competitor)).to eq(" title='Ammuntatulos: 89'")
    end
  end
  
  describe "#title_prefix" do
    it "should be '(Dev) ' when development environment" do
      allow(Rails).to receive(:env).and_return('development')
      expect(helper.title_prefix).to eq('(Dev) ')
    end
    
    it "should be '(Testi) ' when test environment" do
      allow(Rails).to receive(:env).and_return('test')
      expect(helper.title_prefix).to eq('(Testi) ')
    end
    
    it "should be '(Testi) ' when staging environment" do
      allow(Rails).to receive(:env).and_return('staging')
      expect(helper.title_prefix).to eq('(Testi) ')
    end
    
    it "should be '(Offline) ' when offline production environment" do
      allow(Rails).to receive(:env).and_return('winoffline-prod')
      expect(helper.title_prefix).to eq('(Offline) ')
    end
    
    it "should be '(Offline-dev) ' when offline development environment" do
      allow(Rails).to receive(:env).and_return('winoffline-dev')
      expect(helper.title_prefix).to eq('(Offline-dev) ')
    end
    
    it "should be '' when production environment" do
      allow(Rails).to receive(:env).and_return('production')
      expect(helper.title_prefix).to eq('')
    end
  end
  
  describe "#long_cup_series_name" do
    it "should be cup series name when no series names" do
      cs = FactoryGirl.build(:cup_series, :name => 'Series')
      expect(cs).to receive(:has_single_series_with_same_name?).and_return(true)
      expect(helper.long_cup_series_name(cs)).to eq('Series')
    end
    
    it "should be cup series name and series names in brackets when given" do
      cs = FactoryGirl.build(:cup_series, :name => 'Series', :series_names => 'M,M50,M80')
      expect(cs).to receive(:has_single_series_with_same_name?).and_return(false)
      expect(helper.long_cup_series_name(cs)).to eq('Series (M, M50, M80)')
    end
  end
  
  describe "#remove_child_link" do
    before do
      @value = 'Add child'
      @form = double(Object)
      @hide_class = 'hide_class'
      @confirm_question = 'Are you sure?'
      expect(@form).to receive(:hidden_field).with(:_destroy).and_return('<hidden-field/>')
    end

    it "should return hidden _destroy field and button with onclick call to remove_fields javascript" do
      expect(helper.remove_child_link(@value, @form, @hide_class, @confirm_question)).
        to eq("<hidden-field/><input type=\"button\" value=\"Add child\" onclick=\"remove_fields(this, &#39;hide_class&#39;, &#39;Are you sure?&#39;);\" />")
    end
  end
  
  describe "#add_child_link" do
    before do
      @value = 'Add child'
      @form = double(Object)
      @method = 'method'
      expect(helper).to receive(:new_child_fields).with(@form, @method).and_return('<div id="f">fields</div>')
    end

    context "without id" do    
      it "should return button with onclick call to insert_fields javascript as escaped" do
        expect(helper.add_child_link(@value, @form, @method)).
          to eq('<input type="button" value="Add child" onclick="insert_fields(this, &quot;method&quot;, &quot;&lt;div id=\\&quot;f\\&quot;&gt;fields&lt;\\/div&gt;&quot;);" />')
      end
    end

    context "with id" do    
      it "should return button with id and onclick call to insert_fields javascript" do
        expect(helper.add_child_link(@value, @form, @method, 'myid')).
          to eq('<input type="button" value="Add child" onclick="insert_fields(this, &quot;method&quot;, &quot;&lt;div id=\\&quot;f\\&quot;&gt;fields&lt;\\/div&gt;&quot;);" id="myid" />')
      end
    end
  end
  
  describe "#competition_icon" do
    context "when single race" do
      it "should be image tag for competition's sport's lower case key with _icon.gif suffix" do
        sport = instance_double(Sport, :key => 'RUN', :initials => 'HJ')
        expect(helper).to receive(:image_tag).with("run_icon.gif", alt: 'HJ', class: 'competition_icon').and_return("image")
        expect(helper.competition_icon(instance_double(Race, :sport => sport))).to eq("image")
      end
    end
    
    context "when cup" do
      it "should be image tag for cup's sport's lower case key with _icon_cup.gif suffix" do
        sport = FactoryGirl.build :sport, key: 'SKI'
        expect(sport).to receive(:initials).and_return('HH')
        expect(helper).to receive(:image_tag).with("ski_icon_cup.gif", alt: 'HH', class: 'competition_icon').and_return("cup-image")
        cup = FactoryGirl.build :cup
        allow(cup).to receive(:sport).and_return(sport)
        expect(helper.competition_icon(cup)).to eq("cup-image")
      end
    end
  end
  
  describe "#facebook_env?" do
    it "should be true for development" do
      allow(Rails).to receive(:env).and_return('development')
      expect(helper.facebook_env?).to be_truthy
    end
    
    it "should be true for production" do
      allow(Rails).to receive(:env).and_return('production')
      expect(helper.facebook_env?).to be_truthy
    end
    
    it "should be false for all others" do
      allow(Rails).to receive(:env).and_return('test')
      expect(helper.facebook_env?).to be_falsey
    end
  end
  
  describe "#refresh_counter_min_seconds" do
    it { expect(helper.refresh_counter_min_seconds).to eq(20) }
  end
  
  describe "#refresh_counter_default_seconds" do
    it { expect(helper.refresh_counter_default_seconds).to eq(30) }
  end
  
  describe "#refresh_counter_auto_scroll" do
    context "when menu_series defined and result rotation auto scroll cookie defined" do
      it "should return true" do
        expect(helper).to receive(:menu_series).and_return(instance_double(Series))
        expect(helper).to receive(:result_rotation_auto_scroll).and_return('cookie')
        expect(helper.refresh_counter_auto_scroll).to be_truthy
      end
    end
    
    context "when menu_series not available" do
      it "should return false" do
        expect(helper).to receive(:menu_series).and_return(nil)
        expect(helper.refresh_counter_auto_scroll).to be_falsey
      end
    end
    
    context "when result rotation auto scroll cookie not available" do
      it "should return false" do
        expect(helper).to receive(:menu_series).and_return(instance_double(Series))
        expect(helper).to receive(:result_rotation_auto_scroll).and_return(nil)
        expect(helper.refresh_counter_auto_scroll).to be_falsey
      end
    end
  end
  
  describe "#refresh_counter_seconds" do
    context "when explicit seconds given" do
      it "should return given seconds" do
        expect(helper.refresh_counter_seconds(25)).to eq(25)
      end
    end
    
    context "when no explicit seconds" do
      context "and no autoscroll" do
        it "should return refresh counter default seconds" do
          expect(helper).to receive(:refresh_counter_auto_scroll).and_return(false)
          expect(helper.refresh_counter_seconds).to eq(helper.refresh_counter_default_seconds)
        end
      end
      
      context "and autoscroll" do
        context "but no menu series" do
          it "should return refresh counter default seconds" do
            competitors = double(Array)
            expect(helper).to receive(:refresh_counter_auto_scroll).and_return(true)
            expect(helper).to receive(:menu_series).and_return(nil)
            expect(helper.refresh_counter_seconds).to eq(helper.refresh_counter_default_seconds)
          end
        end
        
        context "and menu series" do
          context "but series have less competitors than minimum seconds" do
            it "should return refresh counter default seconds" do
              expect(helper).to receive(:refresh_counter_auto_scroll).and_return(true)
              series = instance_double(Series)
              competitors = double(Array)
              expect(helper).to receive(:menu_series).and_return(series)
              expect(series).to receive(:competitors).and_return(competitors)
              expect(competitors).to receive(:count).and_return(helper.refresh_counter_min_seconds - 1)
              expect(helper.refresh_counter_seconds).to eq(helper.refresh_counter_min_seconds)
            end            
          end
          
          context "and series have at least as many competitors as minimum seconds" do
            it "should return competitor count" do
              expect(helper).to receive(:refresh_counter_auto_scroll).and_return(true)
              series = instance_double(Series)
              competitors = double(Array)
              expect(helper).to receive(:menu_series).and_return(series)
              expect(series).to receive(:competitors).and_return(competitors)
              expect(competitors).to receive(:count).and_return(helper.refresh_counter_min_seconds)
              expect(helper.refresh_counter_seconds).to eq(helper.refresh_counter_min_seconds)
            end
          end
        end
      end
    end
  end

  describe "#national_record" do
    before do
      @competitor = instance_double(Competitor)
      @race = instance_double(Race)
      series = instance_double(Series)
      allow(@competitor).to receive(:series).and_return(series)
      allow(series).to receive(:race).and_return(@race)
    end

    context "when race finished" do
      before do
        allow(@race).to receive(:finished?).and_return(true)
      end

      context "when national record passed" do
        it "should return SE" do
          allow(@competitor).to receive(:national_record_passed?).and_return(true)
          expect(helper.national_record(@competitor, true)).to eq('SE')
        end
      end

      context "when national record reached" do
        it "should return SE(sivuaa)" do
          allow(@competitor).to receive(:national_record_passed?).and_return(false)
          allow(@competitor).to receive(:national_record_reached?).and_return(true)
          expect(helper.national_record(@competitor, true)).to eq('SE(sivuaa)')
        end
      end
    end

    context "when race not finished" do
      before do
        allow(@race).to receive(:finished?).and_return(false)
      end

      context "when national record passed" do
        it "should return SE?" do
          allow(@competitor).to receive(:national_record_passed?).and_return(true)
          expect(helper.national_record(@competitor, true)).to eq('SE?')
        end
      end

      context "when national record reached" do
        it "should return SE(sivuaa)?" do
          allow(@competitor).to receive(:national_record_passed?).and_return(false)
          allow(@competitor).to receive(:national_record_reached?).and_return(true)
          expect(helper.national_record(@competitor, true)).to eq('SE(sivuaa)?')
        end
      end
    end

    context "with decoration" do
      it "should surround text with span and link" do
        allow(@race).to receive(:finished?).and_return(true)
        allow(@competitor).to receive(:national_record_passed?).and_return(true)
        expect(helper.national_record(@competitor, false)).to eq("<span class='explanation'><a href=\"" + NATIONAL_RECORD_URL + "\">SE</a></span>")
      end
    end
  end
  
  describe "#organizer_info_with_possible_link" do
    context "when no home page, organizer or phone" do
      it "should return nil" do
        race = FactoryGirl.build(:race, home_page: '', organizer: '', organizer_phone: '')
        expect(helper.organizer_info_with_possible_link(Race.new)).to be_nil
      end
    end
    
    context "when only organizer" do
      it "should return organizer name" do
        race = FactoryGirl.build(:race, home_page: '', organizer: 'Organizer')
        expect(helper.organizer_info_with_possible_link(race)).to eq('Organizer')
      end
    end
    
    context "when only home page" do
      it "should return link to home page with static text" do
        race = FactoryGirl.build(:race, home_page: 'www.home.com', organizer: '')
        expected_link = '<a href="http://www.home.com" target="_blank">' + t("races.show.race_home_page") + '</a>'
        expect(helper.organizer_info_with_possible_link(race)).to eq(expected_link)
      end
    end
    
    context "when only phone" do
      it "should return phone" do
        race = FactoryGirl.build(:race, home_page: '', organizer: '', organizer_phone: '123 456')
        expect(helper.organizer_info_with_possible_link(race)).to eq('123 456')
      end
    end
      
    context "when organizer and phone" do
      it "should return organizer name appended with phone" do
        race = FactoryGirl.build(:race, home_page: nil, organizer: 'Organizer', organizer_phone: '123 456')
        expected_link = 'Organizer, 123 456'
        expect(helper.organizer_info_with_possible_link(race)).to eq(expected_link)
      end
    end
      
    context "when home page, organizer and phone" do
      it "should return link to home page with organizer as text, appended with phone" do
        race = FactoryGirl.build(:race, home_page: 'http://www.home.com', organizer: 'Organizer', organizer_phone: '123 456')
        expected_link = '<a href="http://www.home.com" target="_blank">Organizer</a>, 123 456'
        expect(helper.organizer_info_with_possible_link(race)).to eq(expected_link)
      end
    end
  end

  describe '#races_drop_down_array' do
    let(:race1) { FactoryGirl.build :race, id: 1, name: 'Race 1', location: 'Location 1' }
    let(:race2) { FactoryGirl.build :race, id: 2, name: 'Race 2', location: 'Location 2' }
    let(:races) { [race1, race2] }

    it 'should return array containing elements with race info in first element, race id in second' do
      allow(helper).to receive(:race_date_interval).and_return('Dates')
      expect(helper.races_drop_down_array(races)).to eq [['Race 1 (Dates, Location 1)', 1],
                                                         ['Race 2 (Dates, Location 2)', 2]]
    end
  end
end
