require 'spec_helper'

describe ApplicationHelper do
  describe "#points_print" do
    it "should print no result reason if it is defined" do
      competitor = mock_model(Competitor, :no_result_reason => Competitor::DNS,
        :points => 145)
      helper.points_print(competitor).should == Competitor::DNS
    end

    it "should print points in case they are available" do
      competitor = mock_model(Competitor, :no_result_reason => nil,
        :points => 145)
      helper.points_print(competitor).should == 145
    end

    it "should print points in brackets if only partial points are available" do
      competitor = mock_model(Competitor, :no_result_reason => nil,
        :points => nil, :points! => 100)
      helper.points_print(competitor).should == "(100)"
    end

    it "should print - if no points at all" do
      competitor = mock_model(Competitor, :no_result_reason => nil,
        :points => nil, :points! => nil)
      helper.points_print(competitor).should == "-"
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
  end

  describe "#shot_points_and_total" do
    it "should print empty string if no result reason defined" do
      competitor = mock_model(Competitor, :shots_sum => 88,
        :no_result_reason => Competitor::DNS)
      helper.shot_points_and_total(competitor).should == ''
    end

    it "should return dash when no shots sum" do
      competitor = mock_model(Competitor, :shots_sum => nil,
        :no_result_reason => nil)
      helper.shot_points_and_total(competitor).should == "-"
    end

    it "should return shot points and sum in brackets" do
      competitor = mock_model(Competitor, :shot_points => 480, :shots_sum => 80,
        :no_result_reason => nil)
      helper.shot_points_and_total(competitor).should == "480 (80)"
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
    it "should return empty string when no estimates" do
      competitor = mock_model(Competitor, :estimate1 => nil, :estimate2 => nil)
      helper.estimate_diffs(competitor).should == ""
    end

    it "should return first and dash when first is available" do
      competitor = mock_model(Competitor, :estimate1 => 50, :estimate2 => nil,
        :estimate_diff1_m => 10, :estimate_diff2_m => nil)
      helper.estimate_diffs(competitor).should == "+10m/-"
    end

    it "should return dash and second when second is available" do
      competitor = mock_model(Competitor, :estimate1 => nil, :estimate2 => 60,
        :estimate_diff1_m => nil, :estimate_diff2_m => -5)
      helper.estimate_diffs(competitor).should == "-/-5m"
    end

    it "should return both when both are available" do
      competitor = mock_model(Competitor, :estimate1 => 120, :estimate2 => 60,
        :estimate_diff1_m => -5, :estimate_diff2_m => 14)
      helper.estimate_diffs(competitor).should == "-5m/+14m"
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

    it "should raise error when index more than 2" do
      lambda { helper.correct_estimate(nil, 3, '') }.should raise_error
    end

    context "race not finished" do
      before do
        race = mock_model(Race, :finished => false)
        @series = mock_model(Series, :race => race)
      end

      specify { helper.correct_estimate(@series, 1, '-').should == '-' }
      specify { helper.correct_estimate(@series, 2, '-').should == '-' }
    end

    context "race finished" do
      context "estimates available" do
        before do
          race = mock_model(Race, :finished => true)
          @series = mock_model(Series, :race => race, :correct_estimate1 => 100,
            :correct_estimate2 => 150)
        end

        specify { helper.correct_estimate(@series, 1, '-').should == 100 }
        specify { helper.correct_estimate(@series, 2, '-').should == 150 }
      end

      context "estimates not available" do
        before do
          race = mock_model(Race, :finished => true)
          @series = mock_model(Series, :race => race, :correct_estimate1 => nil,
            :correct_estimate2 => nil)
        end

        specify { helper.correct_estimate(@series, 1, '-').should == '-' }
        specify { helper.correct_estimate(@series, 2, '-').should == '-' }
      end
    end
  end

  describe "#time_points_and_time" do
    it "should print empty string if no result reason defined" do
      competitor = mock_model(Competitor, :shots_sum => 88,
        :no_result_reason => Competitor::DNS)
      helper.time_points_and_time(competitor).should == ''
    end

    it "should return dash when no time" do
      competitor = mock_model(Competitor, :time_in_seconds => nil,
        :no_result_reason => nil)
      helper.time_points_and_time(competitor).should == "-"
    end

    it "should return shot points and sum in brackets" do
      competitor = mock_model(Competitor, :time_points => 270,
        :time_in_seconds => 2680, :no_result_reason => nil)
      helper.should_receive(:time_from_seconds).with(2680).and_return("45:23")
      helper.time_points_and_time(competitor).should == "270 (45:23)"
    end

    it "should wrap with best time span when full points" do
      competitor = mock_model(Competitor, :time_points => 300,
        :time_in_seconds => 2680, :no_result_reason => nil)
      helper.should_receive(:time_from_seconds).with(2680).and_return("45:23")
      helper.time_points_and_time(competitor).
        should == "<span class='series_best_time'>300 (45:23)</span>"
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
      race = Factory.build(:race)
      helper.should_receive(:date_interval).with(race.start_date, race.end_date).
        and_return('result')
      helper.race_date_interval(race).should == 'result'
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
end

