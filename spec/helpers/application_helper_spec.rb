# encoding: UTF-8
require 'spec_helper'

describe ApplicationHelper do
  describe "#points_print" do
    before do
      @all_competitors = true
    end

    it "should print no result reason if it is defined" do
      competitor = mock_model(Competitor, :no_result_reason => Competitor::DNS)
      competitor.stub(:points).with(@all_competitors).and_return(145)
      helper.points_print(competitor, @all_competitors).should ==
        "<span class='explanation' title='Kilpailija ei osallistunut kilpailuun'>DNS</span>"
    end

    it "should print points in case they are available" do
      competitor = mock_model(Competitor, :no_result_reason => nil,
        :series => nil)
      competitor.should_receive(:points).with(@all_competitors).and_return(145)
      helper.points_print(competitor, @all_competitors).should == "145"
    end

    it "should print points in brackets if only partial points are available" do
      competitor = mock_model(Competitor, :no_result_reason => nil)
      competitor.should_receive(:points).with(@all_competitors).and_return(nil)
      competitor.should_receive(:points!).with(@all_competitors).and_return(100)
      helper.points_print(competitor, @all_competitors).should == "(100)"
    end

    it "should print - if no points at all" do
      competitor = mock_model(Competitor, :no_result_reason => nil,
        :series => nil)
      competitor.should_receive(:points).with(@all_competitors).and_return(nil)
      competitor.should_receive(:points!).with(@all_competitors).and_return(nil)
      helper.points_print(competitor, @all_competitors).should == "-"
    end
  end
  
  describe "#cup_points_print" do
    it "should print points in case they are available" do
      competitor = double(CupCompetitor)
      competitor.should_receive(:points).and_return(2000)
      helper.cup_points_print(competitor).should == "2000"
    end
    
    it "should print points in brackets if only partial points are available" do
      competitor = double(CupCompetitor)
      competitor.should_receive(:points).and_return(nil)
      competitor.should_receive(:points!).and_return(1000)
      helper.cup_points_print(competitor).should == "(1000)"
    end
    
    it "should print '-' if no points at all" do
      competitor = double(CupCompetitor)
      competitor.should_receive(:points).and_return(nil)
      competitor.should_receive(:points!).and_return(nil)
      helper.cup_points_print(competitor).should == "-"
    end
  end

  describe "#datetime_print" do
    before do
      @time = Time.local(2010, 5, 8, 9, 8, 1)
    end

    it "should print empty string if nil given" do
      helper.datetime_print(nil).should == ''
    end

    it "should print d.m.Y as default format" do
      helper.datetime_print(@time).should == '08.05.2010'
    end

    it "should include hours and minutes if asked" do
      helper.datetime_print(@time, true).should == '08.05.2010 09:08'
    end

    it "should include hours, minutes and seconds if asked" do
      helper.datetime_print(@time, true, true).should == '08.05.2010 09:08:01'
    end

    it "should not print seconds if H/M not wanted and seconds wanted" do
      helper.datetime_print(@time, false, true).should == '08.05.2010'
    end

    it "should print given string instead of empty string if defined and nil" do
      helper.datetime_print(nil, true, false, 'none').should == 'none'
    end
  end

  describe "#series_start_time_print" do
    it "should call datetime_print with series date and time" do
      series = mock_model(Series)
      datetime = 'some date time'
      series.stub(:start_datetime).and_return(datetime)
      helper.should_receive(:datetime_print).with(datetime, true).and_return('result')
      helper.series_start_time_print(series).should == 'result'
    end
  end

  describe "#date_print" do
    it "should return DD.MM.YYYY" do
      time = Time.local(2010, 5, 8, 9, 8, 1)
      helper.date_print(time).should == '08.05.2010'
    end
  end

  describe "#time_print" do
    before do
      @time = Time.local(2010, 5, 8, 9, 8, 1)
    end

    it "should print empty string if nil given" do
      helper.time_print(nil).should == ''
    end

    it "should print HH:MM as default format" do
      helper.time_print(@time).should == '09:08'
    end

    it "should include seconds if asked" do
      helper.time_print(@time, true).should == '09:08:01'
    end

    it "should print given string instead of empty string if defined and nil" do
      helper.time_print(nil, true, 'none').should == 'none'
    end

    it "should print given string as raw instead of empty string if defined and nil" do
      helper.time_print(nil, true, '&nbsp;').should == '&nbsp;'
    end
  end

  describe "#time_from_seconds" do
    it "should return dash when nil given" do
      helper.time_from_seconds(nil).should == "-"
    end

    it "should return seconds when less than 60" do
      helper.time_from_seconds(59).should == "00:59"
    end

    it "should return minutes and seconds when more than 60" do
      helper.time_from_seconds(60).should == "01:00"
      helper.time_from_seconds(61).should == "01:01"
      helper.time_from_seconds(131).should == "02:11"
    end

    it "should return hours, minutes and seconds when at least 1 hour" do
      helper.time_from_seconds(3600).should == "1:00:00"
      helper.time_from_seconds(3601).should == "1:00:01"
    end

    it "should convert decimal seconds to integer" do
      helper.time_from_seconds(60.0).should == "01:00"
      helper.time_from_seconds(61.1).should == "01:01"
      helper.time_from_seconds(131.2).should == "02:11"
      helper.time_from_seconds(3601.6).should == "1:00:01"
    end

    it "should return negative hours, minutes and seconds when at least 1 hour" do
      helper.time_from_seconds(-3600).should == "-1:00:00"
      helper.time_from_seconds(-3601).should == "-1:00:01"
    end
    it "should return hours, minutes and seconds with minus or plus sign when alwayssigned" do
      helper.time_from_seconds(3600, true).should == "+1:00:00"
      helper.time_from_seconds(3601, true).should == "+1:00:01"
      helper.time_from_seconds(-3601, true).should == "-1:00:01"
    end
  end

  describe "#relay_time_adjustment" do
    before do
      helper.stub(:time_from_seconds).and_return('00:01')
    end

    it "should return nothing when nil given" do
      helper.relay_time_adjustment(nil).should == ""
    end

    it "should return nothing when 0 seconds given" do
      helper.relay_time_adjustment(0).should == ""
    end

    it "should return the html span block when 1 second given" do
      helper.relay_time_adjustment(1).should == "(<span class='adjustment' title=\"Aika sisältää korjausta 00:01\">00:01</span>)"
    end
  end

  describe "#shot_points" do
    context "when reason for no result" do
      it "should return empty string" do
        competitor = mock_model(Competitor, :shots_sum => 88,
          :no_result_reason => Competitor::DNS)
        helper.shot_points(competitor).should == ''
      end
    end

    context "when no shots sum" do
      it "should return dash" do
        competitor = mock_model(Competitor, :shots_sum => nil,
          :no_result_reason => nil)
        helper.shot_points(competitor).should == "-"
      end
    end

    context "when no total shots wanted" do
      it "should return shot points" do
        competitor = mock_model(Competitor, :shot_points => 480, :shots_sum => 80,
          :no_result_reason => nil)
        helper.shot_points(competitor, false).should == "480"
      end
    end

    context "when total shots wanted" do
      it "should return shot points and sum in brackets" do
        competitor = mock_model(Competitor, :shot_points => 480, :shots_sum => 80,
          :no_result_reason => nil)
        helper.shot_points(competitor, true).should == "480 (80)"
      end
    end
  end

  describe "#shots_list" do
    it "should return dash when no shots sum" do
      competitor = mock_model(Competitor, :shots_sum => nil)
      helper.shots_list(competitor).should == "-"
    end

    it "should return input total if such is given" do
      competitor = mock_model(Competitor, :shots_sum => 45, :shots_total_input => 45)
      helper.shots_list(competitor).should == 45
    end

    it "should return comma separated list if individual shots defined" do
      shots = [10, 1, 9, 5, 5, nil, nil, 6, 4, 0]
      competitor = mock_model(Competitor, :shots_sum => 50,
        :shots_total_input => nil, :shot_values => shots)
      helper.shots_list(competitor).should == "10,1,9,5,5,0,0,6,4,0"
    end
  end

  describe "#print_estimate_diff" do
    it "should return empty string when nil given" do
      helper.print_estimate_diff(nil).should == "-"
    end

    it "should return negative diff with minus sign" do
      helper.print_estimate_diff(-12).should == "-12"
    end

    it "should return positive diff with plus sign" do
      helper.print_estimate_diff(13).should == "+13"
    end
  end

  describe "#estimate_diffs" do
    describe "2 estimates" do
      before do
        @series = mock_model(Series, :estimates => 2)
      end

      it "should return empty string when no estimates" do
        competitor = mock_model(Competitor, :estimate1 => nil, :estimate2 => nil,
          :series => @series)
        helper.estimate_diffs(competitor).should == ""
      end

      it "should return first and dash when first is available" do
        competitor = mock_model(Competitor, :estimate1 => 50, :estimate2 => nil,
          :estimate_diff1_m => 10, :estimate_diff2_m => nil, :series => @series)
        helper.estimate_diffs(competitor).should == "+10m/-"
      end

      it "should return dash and second when second is available" do
        competitor = mock_model(Competitor, :estimate1 => nil, :estimate2 => 60,
          :estimate_diff1_m => nil, :estimate_diff2_m => -5, :series => @series)
        helper.estimate_diffs(competitor).should == "-/-5m"
      end

      it "should return both when both are available" do
        competitor = mock_model(Competitor, :estimate1 => 120, :estimate2 => 60,
          :estimate_diff1_m => -5, :estimate_diff2_m => 14, :series => @series)
        helper.estimate_diffs(competitor).should == "-5m/+14m"
      end
    end

    describe "4 estimates" do
      before do
        @series = mock_model(Series, :estimates => 4)
      end

      it "should return empty string when no estimates" do
        competitor = mock_model(Competitor, :estimate1 => nil, :estimate2 => nil,
          :estimate3 => nil, :estimate4 => nil, :series => @series)
        helper.estimate_diffs(competitor).should == ""
      end

      it "should return dash for others when only third is available" do
        competitor = mock_model(Competitor, :estimate1 => 50, :estimate2 => nil,
          :estimate_diff1_m => nil, :estimate_diff2_m => nil,
          :estimate_diff3_m => 12, :estimate_diff4_m => nil, :series => @series)
        helper.estimate_diffs(competitor).should == "-/-/+12m/-"
      end

      it "should return dash for others when only fourth is available" do
        competitor = mock_model(Competitor, :estimate1 => 50, :estimate2 => nil,
          :estimate_diff1_m => nil, :estimate_diff2_m => nil,
          :estimate_diff3_m => nil, :estimate_diff4_m => -5, :series => @series)
        helper.estimate_diffs(competitor).should == "-/-/-/-5m"
      end

      it "should return dash for third when others are available" do
        competitor = mock_model(Competitor, :estimate1 => 50, :estimate2 => nil,
          :estimate_diff1_m => 10, :estimate_diff2_m => -9,
          :estimate_diff3_m => nil, :estimate_diff4_m => 12, :series => @series)
        helper.estimate_diffs(competitor).should == "+10m/-9m/-/+12m"
      end

      it "should return dash for fourth when others are available" do
        competitor = mock_model(Competitor, :estimate1 => nil, :estimate2 => 60,
          :estimate_diff1_m => 10, :estimate_diff2_m => -5,
          :estimate_diff3_m => 12, :estimate_diff4_m => nil, :series => @series)
        helper.estimate_diffs(competitor).should == "+10m/-5m/+12m/-"
      end

      it "should return all diffs when all are available" do
        competitor = mock_model(Competitor, :estimate1 => 120, :estimate2 => 60,
          :estimate_diff1_m => -5, :estimate_diff2_m => 14,
          :estimate_diff3_m => 12, :estimate_diff4_m => -1, :series => @series)
        helper.estimate_diffs(competitor).should == "-5m/+14m/+12m/-1m"
      end
    end
  end

  describe "#estimate_points" do
    it "should print empty string if no result reason defined" do
      competitor = mock_model(Competitor, :shots_sum => 88,
        :no_result_reason => Competitor::DNS)
      helper.estimate_points(competitor).should == ''
    end

    it "should return dash if no estimate points" do
      competitor = mock_model(Competitor, :estimate_points => nil,
        :no_result_reason => nil)
      helper.estimate_points(competitor).should == "-"
    end

    it "should return points otherwise" do
      competitor = mock_model(Competitor, :estimate_points => 189,
        :no_result_reason => nil)
      helper.estimate_points(competitor).should == 189
    end
  end

  describe "#estimate_points_and_diffs" do
    it "should print empty string if no result reason defined" do
      competitor = mock_model(Competitor, :shots_sum => 88,
        :no_result_reason => Competitor::DNS)
      helper.estimate_points_and_diffs(competitor).should == ''
    end

    it "should return dash if no estimate points" do
      competitor = mock_model(Competitor, :estimate_points => nil,
        :no_result_reason => nil)
      helper.estimate_points_and_diffs(competitor).should == "-"
    end

    it "should return points and diffs when points available" do
      competitor = mock_model(Competitor, :estimate_points => 189,
        :no_result_reason => nil)
      helper.should_receive(:estimate_diffs).with(competitor).and_return("3m")
      helper.estimate_points_and_diffs(competitor).should == "189 (3m)"
    end
  end

  describe "#correct_estimate" do
    it "should raise error when index less than 1" do
      lambda { helper.correct_estimate(nil, 0, '') }.should raise_error
    end

    it "should raise error when index more than 4" do
      lambda { helper.correct_estimate(nil, 5, '') }.should raise_error
    end

    context "race not finished" do
      before do
        race = mock_model(Race, :finished => false)
        series = mock_model(Series, :race => race)
        @competitor = mock_model(Competitor, :series => series,
          :correct_estimate1 => 100, :correct_estimate2 => 150)
      end

      specify { helper.correct_estimate(@competitor, 1, '-').should == '-' }
      specify { helper.correct_estimate(@competitor, 2, '-').should == '-' }
      specify { helper.correct_estimate(@competitor, 3, '-').should == '-' }
      specify { helper.correct_estimate(@competitor, 4, '-').should == '-' }
    end

    context "race finished" do
      context "estimates available" do
        before do
          race = mock_model(Race, :finished => true)
          series = mock_model(Series, :race => race)
          @competitor = mock_model(Competitor, :series => series,
            :correct_estimate1 => 100, :correct_estimate2 => 150,
            :correct_estimate3 => 110, :correct_estimate4 => 160)
        end

        specify { helper.correct_estimate(@competitor, 1, '-').should == 100 }
        specify { helper.correct_estimate(@competitor, 2, '-').should == 150 }
        specify { helper.correct_estimate(@competitor, 3, '-').should == 110 }
        specify { helper.correct_estimate(@competitor, 4, '-').should == 160 }
      end

      context "estimates not available" do
        before do
          race = mock_model(Race, :finished => true)
          series = mock_model(Series, :race => race)
          @competitor = mock_model(Competitor, :series => series,
            :correct_estimate1 => nil, :correct_estimate2 => nil,
            :correct_estimate3 => nil, :correct_estimate4 => nil)
        end

        specify { helper.correct_estimate(@competitor, 1, '-').should == '-' }
        specify { helper.correct_estimate(@competitor, 2, '-').should == '-' }
        specify { helper.correct_estimate(@competitor, 3, '-').should == '-' }
        specify { helper.correct_estimate(@competitor, 4, '-').should == '-' }
      end
    end
  end

  describe "#time_points" do
    before do
      @series = mock_model(Series, :time_points_type => Series::TIME_POINTS_TYPE_NORMAL)
    end

    context "when reason for no result" do
      it "should return empty string" do
        competitor = mock_model(Competitor, :series => @series,
          :no_result_reason => Competitor::DNS)
        helper.time_points(competitor).should == ''
      end
    end
  
    context "when 300 points for all competitors in this series" do
      it "should return 300" do
        @series.stub(:time_points_type).and_return(Series::TIME_POINTS_TYPE_ALL_300)
        competitor = mock_model(Competitor, :series => @series, :no_result_reason => nil)
        helper.time_points(competitor).should == 300
      end
    end
  
    context "when no time" do
      it "should return dash" do
        competitor = mock_model(Competitor, :time_in_seconds => nil,
          :no_result_reason => nil, :series => @series)
        helper.time_points(competitor).should == "-"
      end
    end
  
    context "when time points and time wanted" do
      it "should return time points and time in brackets" do
        all_competitors = true
        competitor = mock_model(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        competitor.should_receive(:time_points).with(all_competitors).and_return(270)
        helper.should_receive(:time_from_seconds).with(2680).and_return("45:23")
        helper.time_points(competitor, true, all_competitors).should == "270 (45:23)"
      end
  
      it "should wrap with best time span when full points" do
        all_competitors = true
        competitor = mock_model(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        competitor.should_receive(:time_points).with(all_competitors).and_return(300)
        helper.should_receive(:time_from_seconds).with(2680).and_return("45:23")
        helper.time_points(competitor, true, all_competitors).
          should == "<span class='series_best_time'>300 (45:23)</span>"
      end
    end
    
    context "when time points but no time wanted" do
      it "should return time points" do
        all_competitors = true
        competitor = mock_model(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        competitor.should_receive(:time_points).with(all_competitors).and_return(270)
        helper.time_points(competitor, false, all_competitors).should == "270"
      end
  
      it "should wrap with best time span when full points" do
        all_competitors = true
        competitor = mock_model(Competitor, :series => @series,
          :time_in_seconds => 2680, :no_result_reason => nil)
        competitor.should_receive(:time_points).with(all_competitors).and_return(300)
        helper.time_points(competitor, false, all_competitors).
          should == "<span class='series_best_time'>300</span>"
      end
    end
  end

  describe "#full_name" do
    specify { helper.full_name(mock_model(Competitor, :last_name => "Tester",
        :first_name => "Tim")).should == "Tester Tim" }

    describe "first name first" do
      specify { helper.full_name(mock_model(Competitor, :last_name => "Tester",
          :first_name => "Tim"), true).should == "Tim Tester" }
    end
  end

  describe "#date_interval" do
    it "should print start - end when dates differ" do
      helper.date_interval("2010-08-01".to_date, "2010-08-03".to_date).
        should == "01.08.2010 - 03.08.2010"
    end

    it "should print only start date when end date is same" do
      helper.date_interval("2010-08-03".to_date, "2010-08-03".to_date).
        should == "03.08.2010"
    end

    it "should print only start date when end date is nil" do
      helper.date_interval("2010-08-03".to_date, nil).should == "03.08.2010"
    end
  end

  describe "#race_date_interval" do
    it "should call date_interval with race dates" do
      race = FactoryGirl.build(:race)
      helper.should_receive(:date_interval).with(race.start_date, race.end_date).
        and_return('result')
      helper.race_date_interval(race).should == 'result'
    end
  end

  describe "#yes_or_empty" do
    context "when boolean is true" do
      it "should return yes icon" do
        helper.yes_or_empty('test').should match(/<img .* src=.*icon_yes.gif.*\/>/)
      end
    end

    context "when boolean is false" do
      it "should return html space when no block given" do
        helper.yes_or_empty(nil).should == '&nbsp;'
      end

      it "should call block when block given" do
        s = double(Series)
        s.should_receive(:id)
        helper.yes_or_empty(false) do s.id end
      end
    end
  end

  describe "#value_or_space" do
    it "should return value when value is available" do
      helper.value_or_space('test').should == 'test'
    end

    it "should return html space when value not available" do
      helper.value_or_space(nil).should == '&nbsp;'
      helper.value_or_space(false).should == '&nbsp;'
    end
  end

  describe "#start_days_form_field" do
    before do
      @f = double(String)
      @race = mock_model(Race, :start_date => '2010-12-20')
      @series = mock_model(Series, :race => @race)
    end

    context "when only one start day" do
      it "should return hidden field with value 1" do
        @series.should_receive(:start_day=).with(1)
        @f.should_receive(:hidden_field).with(:start_day).and_return("input")
        @race.stub(:days_count).and_return(1)
        helper.start_days_form_field(@f, @series).should == "input"
      end
    end

    context "when more than one day" do
      it "should return dropdown menu with different dates" do
        @series.should_receive(:start_day).and_return(2)
        options = options_for_select([['20.12.2010', 1], ['21.12.2010', 2]], 2)
        @f.should_receive(:select).with(:start_day, options).and_return("select")
        @race.stub(:days_count).and_return(2)
        helper.start_days_form_field(@f, @series).should == "select"
      end
    end
  end

  describe "#offline?" do
    it "should return true when Mode.offline? returns true" do
      Mode.stub(:offline?).and_return(true)
      helper.should be_offline
    end

    it "should return true when Mode.offline? returns false" do
      Mode.stub(:offline?).and_return(false)
      helper.should_not be_offline
    end
  end

  describe "#link_with_protocol" do
    it "should return the given link if it starts with http://" do
      helper.link_with_protocol('http://www.test.com').should == 'http://www.test.com'
    end

    it "should return the given link if it starts with https://" do
      helper.link_with_protocol('https://www.test.com').should == 'https://www.test.com'
    end

    it "should return http protocol + the given link if the protocol is missing" do
      helper.link_with_protocol('www.test.com').should == 'http://www.test.com'
    end
  end

  describe "#next_result_rotation" do
    context "when url list is empty" do
      context "and parameter is non-nil" do
        it "should return the parameter url" do
          helper.stub(:result_rotation_list).and_return([])
          helper.next_result_rotation('/abc').should == '/abc'
        end
      end

      context "and parameter is nil" do
        before do
          @race_path = '/this/is/race/frontpage'
          helper.stub(:race_path).and_return(@race_path)
        end

        it "should return the race front page" do
          helper.stub(:result_rotation_list).and_return([])
          helper.next_result_rotation(nil).should == @race_path
        end
      end
    end
    
    context "when url list is not empty" do
      before do
        @result_rotation_list = ['/races/12/relays/1', '/series/56/competitors', '/series/67/competitors']
        helper.stub(:result_rotation_list).and_return(@result_rotation_list)
      end

      context "when nil url is given" do
        it "should return first url from url rotation" do
          helper.next_result_rotation(nil).should == @result_rotation_list[0]
        end
      end

      context "when unknown url is given" do
        it "should return first url from url rotation" do
          helper.next_result_rotation('/unknown').should == @result_rotation_list[0]
        end
      end

      context "when existing url is given" do
        it "should return next url from url rotation" do
          helper.next_result_rotation(@result_rotation_list[0]).should == @result_rotation_list[1]
        end
      end

      context "when another existing url is given" do
        it "should return next url from url rotation" do
          helper.next_result_rotation(@result_rotation_list[1]).should == @result_rotation_list[2]
        end
      end

      context "when last url is given" do
        it "should return first url from url rotation" do
          helper.next_result_rotation(@result_rotation_list.size - 1).should == @result_rotation_list[0]
        end
      end
    end
  end

  describe "#result_rotation_list" do
    describe "aggregate" do
      before do
        @race = mock_model(Race)
        helper.stub(:result_rotation_series_list).with(@race).and_return(['series1', 'series2'])
        helper.stub(:result_rotation_tc_list).with(@race).and_return(['tc1', 'tc2'])
        helper.stub(:result_rotation_relay_list).with(@race).and_return(['relay1', 'relay2'])
        helper.stub(:result_rotation_tc_cookie).and_return(true)
      end

      it "should return an empty list when offline" do
        Mode.stub(:offline?).and_return(true)
        Mode.stub(:online?).and_return(false)
        helper.result_rotation_list(@race).should be_empty
      end

      it "should return all paths when all available" do
        list = helper.result_rotation_list(@race)
        list.size.should == 6
        list[0].should == 'series1'
        list[1].should == 'series2'
        list[2].should == 'tc1'
        list[3].should == 'tc2'
        list[4].should == 'relay1'
        list[5].should == 'relay2'
      end

      it "should not return either team competition paths if no series" do
        helper.should_receive(:result_rotation_series_list).with(@race).and_return([])
        list = helper.result_rotation_list(@race)
        list.size.should == 2
        list[0].should == 'relay1'
        list[1].should == 'relay2'
      end
      
      it "should not return team competition paths unless cookie for that" do
        helper.stub(:result_rotation_tc_cookie).and_return(false)
        list = helper.result_rotation_list(@race)
        list.size.should == 4
        list[0].should == 'series1'
        list[1].should == 'series2'
        list[2].should == 'relay1'
        list[3].should == 'relay2'
      end
    end

    describe "#result_rotation_series_list" do
      it "should return an empty list when race in the future" do
        race = FactoryGirl.create(:race, :start_date => Date.today - 1)
        race.series << build_series(race, 1, '0:00')
        result_rotation_series_list(race).size.should == 0
      end

      it "should return an empty list when race was in the past" do
        race = FactoryGirl.create(:race, :start_date => Date.today - 2,
          :end_date => Date.today - 1)
        race.series << build_series(race, 1, '0:00')
        result_rotation_series_list(race).size.should == 0
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
            list.size.should == 2
            list[0].should == series_competitors_path(nil, @series1_1)
            list[1].should == series_competitors_path(nil, @series1_2)
          end
        end

        context "when race started yesterday" do
          it "should return the paths for started series today" do
            @race.start_date = Date.today - 1
            @race.end_date = Date.today
            @race.save!
            list = result_rotation_series_list(@race)
            list.size.should == 1
            list[0].should == series_competitors_path(nil, @series2_1)
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
        list.size.should == 2
        list[0].should == race_team_competition_path(nil, @race, @tc1)
        list[1].should == race_team_competition_path(nil, @race, @tc2)
      end

      def build_team_competition(race)
        FactoryGirl.build(:team_competition, :race => race)
      end
    end

    describe "#result_rotation_relay_list" do
      it "should return an empty list when race in the future" do
        race = FactoryGirl.create(:race, :start_date => Date.today - 1)
        race.relays << build_relay(race, 1, '0:00')
        result_rotation_relay_list(race).size.should == 0
      end

      it "should return an empty list when race was in the past" do
        race = FactoryGirl.create(:race, :start_date => Date.today - 2,
          :end_date => Date.today - 1)
        race.relays << build_relay(race, 1, '0:00')
        result_rotation_relay_list(race).size.should == 0
      end

      context "when race is ongoing today" do
        before do
          @race = FactoryGirl.create(:race, :start_date => Date.today,
            :end_date => Date.today + 1)
          @relay1_1 = build_relay(@race, 1, '0:00')
          @relay1_2 = build_relay(@race, 1, '0:00')
          @relay1_3 = build_relay(@race, 1, '23:59')
          @relay2_1 = build_relay(@race, 2, '0:00')
          @relay2_2 = build_relay(@race, 2, '23:59')
          @race.relays << @relay1_1
          @race.relays << @relay1_2
          @race.relays << @relay1_3
          @race.relays << @relay2_1
          @race.relays << @relay2_2
        end

        context "when race has started today" do
          it "should return the paths for started relays today" do
            list = result_rotation_relay_list(@race)
            list.size.should == 2
            list[0].should == race_relay_path(nil, @race, @relay1_1)
            list[1].should == race_relay_path(nil, @race, @relay1_2)
          end
        end

        context "when race started yesterday" do
          it "should return the paths for started relays today" do
            @race.start_date = Date.today - 1
            @race.end_date = Date.today
            @race.save!
            list = result_rotation_relay_list(@race)
            list.size.should == 1
            list[0].should == race_relay_path(nil, @race, @relay2_1)
          end
        end
      end

      def build_relay(race, start_day, start_time)
        FactoryGirl.build(:relay, :race => race, :start_day => start_day,
          :start_time => start_time)
      end
    end
  end

  describe "#series_result_title" do
    before do
      @competitors = double(Array)
      @competitors.stub(:empty?).and_return(false)
      @race = mock_model(Race, :finished? => false)
      @series = mock_model(Series, :race => @race, :competitors => @competitors, :started? => true)
    end
    
    it "should return '(Ei kilpailijoita)' when no competitors" do
      @competitors.should_receive(:empty?).and_return(true)
      series_result_title(@series).should == '(Ei kilpailijoita)'
    end
    
    it "should return '(Sarja ei ole vielä alkanut)' when the series has not started yet" do
      @series.should_receive(:started?).and_return(false)
      series_result_title(@series).should == '(Sarja ei ole vielä alkanut)'
    end
    
    it "should return 'Tulokset' when competitors and the race is finished" do
      @race.should_receive(:finished?).and_return(true)
      series_result_title(@series).should == 'Tulokset'
    end

    it "should return 'Tilanne (päivitetty: <time>)' when series still active" do
      original_zone = Time.zone
      Time.zone = 'Tokyo' # UTC+9 (without summer time so that test settings won't change) 
      time = Time.utc(2011, 5, 13, 13, 45, 58)
      @series.should_receive(:competitors).and_return(@competitors)
      @competitors.should_receive(:maximum).with(:updated_at).and_return(time) # db return UTC
      series_result_title(@series).should == 'Tilanne (päivitetty: 13.05.2011 22:45:58)'
      Time.zone = original_zone
    end

    it "should return 'Tulokset - Kaikki kilpailijat' when all competitors and the race is finished" do
      @race.should_receive(:finished?).and_return(true)
      series_result_title(@series, true).should == 'Tulokset - Kaikki kilpailijat'
    end

    it "should return 'Tilanne (päivitetty: <time>) - Kaikki kilpailijat' when all competitors and series still active" do
      original_zone = Time.zone
      Time.zone = 'Tokyo' # UTC+9 (without summer time so that test settings won't change)
      time = Time.utc(2011, 5, 13, 13, 45, 58)
      @series.should_receive(:competitors).and_return(@competitors)
      @competitors.should_receive(:maximum).with(:updated_at).and_return(time) # db return UTC
      series_result_title(@series, true).should == 'Tilanne (päivitetty: 13.05.2011 22:45:58) - Kaikki kilpailijat'
      Time.zone = original_zone
    end
  end

  describe "#series_result_title" do
    before do
      @competitors = double(Array)
      @teams = double(Array)
      @teams.stub(:empty?).and_return(false)
      @race = mock_model(Race)
      @relay = mock_model(Relay, :race => @race, :started? => true,
        :relay_teams => @teams, :finished? => false)
    end
    
    it "should return '(Ei joukkueita)' when no teams" do
      @teams.should_receive(:empty?).and_return(true)
      relay_result_title(@relay).should == '(Ei joukkueita)'
    end
    
    it "should return '(Viesti ei ole vielä alkanut)' when the relay has not started yet" do
      @relay.should_receive(:started?).and_return(false)
      relay_result_title(@relay).should == '(Viesti ei ole vielä alkanut)'
    end
    
    it "should return 'Tulokset' when teams and the race is finished" do
      @relay.should_receive(:finished?).and_return(true)
      relay_result_title(@relay).should == 'Tulokset'
    end

    it "should return 'Tilanne (päivitetty: <time>)' when relay still active" do
      original_zone = Time.zone
      Time.zone = 'Tokyo' # UTC+9 (without summer time so that test settings won't change) 
      time = Time.utc(2011, 5, 13, 13, 45, 58)
      @relay.should_receive(:relay_competitors).and_return(@competitors)
      @competitors.should_receive(:maximum).with(:updated_at).and_return(time) # db return UTC
      relay_result_title(@relay).should == 'Tilanne (päivitetty: 13.05.2011 22:45:58)'
      Time.zone = original_zone
    end
  end

  describe "#correct_estimate_range" do
    it "should return min_number- if no max_number" do
      ce = FactoryGirl.build(:correct_estimate, :min_number => 56, :max_number => nil)
      helper.correct_estimate_range(ce).should == "56-"
    end

    it "should return min_number if max_number equals to it" do
      ce = FactoryGirl.build(:correct_estimate, :min_number => 57, :max_number => 57)
      helper.correct_estimate_range(ce).should == 57
    end

    it "should return min_number-max_number if both defined and different" do
      ce = FactoryGirl.build(:correct_estimate, :min_number => 57, :max_number => 58)
      helper.correct_estimate_range(ce).should == "57-58"
    end
  end
  
  describe "#time_title" do
    before do
      @sport = mock_model(Sport)
      @race = mock_model(Race, :sport => @sport)
    end
    
    it "should be 'Juoksu' when run sport" do
      @sport.stub(:run?).and_return(true)
      helper.time_title(@race).should == 'Juoksu'
    end
    
    it "should be 'Hiihto' when no run sport" do
      @sport.stub(:run?).and_return(false)
      helper.time_title(@race).should == 'Hiihto'
    end
  end

  describe "#club_title" do
    it "should be 'Piiri' when club level such" do
      race = FactoryGirl.build(:race, :club_level => Race::CLUB_LEVEL_PIIRI)
      helper.club_title(race).should == 'Piiri'
    end

    it "should be 'Seura' when club level such" do
      race = FactoryGirl.build(:race, :club_level => Race::CLUB_LEVEL_SEURA)
      helper.club_title(race).should == 'Seura'
    end

    it "should throw exception when unknown club level" do
      race = FactoryGirl.build(:race, :club_level => 100)
      lambda { helper.club_title(race) }.should raise_error
    end
  end

  describe "#clubs_title" do
    it "should be 'Piirit' when club level such" do
      race = FactoryGirl.build(:race, :club_level => Race::CLUB_LEVEL_PIIRI)
      helper.clubs_title(race).should == 'Piirit'
    end

    it "should be 'Seurat' when club level such" do
      race = FactoryGirl.build(:race, :club_level => Race::CLUB_LEVEL_SEURA)
      helper.clubs_title(race).should == 'Seurat'
    end

    it "should throw exception when unknown club level" do
      race = FactoryGirl.build(:race, :club_level => 100)
      lambda { helper.clubs_title(race) }.should raise_error
    end
  end
  
  describe "#comparison_time_title" do
    before do
      @competitor = mock_model(Competitor)
      @competitor.stub(:comparison_time_in_seconds).and_return(1545)
    end
    
    it "should return empty string when empty always wanted" do
      helper.comparison_time_title(@competitor, true, true).should == ''
    end
    
    it "should return empty string when no comparison time available" do
      @competitor.stub(:comparison_time_in_seconds).and_return(nil)
      helper.comparison_time_title(@competitor, true, false).should == ''
    end
    
    it "should return space and title attribute with title and comparison time when empty not wanted" do
      helper.comparison_time_title(@competitor, true, false).should == " title='Vertailuaika: 25:45'"
    end
    
    it "should use all_competitors parameter when getting the comparison time" do
      @competitor.stub(:comparison_time_in_seconds).with(false).and_return(1550)
      helper.comparison_time_title(@competitor, false, false).should == " title='Vertailuaika: 25:50'"
    end
  end
  
  describe "#comparison_and_own_time_title" do
    context "when no time for competitor" do
      it "should return empty string" do
        competitor = mock_model(Competitor)
        competitor.stub(:time_in_seconds).and_return(nil)
        helper.comparison_and_own_time_title(competitor).should == ''
      end
    end
  
    context "when no comparison time for competitor" do
      it "should return space and title attribute with time title and time" do
        competitor = mock_model(Competitor)
        competitor.should_receive(:time_in_seconds).and_return(123)
        competitor.should_receive(:comparison_time_in_seconds).with(false).and_return(nil)
        helper.should_receive(:time_from_seconds).with(123).and_return('1:23')
        helper.comparison_and_own_time_title(competitor).should == " title='Aika: 1:23'"
      end
    end

    context "when own and comparison time available" do
      it "should return space and title attribute with time title, time, comparison time title and comparison time" do
        competitor = mock_model(Competitor)
        competitor.should_receive(:time_in_seconds).and_return(123)
        competitor.should_receive(:comparison_time_in_seconds).with(false).and_return(456)
        helper.should_receive(:time_from_seconds).with(123).and_return('1:23')
        helper.should_receive(:time_from_seconds).with(456).and_return('4:56')
        helper.comparison_and_own_time_title(competitor).should == " title='Aika: 1:23. Vertailuaika: 4:56.'"
      end
    end
  end
  
  describe "#shots_total_title" do
    it "should return empty string when no shots sum for competitor" do
      competitor = mock_model(Competitor)
      competitor.should_receive(:shots_sum).and_return(nil)
      helper.shots_total_title(competitor).should == ''
    end
    
    it "should return space and title attribute with title and shots sum when sum available" do
      competitor = mock_model(Competitor)
      competitor.should_receive(:shots_sum).and_return(89)
      helper.shots_total_title(competitor).should == " title='Ammuntatulos: 89'"
    end
  end
  
  describe "#title_prefix" do
    it "should be '(Dev) ' when development environment" do
      Rails.stub(:env).and_return('development')
      helper.title_prefix.should == '(Dev) '
    end
    
    it "should be '(Testi) ' when test environment" do
      Rails.stub(:env).and_return('test')
      helper.title_prefix.should == '(Testi) '
    end
    
    it "should be '(Testi) ' when staging environment" do
      Rails.stub(:env).and_return('staging')
      helper.title_prefix.should == '(Testi) '
    end
    
    it "should be '(Offline) ' when offline production environment" do
      Rails.stub(:env).and_return('winoffline-prod')
      helper.title_prefix.should == '(Offline) '
    end
    
    it "should be '(Offline-dev) ' when offline development environment" do
      Rails.stub(:env).and_return('winoffline-dev')
      helper.title_prefix.should == '(Offline-dev) '
    end
    
    it "should be '' when production environment" do
      Rails.stub(:env).and_return('production')
      helper.title_prefix.should == ''
    end
  end
  
  describe "#long_cup_series_name" do
    it "should be cup series name when no series names" do
      cs = FactoryGirl.build(:cup_series, :name => 'Series')
      cs.should_receive(:has_single_series_with_same_name?).and_return(true)
      helper.long_cup_series_name(cs).should == 'Series'
    end
    
    it "should be cup series name and series names in brackets when given" do
      cs = FactoryGirl.build(:cup_series, :name => 'Series', :series_names => 'M,M50,M80')
      cs.should_receive(:has_single_series_with_same_name?).and_return(false)
      helper.long_cup_series_name(cs).should == 'Series (M, M50, M80)'
    end
  end
  
  describe "#remove_child_link" do
    before do
      @value = 'Add child'
      @form = double(Object)
      @hide_class = 'hide_class'
      @confirm_question = 'Are you sure?'
      @form.should_receive(:hidden_field).with(:_destroy).and_return('<hidden-field/>')
    end

    it "should return hidden _destroy field and button with onclick call to remove_fields javascript" do
      helper.remove_child_link(@value, @form, @hide_class, @confirm_question).
        should == "<hidden-field/><input onclick=\"remove_fields(this, &#x27;hide_class&#x27;, &#x27;Are you sure?&#x27;);\" type=\"button\" value=\"Add child\" />"
    end
  end
  
  describe "#add_child_link" do
    before do
      @value = 'Add child'
      @form = double(Object)
      @method = 'method'
      helper.should_receive(:new_child_fields).with(@form, @method).and_return('<div id="f">fields</div>')
    end

    context "without id" do    
      it "should return button with onclick call to insert_fields javascript as escaped" do
        helper.add_child_link(@value, @form, @method).
          should == '<input onclick="insert_fields(this, &quot;method&quot;, &quot;&lt;div id=\\&quot;f\\&quot;&gt;fields&lt;\\/div&gt;&quot;);" type="button" value="Add child" />'
      end
    end

    context "with id" do    
      it "should return button with id and onclick call to insert_fields javascript" do
        helper.add_child_link(@value, @form, @method, 'myid').
          should == '<input id="myid" onclick="insert_fields(this, &quot;method&quot;, &quot;&lt;div id=\\&quot;f\\&quot;&gt;fields&lt;\\/div&gt;&quot;);" type="button" value="Add child" />'
      end
    end
  end
  
  describe "#competition_icon" do
    context "when single race" do
      it "should be image tag for competition's sport's lower case key with _icon.gif suffix" do
        sport = mock_model(Sport, :key => 'RUN', :initials => 'HJ')
        helper.should_receive(:image_tag).with("run_icon.gif", alt: 'HJ').and_return("image")
        helper.competition_icon(mock_model(Race, :sport => sport)).should == "image"
      end
    end
    
    context "when cup" do
      it "should be image tag for cup's sport's lower case key with _icon_cup.gif suffix" do
        sport = mock_model(Sport, :key => 'SKI', :initials => 'HH')
        helper.should_receive(:image_tag).with("ski_icon_cup.gif", alt: 'HH').and_return("cup-image")
        helper.competition_icon(mock_model(Cup, :sport => sport)).should == "cup-image"
      end
    end
  end
  
  describe "#facebook_env?" do
    it "should be true for development" do
      Rails.stub(:env).and_return('development')
      helper.facebook_env?.should be_true
    end
    
    it "should be true for production" do
      Rails.stub(:env).and_return('production')
      helper.facebook_env?.should be_true
    end
    
    it "should be false for all others" do
      Rails.stub(:env).and_return('test')
      helper.facebook_env?.should be_false
    end
  end
  
  describe "#refresh_counter_min_seconds" do
    it { helper.refresh_counter_min_seconds.should == 20 }
  end
  
  describe "#refresh_counter_default_seconds" do
    it { helper.refresh_counter_default_seconds.should == 30 }
  end
  
  describe "#refresh_counter_auto_scroll" do
    context "when menu_series defined and result rotation auto scroll cookie defined" do
      it "should return true" do
        helper.should_receive(:menu_series).and_return(mock_model(Series))
        helper.should_receive(:result_rotation_auto_scroll).and_return('cookie')
        helper.refresh_counter_auto_scroll.should be_true
      end
    end
    
    context "when menu_series not available" do
      it "should return false" do
        helper.should_receive(:menu_series).and_return(nil)
        helper.refresh_counter_auto_scroll.should be_false
      end
    end
    
    context "when result rotation auto scroll cookie not available" do
      it "should return false" do
        helper.should_receive(:menu_series).and_return(mock_model(Series))
        helper.should_receive(:result_rotation_auto_scroll).and_return(nil)
        helper.refresh_counter_auto_scroll.should be_false
      end
    end
  end
  
  describe "#refresh_counter_seconds" do
    context "when explicit seconds given" do
      it "should return given seconds" do
        helper.refresh_counter_seconds(25).should == 25
      end
    end
    
    context "when no explicit seconds" do
      context "and no autoscroll" do
        it "should return refresh counter default seconds" do
          helper.should_receive(:refresh_counter_auto_scroll).and_return(false)
          helper.refresh_counter_seconds.should == helper.refresh_counter_default_seconds
        end
      end
      
      context "and autoscroll" do
        context "but no menu series" do
          it "should return refresh counter default seconds" do
            competitors = double(Array)
            helper.should_receive(:refresh_counter_auto_scroll).and_return(true)
            helper.should_receive(:menu_series).and_return(nil)
            helper.refresh_counter_seconds.should == helper.refresh_counter_default_seconds
          end
        end
        
        context "and menu series" do
          context "but series have less competitors than minimum seconds" do
            it "should return refresh counter default seconds" do
              helper.should_receive(:refresh_counter_auto_scroll).and_return(true)
              series = mock_model(Series)
              competitors = double(Array)
              helper.should_receive(:menu_series).and_return(series)
              series.should_receive(:competitors).and_return(competitors)
              competitors.should_receive(:count).and_return(helper.refresh_counter_min_seconds - 1)
              helper.refresh_counter_seconds.should == helper.refresh_counter_min_seconds
            end            
          end
          
          context "and series have at least as many competitors as minimum seconds" do
            it "should return competitor count" do
              helper.should_receive(:refresh_counter_auto_scroll).and_return(true)
              series = mock_model(Series)
              competitors = double(Array)
              helper.should_receive(:menu_series).and_return(series)
              series.should_receive(:competitors).and_return(competitors)
              competitors.should_receive(:count).and_return(helper.refresh_counter_min_seconds)
              helper.refresh_counter_seconds.should == helper.refresh_counter_min_seconds
            end
          end
        end
      end
    end
  end

  describe "#national_record" do
    before do
      @competitor = mock_model(Competitor)
      @race = mock_model(Race)
      series = mock_model(Series)
      @competitor.stub(:series).and_return(series)
      series.stub(:race).and_return(@race)
    end

    context "when race finished" do
      before do
        @race.stub(:finished?).and_return(true)
      end

      context "when national record passed" do
        it "should return SE" do
          @competitor.stub(:national_record_passed?).and_return(true)
          helper.national_record(@competitor, true).should == 'SE'
        end
      end

      context "when national record reached" do
        it "should return SE(sivuaa)" do
          @competitor.stub(:national_record_passed?).and_return(false)
          @competitor.stub(:national_record_reached?).and_return(true)
          helper.national_record(@competitor, true).should == 'SE(sivuaa)'
        end
      end
    end

    context "when race not finished" do
      before do
        @race.stub(:finished?).and_return(false)
      end

      context "when national record passed" do
        it "should return SE?" do
          @competitor.stub(:national_record_passed?).and_return(true)
          helper.national_record(@competitor, true).should == 'SE?'
        end
      end

      context "when national record reached" do
        it "should return SE(sivuaa)?" do
          @competitor.stub(:national_record_passed?).and_return(false)
          @competitor.stub(:national_record_reached?).and_return(true)
          helper.national_record(@competitor, true).should == 'SE(sivuaa)?'
        end
      end
    end

    context "with decoration" do
      it "should surround text with span and link" do
        @race.stub(:finished?).and_return(true)
        @competitor.stub(:national_record_passed?).and_return(true)
        helper.national_record(@competitor, false).should == "<span class='explanation'><a href=\"" + NATIONAL_RECORD_URL + "\">SE</a></span>"
      end
    end
  end
  
  describe "#organizer_info_with_possible_link", focus: true do
    context "when no home page nor organizer" do
      it "should return nil" do
        race = FactoryGirl.build(:race, home_page: '', organizer: '')
        helper.organizer_info_with_possible_link(Race.new).should be_nil
      end
    end
    
    context "when organizer but no home page" do
      it "should return organizer name" do
        race = FactoryGirl.build(:race, home_page: '', organizer: 'Organizer')
        helper.organizer_info_with_possible_link(race).should == 'Organizer'
      end
    end
    
    context "when home page but no organizer" do
      it "should return link to home page with static text" do
        race = FactoryGirl.build(:race, home_page: 'www.home.com', organizer: '')
        expected_link = '<a href="http://www.home.com" target="_blank">' + t("races.show.race_home_page") + '</a>'
        helper.organizer_info_with_possible_link(race).should == expected_link
      end
    end
      
    context "when home page and organizer" do
      it "should return link to home page with organizer as text" do
        race = FactoryGirl.build(:race, home_page: 'http://www.home.com', organizer: 'Organizer')
        expected_link = '<a href="http://www.home.com" target="_blank">Organizer</a>'
        helper.organizer_info_with_possible_link(race).should == expected_link
      end
    end
  end
end
