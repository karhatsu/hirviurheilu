require 'spec_helper'

describe Competitor do
  describe "create" do
    it "should create competitor with valid attrs" do
      Factory.create(:competitor)
    end
  end

  describe "associations" do
    it { should belong_to(:club) }
    it { should belong_to(:series) }
    it { should belong_to(:age_group) }
    it { should have_many(:shots) }
  end

  describe "validation" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    #it { should validate_presence_of(:series) }
    #it { should validate_presence_of(:club) }

    describe "number" do
      it { should allow_value(nil).for(:number) }
      it { should validate_numericality_of(:number) }
      it { should_not allow_value(23.5).for(:number) }
      it { should_not allow_value(0).for(:number) }
      it { should allow_value(1).for(:number) }

      describe "uniqueness" do
        before do
          @c = Factory.create(:competitor, :number => 5)
        end
        it { should validate_uniqueness_of(:number).scoped_to(:series_id) }
        
        it "should allow two nils for same series" do
          c = Factory.create(:competitor, :number => nil)
          Factory.build(:competitor, :number => nil, :series => c.series).
            should be_valid
        end
      end

      context "when series has start list" do
        it "should not be nil" do
          series = Factory.build(:series, :has_start_list => true)
          competitor = Factory.build(:competitor, :series => series, :number => nil)
          competitor.should have(1).errors_on(:number)
        end
      end
    end

    describe "start_time" do
      it { should allow_value(nil).for(:start_time) }

      context "when series has start list" do
        it "should not be nil" do
          series = Factory.build(:series, :has_start_list => true)
          competitor = Factory.build(:competitor, :series => series, :start_time => nil)
          competitor.should have(1).errors_on(:start_time)
        end
      end
    end

    describe "shots_total_input" do
      it { should allow_value(nil).for(:shots_total_input) }
      it { should_not allow_value(1.1).for(:shots_total_input) }
      it { should_not allow_value(-1).for(:shots_total_input) }
      it { should allow_value(100).for(:shots_total_input) }
      it { should_not allow_value(101).for(:shots_total_input) }

      it "cannot be given if also individual shots have been defined" do
        comp = Factory.build(:competitor, :shots_total_input => 50)
        comp.shots << Factory.build(:shot, :competitor => comp, :value => 8)
        comp.shots << Factory.build(:shot, :competitor => comp, :value => 8)
        comp.should have(1).errors_on(:base)
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
      it { should allow_value(nil).for(:estimate1) }
      it { should_not allow_value(1.1).for(:estimate1) }
      it { should_not allow_value(-1).for(:estimate1) }
      it { should_not allow_value(0).for(:estimate1) }
      it { should allow_value(1).for(:estimate1) }
    end

    describe "estimate2" do
      it { should allow_value(nil).for(:estimate2) }
      it { should_not allow_value(1.1).for(:estimate2) }
      it { should_not allow_value(-1).for(:estimate2) }
      it { should_not allow_value(0).for(:estimate2) }
      it { should allow_value(1).for(:estimate2) }
    end

    describe "estimate3" do
      it { should allow_value(nil).for(:estimate3) }
      it { should_not allow_value(1.1).for(:estimate3) }
      it { should_not allow_value(-1).for(:estimate3) }
      it { should_not allow_value(0).for(:estimate3) }
      it { should allow_value(1).for(:estimate3) }
    end

    describe "estimate4" do
      it { should allow_value(nil).for(:estimate4) }
      it { should_not allow_value(1.1).for(:estimate4) }
      it { should_not allow_value(-1).for(:estimate4) }
      it { should_not allow_value(0).for(:estimate4) }
      it { should allow_value(1).for(:estimate4) }
    end

    describe "correct_estimate1" do
      it { should allow_value(nil).for(:correct_estimate1) }
      it { should_not allow_value(1.1).for(:correct_estimate1) }
      it { should_not allow_value(-1).for(:correct_estimate1) }
      it { should_not allow_value(0).for(:correct_estimate1) }
      it { should allow_value(1).for(:correct_estimate1) }
    end

    describe "correct_estimate2" do
      it { should allow_value(nil).for(:correct_estimate2) }
      it { should_not allow_value(1.1).for(:correct_estimate2) }
      it { should_not allow_value(-1).for(:correct_estimate2) }
      it { should_not allow_value(0).for(:correct_estimate2) }
      it { should allow_value(1).for(:correct_estimate2) }
    end

    describe "correct_estimate3" do
      it { should allow_value(nil).for(:correct_estimate3) }
      it { should_not allow_value(1.1).for(:correct_estimate3) }
      it { should_not allow_value(-1).for(:correct_estimate3) }
      it { should_not allow_value(0).for(:correct_estimate3) }
      it { should allow_value(1).for(:correct_estimate3) }
    end

    describe "correct_estimate4" do
      it { should allow_value(nil).for(:correct_estimate4) }
      it { should_not allow_value(1.1).for(:correct_estimate4) }
      it { should_not allow_value(-1).for(:correct_estimate4) }
      it { should_not allow_value(0).for(:correct_estimate4) }
      it { should allow_value(1).for(:correct_estimate4) }
    end

    describe "arrival_time" do
      it { should allow_value(nil).for(:arrival_time) }

      it "can be nil even when start time is not nil" do
        Factory.build(:competitor, :start_time => '14:00', :arrival_time => nil).
          should be_valid
      end

      it "should not be before start time" do
        Factory.build(:competitor, :start_time => '14:00', :arrival_time => '13:59').
          should have(1).errors_on(:arrival_time)
      end

      it "should not be same as start time" do
        Factory.build(:competitor, :start_time => '14:00', :arrival_time => '14:00').
          should have(1).errors_on(:arrival_time)
      end

      it "is valid when later than start time" do
        Factory.build(:competitor, :start_time => '14:00', :arrival_time => '14:01').
          should be_valid
      end

      it "cannot be given if no start time" do
        Factory.build(:competitor, :start_time => nil, :arrival_time => '13:59').
          should_not be_valid
      end
    end

    describe "no_result_reason" do
      it { should allow_value(nil).for(:no_result_reason) }
      it { should allow_value(Competitor::DNS).for(:no_result_reason) }
      it { should allow_value(Competitor::DNF).for(:no_result_reason) }
      it { should_not allow_value('test').for(:no_result_reason) }

      it "converts empty string to nil" do
        comp = Factory.build(:competitor, :no_result_reason => '')
        comp.should be_valid
        comp.save!
        comp.no_result_reason.should == nil
      end
    end
  end

  describe "#sort" do
    before do
      @second_partial = mock_model(Competitor, :points => nil, :points! => 12,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30,
        :time_in_seconds => 999, :unofficial => false)
      @worst_partial = mock_model(Competitor, :points => nil, :points! => nil,
        :no_result_reason => nil, :shot_points => 51, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false)
      @best_partial = mock_model(Competitor, :points => nil, :points! => 88,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false)
      @best_time = mock_model(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 87, :time_points => 30,
        :time_in_seconds => 999, :unofficial => false)
      @best_points = mock_model(Competitor, :points => 201, :points! => 201,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false)
      @worst_points = mock_model(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 87, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false)
      @best_shots = mock_model(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 88, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false)
      @c_dnf = mock_model(Competitor, :points => 300, :points! => 300,
        :no_result_reason => "DNF", :shot_points => 88, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false)
      @c_dns = mock_model(Competitor, :points => 300, :points! => 300,
        :no_result_reason => "DNS", :shot_points => 88, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false)
      @unofficial = mock_model(Competitor, :points => 300, :points! => 300,
        :no_result_reason => nil, :shot_points => 100, :time_points => 100,
        :time_in_seconds => 1000, :unofficial => true)
    end

    it "should return empty list when no competitors defined" do
      Competitor.sort([], false).should == []
    end

    # note that partial points equal points when all results are available
    it "should sort by: 1. points 2. partial points 3. shot points " +
        "4. time (secs) 5. normal competitors before DNS/DNF " +
        "6. unofficial competitors before DNS/DNF" do
      competitors = [@unofficial, @second_partial, @worst_partial, @best_partial,
        @c_dnf, @c_dns, @best_time, @best_points, @worst_points, @best_shots]
      Competitor.sort(competitors, false).should ==
        [@best_points, @best_shots, @best_time, @worst_points, @best_partial,
        @second_partial, @worst_partial, @unofficial, @c_dnf, @c_dns]
    end

    context "when unofficial competitors are handled equal" do
      it "should sort by: 1. points 2. partial points 3. shot points " +
          "4. time (secs) 5. normal competitors before DNS/DNF" do
        competitors = [@unofficial, @second_partial, @worst_partial, @best_partial,
          @c_dnf, @c_dns, @best_time, @best_points, @worst_points, @best_shots]
        Competitor.sort(competitors, true).should ==
          [@unofficial, @best_points, @best_shots, @best_time, @worst_points,
          @best_partial, @second_partial, @worst_partial, @c_dnf, @c_dns]
      end
    end
  end

  describe "#shots_sum" do
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

  describe "#shot_points" do
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

  describe "#estimate_diff1_m" do
    it "should be nil when no correct estimate1" do
      Factory.build(:competitor, :estimate1 => 100, :correct_estimate1 => nil).
        estimate_diff1_m.should be_nil
    end

    it "should be nil when no estimate1" do
      Factory.build(:competitor, :estimate1 => nil, :correct_estimate1 => 100).
        estimate_diff1_m.should be_nil
    end

    it "should be positive diff when estimate1 is more than correct" do
      Factory.build(:competitor, :estimate1 => 105, :correct_estimate1 => 100).
        estimate_diff1_m.should == 5
    end

    it "should be negative diff when estimate1 is less than correct" do
      Factory.build(:competitor, :estimate1 => 91, :correct_estimate1 => 100).
        estimate_diff1_m.should == -9
    end
  end

  describe "#estimate_diff2_m" do
    it "should be nil when no correct estimate2" do
      Factory.build(:competitor, :estimate2 => 100, :correct_estimate2 => nil).
        estimate_diff2_m.should be_nil
    end

    it "should be nil when no estimate2" do
      Factory.build(:competitor, :estimate2 => nil, :correct_estimate2 => 200).
        estimate_diff2_m.should be_nil
    end

    it "should be positive diff when estimate2 is more than correct" do
      Factory.build(:competitor, :estimate2 => 205, :correct_estimate2 => 200).
        estimate_diff2_m.should == 5
    end

    it "should be negative diff when estimate2 is less than correct" do
      Factory.build(:competitor, :estimate2 => 191, :correct_estimate2 => 200).
        estimate_diff2_m.should == -9
    end
  end

  describe "#estimate_diff3_m" do
    it "should be nil when no correct estimate3" do
      Factory.build(:competitor, :estimate3 => 100, :correct_estimate3 => nil).
        estimate_diff3_m.should be_nil
    end

    it "should be nil when no estimate3" do
      Factory.build(:competitor, :estimate3 => nil, :correct_estimate3 => 100).
        estimate_diff3_m.should be_nil
    end

    it "should be positive diff when estimate3 is more than correct" do
      Factory.build(:competitor, :estimate3 => 105, :correct_estimate3 => 100).
        estimate_diff3_m.should == 5
    end

    it "should be negative diff when estimate3 is less than correct" do
      Factory.build(:competitor, :estimate3 => 91, :correct_estimate3 => 100).
        estimate_diff3_m.should == -9
    end
  end

  describe "#estimate_diff4_m" do
    it "should be nil when no correct estimate4" do
      Factory.build(:competitor, :estimate4 => 100, :correct_estimate4 => nil).
        estimate_diff4_m.should be_nil
    end

    it "should be nil when no estimate4" do
      Factory.build(:competitor, :estimate4 => nil, :correct_estimate4 => 200).
        estimate_diff4_m.should be_nil
    end

    it "should be positive diff when estimate4 is more than correct" do
      Factory.build(:competitor, :estimate4 => 205, :correct_estimate4 => 200).
        estimate_diff4_m.should == 5
    end

    it "should be negative diff when estimate4 is less than correct" do
      Factory.build(:competitor, :estimate4 => 191, :correct_estimate4 => 200).
        estimate_diff4_m.should == -9
    end
  end

  describe "#estimate_points" do
    describe "estimate missing" do
      it "should be nil if estimate1 is missing" do
        competitor = Factory.build(:competitor,
          :estimate1 => nil, :estimate2 => 145,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should be_nil
      end

      it "should be nil if estimate2 is missing" do
        competitor = Factory.build(:competitor,
          :estimate1 => 156, :estimate2 => nil,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should be_nil
      end

      context "when 4 estimates for the series" do
        before do
          @series = Factory.build(:series, :estimates => 4)
        end

        it "should be nil if estimate3 is missing" do
          competitor = Factory.build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 145,
            :estimate3 => nil, :estimate4 => 150,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 100, :correct_estimate4 => 200)
          competitor.estimate_points.should be_nil
        end

        it "should be nil if estimate4 is missing" do
          competitor = Factory.build(:competitor, :series => @series,
            :estimate1 => 156, :estimate2 => 100,
            :estimate3 => 150, :estimate4 => nil,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 100, :correct_estimate4 => 200)
          competitor.estimate_points.should be_nil
        end
      end
    end

    describe "correct estimate missing" do
      it "should be nil if correct estimate 1 is missing" do
        competitor = Factory.build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => nil, :correct_estimate2 => 200)
        competitor.estimate_points.should be_nil
      end

      it "should be nil if correct estimate 2 is missing" do
        competitor = Factory.build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => nil)
        competitor.estimate_points.should be_nil
      end

      context "when 4 estimates for the series" do
        before do
          @series = Factory.build(:series, :estimates => 4)
        end

        it "should be nil if correct estimate 3 is missing" do
          competitor = Factory.build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 200,
            :estimate3 => 100, :estimate4 => 200,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => nil, :correct_estimate4 => 200)
          competitor.estimate_points.should be_nil
        end

        it "should be nil if correct estimate 4 is missing" do
          competitor = Factory.build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 200,
            :estimate3 => 100, :estimate4 => 200,
            :correct_estimate1 => 100, :correct_estimate2 => 150,
            :correct_estimate3 => 100, :correct_estimate4 => nil)
          competitor.estimate_points.should be_nil
        end
      end
    end

    describe "no estimates nor correct estimates missing" do
      it "should be 300 when perfect estimates" do
        competitor = Factory.build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 300
      end

      it "should be 298 when the first is 1 meter too low" do
        competitor = Factory.build(:competitor,
          :estimate1 => 99, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 298
      end

      it "should be 298 when the second is 1 meter too low" do
        competitor = Factory.build(:competitor,
          :estimate1 => 100, :estimate2 => 199,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 298
      end

      it "should be 298 when the first is 1 meter too high" do
        competitor = Factory.build(:competitor,
          :estimate1 => 101, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 298
      end

      it "should be 298 when the second is 1 meter too high" do
        competitor = Factory.build(:competitor,
          :estimate1 => 100, :estimate2 => 201,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 298
      end

      it "should be 296 when both have 1 meter difference" do
        competitor = Factory.build(:competitor,
          :estimate1 => 99, :estimate2 => 201,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 296
      end

      it "should never be negative" do
        competitor = Factory.build(:competitor,
          :estimate1 => 111111, :estimate2 => 222222,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 0
      end
      
      context "when 4 estimates for the series" do
        before do
          @series = Factory.build(:series, :estimates => 4)
        end
        
        it "should be 600 when perfect estimates" do
          competitor = Factory.build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 200,
            :estimate3 => 80, :estimate4 => 140,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 80, :correct_estimate4 => 140)
          competitor.estimate_points.should == 600
        end

        it "should be 584 when each estimate is 2 meters wrong" do
          competitor = Factory.build(:competitor, :series => @series,
            :estimate1 => 98, :estimate2 => 202,
            :estimate3 => 108, :estimate4 => 152,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 110, :correct_estimate4 => 150)
          competitor.estimate_points.should == 584 # 600 - 4*4
        end
      end
    end
  end

  describe "#time_in_seconds" do
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

  describe "#time_points" do
    before do
      @all_competitors = true
      @series = Factory.build(:series)
      @competitor = Factory.build(:competitor, :series => @series)
      @best_time_seconds = 3603.0 # rounded: 3600
      @competitor.stub!(:comparison_time_in_seconds).with(@all_competitors).and_return(@best_time_seconds)
    end

    it "should be nil when time cannot be calculated yet" do
      @competitor.should_receive(:time_in_seconds).and_return(nil)
      @competitor.time_points(@all_competitors).should == nil
    end

    it "should be nil when competitor has time but best time cannot be calculated" do
      # this happens if competitor has time but did not finish (no_result_reason=DNF)
      # and no-one else has result either
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds)
      @competitor.should_receive(:comparison_time_in_seconds).with(@all_competitors).and_return(nil)
      @competitor.time_points(@all_competitors).should == nil
    end

    context "when the competitor has the best time" do
      it "should be 300" do
        @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds)
        @competitor.time_points(@all_competitors).should == 300
      end
    end

    context "when the competitor has worse time which is rounded down to 10 secs" do
      it "should be 300 when the rounded time is the same as the best time rounded" do
        @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 6)
        @competitor.time_points(@all_competitors).should == 300
      end

      it "should be 299 when the rounded time is 10 seconds worse than the best time" do
        @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 7)
        @competitor.time_points(@all_competitors).should == 299
      end

      it "should be 299 when the rounded time is still 10 seconds worse" do
        @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 16)
        @competitor.time_points(@all_competitors).should == 299
      end

      it "should be 298 when the rounded time is 20 seconds worse" do
        @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 17)
        @competitor.time_points(@all_competitors).should == 298
      end
    end
    
    context "when the competitor is an unofficial competitor and has better time than official best time" do
      it "should be 300" do
        @competitor.unofficial = true
        @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds - 60)
        @competitor.time_points(@all_competitors).should == 300
      end
    end

    it "should never be negative" do
      @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 100000)
      @competitor.time_points(@all_competitors).should == 0
    end

    context "when no time points" do
      it "should be nil" do
        @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_NONE
        @competitor.stub!(:time_in_seconds).and_return(@best_time_seconds)
        @competitor.time_points(@all_competitors).should be_nil
      end
    end

    context "when 300 time points for all competitors in the series" do
      it "should be 300" do
        @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_ALL_300
        @competitor.stub!(:time_in_seconds).and_return(nil)
        @competitor.time_points(@all_competitors).should == 300
      end
    end

    context "no result" do
      before do
        @competitor = Factory.build(:competitor, :series => @series,
          :no_result_reason => Competitor::DNF)
        @best_time_seconds = 3603.0
        @competitor.stub!(:comparison_time_in_seconds).with(@all_competitors).and_return(@best_time_seconds)
      end

      it "should be like normally when the competitor has not the best time" do
        @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds + 20)
        @competitor.time_points(@all_competitors).should == 298
      end

      it "should be nil when competitor's time is better than the best time" do
        # note: when no result, the time really can be better than the best time
        # since such a competitor's time cannot be the best time
        @competitor.should_receive(:time_in_seconds).and_return(@best_time_seconds - 1)
        @competitor.time_points(@all_competitors).should be_nil
      end
    end
  end

  describe "#points" do
    before do
      @all_competitors = true
      @competitor = Factory.build(:competitor)
      @competitor.stub!(:shot_points).and_return(100)
      @competitor.stub!(:estimate_points).and_return(150)
      @competitor.stub!(:time_points).with(@all_competitors).and_return(200)
    end

    it "should be nil when no shot points" do
      @competitor.should_receive(:shot_points).and_return(nil)
      @competitor.points(@all_competitors).should be_nil
    end

    it "should be nil when no estimate points" do
      @competitor.should_receive(:estimate_points).and_return(nil)
      @competitor.points(@all_competitors).should be_nil
    end

    context "when series calculates time points" do
      it "should be nil when no time points" do
        @competitor.should_receive(:time_points).with(@all_competitors).and_return(nil)
        @competitor.points(@all_competitors).should be_nil
      end
    end

    context "when series does not calculate time points and shot/estimate points available" do
      it "should be shot + estimate points" do
        @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_NONE
        @competitor.should_receive(:time_points).with(@all_competitors).and_return(nil)
        @competitor.points(@all_competitors).should == 100 + 150
      end
    end

    it "should be sum of sub points when all of them are available" do
      @competitor.points(@all_competitors).should == 100 + 150 + 200
    end
  end

  describe "#points!" do
    before do
      @all_competitors = true
      @competitor = Factory.build(:competitor)
      @competitor.stub!(:shot_points).and_return(100)
      @competitor.stub!(:estimate_points).and_return(150)
      @competitor.stub!(:time_points).with(@all_competitors).and_return(200)
    end

    it "should be estimate + time points when no shot points" do
      @competitor.should_receive(:shot_points).and_return(nil)
      @competitor.points!(@all_competitors).should == 150 + 200
    end

    it "should be shot + time points when no estimate points" do
      @competitor.should_receive(:estimate_points).and_return(nil)
      @competitor.points!(@all_competitors).should == 100 + 200
    end

    it "should be shot + estimate points when no time points" do
      @competitor.should_receive(:time_points).with(@all_competitors).and_return(nil)
      @competitor.points!(@all_competitors).should == 100 + 150
    end

    it "should be sum of sub points when all of them are available" do
      @competitor.points!(@all_competitors).should == 100 + 150 + 200
    end
  end

  describe "#shot_values" do
    it "should return an ordered array of 10 shots" do
      c = Factory.build(:competitor)
      c.shots << Factory.build(:shot, :value => 10, :competitor => c)
      c.shots << Factory.build(:shot, :value => 3, :competitor => c)
      c.shots << Factory.build(:shot, :value => 4, :competitor => c)
      c.shots << Factory.build(:shot, :value => 9, :competitor => c)
      c.shots << Factory.build(:shot, :value => 1, :competitor => c)
      c.shots << Factory.build(:shot, :value => 0, :competitor => c)
      c.shots << Factory.build(:shot, :value => 9, :competitor => c)
      c.shots << Factory.build(:shot, :value => 7, :competitor => c)
      c.shot_values.should == [10,9,9,7,4,3,1,0,nil,nil]
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

      it "should return the next by id if competitor has no number" do
        @nil.next_competitor.should == @prev
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

      it "should return the previous by id if competitor has no number" do
        @nil.previous_competitor.should == @first
      end
    end
  end

  describe "#finished?" do
    context "when competitor has some 'no result reason'" do
      it "should return true" do
        c = Factory.build(:competitor, :no_result_reason => Competitor::DNS)
        c.should be_finished
      end
    end

    context "when competitor has no 'no result reason'" do
      before do
        # no need to have correct estimate
        series = Factory.build(:series)
        @competitor = Factory.build(:competitor, :no_result_reason => nil,
          :series => series)
        @competitor.start_time = '11:10'
        @competitor.arrival_time = '11:20'
        @competitor.shots_total_input = 90
        @competitor.estimate1 = 100
        @competitor.estimate2 = 110
      end

      context "when competitor has shots and arrival time" do
        context "when competitor has both estimates" do
          it "should return true" do
            @competitor.should be_finished
          end
        end

        context "when either estimate is missing" do
          it "should return false" do
            @competitor.estimate2 = nil
            @competitor.should_not be_finished
            @competitor.estimate1 = nil
            @competitor.estimate2 = 110
            @competitor.should_not be_finished
          end
        end

        context "when 4 estimates for the series" do
          before do
            @competitor.series.estimates = 4
          end

          context "when 3rd estimate is missing" do
            it "should return false" do
              @competitor.estimate3 = nil
              @competitor.estimate4 = 110
              @competitor.should_not be_finished
            end
          end

          context "when 4th estimate is missing" do
            it "should return false" do
              @competitor.estimate3 = 110
              @competitor.estimate4 = nil
              @competitor.should_not be_finished
            end
          end
        end
      end

      context "when shots result is missing" do
        it "should return false" do
          @competitor.shots_total_input = nil
          @competitor.should_not be_finished
        end
      end

      context "when time result is missing" do
        it "should return false" do
          @competitor.arrival_time = nil
          @competitor.should_not be_finished
        end
      end

      context "when series does not calculate time points and other results are there" do
        it "should return true" do
          @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_NONE
          @competitor.arrival_time = nil
          @competitor.should be_finished
        end
      end

      context "when series gives 300 time points for all and other results are there" do
        it "should return true" do
          @competitor.series.time_points_type = Series::TIME_POINTS_TYPE_ALL_300
          @competitor.arrival_time = nil
          @competitor.should be_finished
        end
      end
    end
  end

  describe "#comparison_time_in_seconds" do
    before do
      @all_competitors = true
      @series = Factory.build(:series)
      @competitor = Factory.build(:competitor, :series => @series)
    end

    context "when competitor belongs to an age group" do
      before do
        @age_group = Factory.build(:age_group)
        @competitor.age_group = @age_group
        @series.stub!(:best_time_in_seconds).with(@all_competitors).and_return(555)
      end

      context "and age group provides best time (= it has enough competitors)" do
        it "should use age group's best time" do
          @age_group.should_receive(:best_time_in_seconds).with(@all_competitors).and_return(123)
          @competitor.comparison_time_in_seconds(@all_competitors).should == 123
        end
      end

      context "but age group does not provide best time" do
        it "should use the series best time" do
          @age_group.should_receive(:best_time_in_seconds).with(@all_competitors).and_return(nil)
          @competitor.comparison_time_in_seconds(@all_competitors).should == 555
        end
      end
    end

    context "when no age group" do
      it "should use the series best time" do
        @series.should_receive(:best_time_in_seconds).with(@all_competitors).and_return(456)
        @competitor.comparison_time_in_seconds(@all_competitors).should == 456
      end
    end
  end

  describe "#reset_correct_estimates" do
    it "should set all correct estimates to nil" do
      c = Factory.build(:competitor, :correct_estimate1 => 100,
        :correct_estimate2 => 110, :correct_estimate3 => 130,
        :correct_estimate4 => 140)
      c.reset_correct_estimates
      c.correct_estimate1.should be_nil
      c.correct_estimate2.should be_nil
      c.correct_estimate3.should be_nil
      c.correct_estimate4.should be_nil
    end
  end

  describe "#free_offline_competitors_left" do
    context "when online state" do
      it "should raise error" do
        Mode.stub!(:online?).and_return(true)
        Mode.stub!(:offline?).and_return(false)
        lambda { Competitor.free_offline_competitors_left }.should raise_error
      end
    end

    context "when offline state" do
      before do
        Mode.stub!(:online?).and_return(false)
        Mode.stub!(:offline?).and_return(true)
      end

      it "should return full amount initially" do
        Competitor.free_offline_competitors_left.should ==
          Competitor::MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE
      end

      it "should recude added competitors from the full amount" do
        Factory.create(:competitor)
        Factory.create(:competitor)
        Competitor.free_offline_competitors_left.should ==
          Competitor::MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE - 2
      end

      it "should be zero when would actually be negative (for some reason)" do
        Competitor.stub!(:count).and_return(Competitor::MAX_FREE_COMPETITOR_AMOUNT_IN_OFFLINE + 1)
        Competitor.free_offline_competitors_left.should == 0
      end
    end
  end

  describe "create with number" do
    before do
      @race = Factory.create(:race)
      series = Factory.create(:series, :race => @race)
      @competitor = Factory.build(:competitor, :series => series, :number => 10)
    end

    context "when no correct estimates defined for this number" do
      it "should leave correct estimates as nil" do
        @competitor.save!
        verify_correct_estimates nil, nil, nil, nil
      end
    end

    context "when correct estimates defined for this number" do
      before do
        @race.correct_estimates << Factory.build(:correct_estimate, :race => @race,
          :min_number => 9, :distance1 => 101, :distance2 => 102,
          :distance3 => 103, :distance4 => 104)
      end

      it "should set the correct estimates for the competitor" do
        @competitor.save!
        verify_correct_estimates 101, 102, 103, 104
      end
    end

    def verify_correct_estimates(ce1, ce2, ce3, ce4)
      @competitor.reload
      @competitor.correct_estimate1.should == ce1
      @competitor.correct_estimate2.should == ce2
      @competitor.correct_estimate3.should == ce3
      @competitor.correct_estimate4.should == ce4
    end
  end
end
