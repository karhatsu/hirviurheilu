require 'spec_helper'

describe Competitor do
  describe "create" do
    it "should create competitor with valid attrs" do
      Factory.create(:competitor)
    end
  end

  describe "validation" do
    it "should require first_name" do
      Factory.build(:competitor, :first_name => nil).
        should have(1).errors_on(:first_name)
    end

    it "should require last_name" do
      Factory.build(:competitor, :last_name => nil).
        should have(1).errors_on(:last_name)
    end

    it "should require series" do
      Factory.build(:competitor, :series => nil).
        should have(1).errors_on(:series)
    end

    describe "year_of_birth" do
      it "should be mandatory" do
        Factory.build(:competitor, :year_of_birth => nil).
          should have(1).errors_on(:year_of_birth)
      end

      it "should be integer, not string" do
        Factory.build(:competitor, :year_of_birth => 'xyz').
          should have(1).errors_on(:year_of_birth)
      end

      it "should be integer, not decimal" do
        Factory.build(:competitor, :year_of_birth => 23.5).
          should have(1).errors_on(:year_of_birth)
      end

      it "should be greater than 1900" do
        Factory.build(:competitor, :year_of_birth => 1899).
          should have(1).errors_on(:year_of_birth)
      end

      it "should be less than 2100" do
        Factory.build(:competitor, :year_of_birth => 2101).
          should have(1).errors_on(:year_of_birth)
      end
    end

    describe "number" do
      it "can be nil" do
        Factory.build(:competitor, :number => nil).should be_valid
      end

      it "should be integer, not string" do
        Factory.build(:competitor, :number => 'xyz').
          should have(1).errors_on(:number)
      end

      it "should be integer, not decimal" do
        Factory.build(:competitor, :number => 23.5).
          should have(1).errors_on(:number)
      end

      it "should be greater than 0" do
        Factory.build(:competitor, :number => 0).
          should have(1).errors_on(:number)
      end

      it "should be unique inside of same series" do
        Factory.create(:competitor, :number => 5)
        comp = Factory.create(:competitor, :number => 5)
        comp.should be_valid
        comp = Factory.build(:competitor, :number => 5, :series => comp.series)
        comp.should have(1).errors_on(:number)
      end
    end

    describe "shots_total_input" do
      it "can be nil" do
        Factory.build(:competitor, :shots_total_input => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :shots_total_input => 1.1).
          should have(1).errors_on(:shots_total_input)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :shots_total_input => -1).
          should have(1).errors_on(:shots_total_input)
      end

      it "should be at maximum 100" do
        Factory.build(:competitor, :shots_total_input => 101).
          should have(1).errors_on(:shots_total_input)
      end

      it "cannot be given if also individual shots have been defined" do
        comp = Factory.build(:competitor, :shots_total_input => 50)
        comp.shots << Factory.build(:shot, :competitor => comp, :value => 8)
        comp.should have(1).errors_on(:shots_total_input)
      end

      it "can be given if individual shots only with nils" do
        comp = Factory.build(:competitor, :shots_total_input => 50)
        comp.shots << Factory.build(:shot, :competitor => comp, :value => nil)
        comp.should be_valid
      end
    end
    
    describe "shots" do
      it "should have at maximum ten shots" do
        comp = Factory.build(:competitor)
        10.times do
          comp.shots << Factory.build(:shot, :competitor => comp, :value => 8)
        end
        comp.should be_valid
        comp.shots << Factory.build(:shot, :competitor => comp, :value => 8)
        comp.should have(1).errors_on(:shots)
      end
    end

    describe "estimate1" do
      it "can be nil" do
        Factory.build(:competitor, :estimate1 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :estimate1 => 1.1).
          should have(1).errors_on(:estimate1)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :estimate1 => -1).
          should have(1).errors_on(:estimate1)
      end
    end

    describe "estimate2" do
      it "can be nil" do
        Factory.build(:competitor, :estimate2 => nil).should be_valid
      end

      it "should be integer" do
        Factory.build(:competitor, :estimate2 => 1.1).
          should have(1).errors_on(:estimate2)
      end

      it "should be non-negative" do
        Factory.build(:competitor, :estimate2 => -1).
          should have(1).errors_on(:estimate2)
      end
    end

    describe "arrival_time" do
      it "can be nil" do
        Factory.build(:competitor, :arrival_time => nil).should be_valid
      end

      it "can be nil even when start time is not nil" do
        Factory.build(:competitor, :start_time => '14:00', :arrival_time => nil).
          should be_valid
      end

      it "is valid when at least same as start time" do
        Factory.build(:competitor, :start_time => '14:00', :arrival_time => '14:00').
          should be_valid
      end

      it "should not be before competitor's start time" do
        Factory.build(:competitor, :start_time => '14:00', :arrival_time => '13:59').
          should have(1).errors_on(:arrival_time)
      end
    end

    describe "no_result_reason" do
      it "can be nil" do
        Factory.build(:competitor, :no_result_reason => nil).should be_valid
      end

      it "can be DNS" do
        Factory.build(:competitor, :no_result_reason => Competitor::DNS).should be_valid
      end

      it "can be DNF" do
        Factory.build(:competitor, :no_result_reason => Competitor::DNF).should be_valid
      end

      it "converts empty string to nil" do
        comp = Factory.build(:competitor, :no_result_reason => '')
        comp.should be_valid
        comp.save!
        comp.no_result_reason.should == nil
      end

      it "cannot be anything else" do
        Factory.build(:competitor, :no_result_reason => "test").
          should have(1).errors_on(:no_result_reason)
      end
    end
  end

  describe "shots_sum" do
    it "should return nil when total input is nil and no shots" do
      Factory.build(:competitor).shots_sum.should be_nil
    end

    it "should be shots_total_input when it is given" do
      Factory.build(:competitor, :shots_total_input => 55).shots_sum.should == 55
    end

    it "should be sum of defined individual shots if no input sum" do
      comp = Factory.build(:competitor, :shots_total_input => nil)
      comp.shots << Factory.build(:shot, :value => 8, :competitor => comp)
      comp.shots << Factory.build(:shot, :value => 9, :competitor => comp)
      comp.shots_sum.should == 17
    end
  end

  describe "shot_points" do
    it "should be nil if shots not defined" do
      competitor = Factory.build(:competitor)
      competitor.should_receive(:shots_sum).and_return(nil)
      competitor.shot_points.should be_nil
    end

    it "should be 6 times shots_sum" do
      competitor = Factory.build(:competitor)
      competitor.should_receive(:shots_sum).and_return(50)
      competitor.shot_points.should == 300
    end
  end

  describe "estimate_diff1_m" do
    before do
      @series = Factory.build(:series, :correct_estimate1 => 100, :correct_estimate2 => 200)
    end

    it "should be nil when no estimate1" do
      Factory.build(:competitor, :series => @series, :estimate1 => nil).
        estimate_diff1_m.should be_nil
    end

    it "should be positive diff when estimate1 is more than correct" do
      Factory.build(:competitor, :series => @series, :estimate1 => 105).
        estimate_diff1_m.should == 5
    end

    it "should be negative diff when estimate1 is less than correct" do
      Factory.build(:competitor, :series => @series, :estimate1 => 91).
        estimate_diff1_m.should == -9
    end
  end

  describe "estimate_diff2_m" do
    before do
      @series = Factory.build(:series, :correct_estimate1 => 100, :correct_estimate2 => 200)
    end

    it "should be nil when no estimate2" do
      Factory.build(:competitor, :series => @series, :estimate2 => nil).
        estimate_diff2_m.should be_nil
    end

    it "should be positive diff when estimate2 is more than correct" do
      Factory.build(:competitor, :series => @series, :estimate2 => 205).
        estimate_diff2_m.should == 5
    end

    it "should be negative diff when estimate2 is less than correct" do
      Factory.build(:competitor, :series => @series, :estimate2 => 191).
        estimate_diff2_m.should == -9
    end
  end

  describe "estimate_points" do
    before do
      @series = Factory.build(:series, :correct_estimate1 => 100, :correct_estimate2 => 200)
    end

    it "should be nil if estimate1 is missing" do
      competitor = Factory.build(:competitor, :series => @series,
        :estimate1 => nil, :estimate2 => 145)
      competitor.estimate_points.should be_nil
    end

    it "should be nil if estimate2 is missing" do
      competitor = Factory.build(:competitor, :series => @series,
        :estimate1 => 156, :estimate2 => nil)
      competitor.estimate_points.should be_nil
    end

    it "should be 300 when perfect estimates" do
      competitor = Factory.build(:competitor, :series => @series,
        :estimate1 => 100, :estimate2 => 200)
      competitor.estimate_points.should == 300
    end

    it "should be 298 when the first is 1 meter too low" do
      competitor = Factory.build(:competitor, :series => @series,
        :estimate1 => 99, :estimate2 => 200)
      competitor.estimate_points.should == 298
    end

    it "should be 298 when the second is 1 meter too low" do
      competitor = Factory.build(:competitor, :series => @series,
        :estimate1 => 100, :estimate2 => 199)
      competitor.estimate_points.should == 298
    end

    it "should be 298 when the first is 1 meter too high" do
      competitor = Factory.build(:competitor, :series => @series,
        :estimate1 => 101, :estimate2 => 200)
      competitor.estimate_points.should == 298
    end

    it "should be 298 when the second is 1 meter too high" do
      competitor = Factory.build(:competitor, :series => @series,
        :estimate1 => 100, :estimate2 => 201)
      competitor.estimate_points.should == 298
    end

    it "should never be negative" do
      competitor = Factory.build(:competitor, :series => @series,
        :estimate1 => 111111, :estimate2 => 222222)
      competitor.estimate_points.should == 0
    end
  end

  describe "time_in_seconds" do
    it "should be nil when start time not known yet" do
      Factory.build(:competitor, :start_time => nil).time_in_seconds.should be_nil
    end

    it "should be nil when arrival time is not known yet" do
      Factory.build(:competitor, :start_time => '14:00', :arrival_time => nil).
        time_in_seconds.should be_nil
    end

    it "should be difference of arrival and start times" do
      Factory.build(:competitor, :start_time => '13:58:02', :arrival_time => '15:02:04').
        time_in_seconds.should == 64 * 60 + 2
    end
  end

  describe "time_points" do
    before do
      @series = Factory.build(:series)
      @competitor = Factory.build(:competitor, :series => @series)
      @best_time_seconds = 3600
      @series.stub!(:best_time_in_seconds).and_return(@best_time_seconds)
    end

    it "should be nil when time cannot be calculated yet" do
      @competitor.should_receive(:time_in_seconds).and_return(nil)
      @competitor.time_points.should == nil
    end

    it "should be 300 when this competitor has the best time" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds)
      @competitor.time_points.should == 300
    end

    it "should be 300 when this competitor was five seconds slower than the best" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 5)
      @competitor.time_points.should == 300
    end

    it "should 299 when this competitor was six seconds slower than the best" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 6)
      @competitor.time_points.should == 299
    end

    it "should 299 when this competitor was 11 seconds slower than the best" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 11)
      @competitor.time_points.should == 299
    end

    it "should 298 when this competitor was 12 seconds slower than the best" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 12)
      @competitor.time_points.should == 298
    end

    it "should never be negative" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 100000)
      @competitor.time_points.should == 0
    end

    context "no result" do
      before do
        @competitor = Factory.build(:competitor, :series => @series,
          :no_result_reason => Competitor::DNF)
      end

      it "should be like normally when the competitor has not the best time" do
        @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 12)
        @competitor.time_points.should == 298
      end

      it "should be nil when competitor's time is better than the best time" do
        # note: when no result, the time really can be better than the best time
        # since such a competitor's time cannot be the best time
        @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds - 1)
        @competitor.time_points.should be_nil
      end
    end
  end

  describe "points" do
    before do
      @competitor = Factory.build(:competitor)
      @competitor.stub!(:shot_points).and_return(100)
      @competitor.stub!(:estimate_points).and_return(150)
      @competitor.stub!(:time_points).and_return(200)
    end

    it "should be nil when no shot points" do
      @competitor.should_receive(:shot_points).and_return(nil)
      @competitor.points.should be_nil
    end

    it "should be nil when no estimate points" do
      @competitor.should_receive(:estimate_points).and_return(nil)
      @competitor.points.should be_nil
    end

    it "should be nil when no time points" do
      @competitor.should_receive(:time_points).and_return(nil)
      @competitor.points.should be_nil
    end

    it "should be sum of sub points when all of them are available" do
      @competitor.points.should == 100 + 150 + 200
    end
  end

  describe "points!" do
    before do
      @competitor = Factory.build(:competitor)
      @competitor.stub!(:shot_points).and_return(100)
      @competitor.stub!(:estimate_points).and_return(150)
      @competitor.stub!(:time_points).and_return(200)
    end

    it "should be estimate + time points when no shot points" do
      @competitor.should_receive(:shot_points).and_return(nil)
      @competitor.points!.should == 150 + 200
    end

    it "should be shot + time points when no estimate points" do
      @competitor.should_receive(:estimate_points).and_return(nil)
      @competitor.points!.should == 100 + 200
    end

    it "should be shot + estimate points when no time points" do
      @competitor.should_receive(:time_points).and_return(nil)
      @competitor.points!.should == 100 + 150
    end

    it "should be sum of sub points when all of them are available" do
      @competitor.points!.should == 100 + 150 + 200
    end
  end

  describe "#shot_values" do
    it "should return an array of shot values filled with nils to have total 10 shots" do
      c = Factory.build(:competitor)
      c.shots << Factory.build(:shot, :value => 10, :competitor => c)
      c.shots << Factory.build(:shot, :value => 3, :competitor => c)
      c.shots << Factory.build(:shot, :value => 4, :competitor => c)
      c.shots << Factory.build(:shot, :value => 9, :competitor => c)
      c.shots << Factory.build(:shot, :value => 1, :competitor => c)
      c.shots << Factory.build(:shot, :value => 0, :competitor => c)
      c.shots << Factory.build(:shot, :value => 9, :competitor => c)
      c.shots << Factory.build(:shot, :value => 7, :competitor => c)
      c.shot_values.should == [10,3,4,9,1,0,9,7,nil,nil]
    end
  end

  describe "#next_competitor" do
    before do
      @series = Factory.create(:series)
      @c = Factory.create(:competitor, :series => @series, :number => 15)
      Factory.create(:competitor) # another series
    end

    it "should return itself when no other competitors" do
      @c.next_competitor.should == @c
    end

    context "other competitors" do
      before do
        @first = Factory.create(:competitor, :series => @series, :number => 10)
        @nil = Factory.create(:competitor, :series => @series, :number => nil)
        @prev = Factory.create(:competitor, :series => @series, :number => 12)
        @next = Factory.create(:competitor, :series => @series, :number => 17)
        @last = Factory.create(:competitor, :series => @series, :number => 20)
        @series.reload
      end

      it "should return the competitor with next biggest number when such exists" do
        @c.next_competitor.should == @next
      end

      it "should return the competitor with smallest number when no bigger numbers" do
        @last.next_competitor.should == @first
      end

      it "should return itself if competitor has no number" do
        @nil.next_competitor.should == @nil
      end
    end
  end

  describe "#previous_competitor" do
    before do
      @series = Factory.create(:series)
      @c = Factory.create(:competitor, :series => @series, :number => 15)
      Factory.create(:competitor) # another series
    end

    it "should return itself when no other competitors" do
      @c.previous_competitor.should == @c
    end

    context "other competitors" do
      before do
        @first = Factory.create(:competitor, :series => @series, :number => 10)
        @nil = Factory.create(:competitor, :series => @series, :number => nil)
        @prev = Factory.create(:competitor, :series => @series, :number => 12)
        @next = Factory.create(:competitor, :series => @series, :number => 17)
        @last = Factory.create(:competitor, :series => @series, :number => 20)
        @series.reload
      end

      it "should return the competitor with next smallest number when such exists" do
        @c.previous_competitor.should == @prev
      end

      it "should return the competitor with biggest number when no smaller numbers" do
        @first.previous_competitor.should == @last
      end

      it "should return itself if competitor has no number" do
        @nil.previous_competitor.should == @nil
      end
    end
  end

end
