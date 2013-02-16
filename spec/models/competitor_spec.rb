require 'spec_helper'

describe Competitor do
  describe "create" do
    it "should create competitor with valid attrs" do
      FactoryGirl.create(:competitor)
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

    describe "number" do
      it { should allow_value(nil).for(:number) }
      it { should validate_numericality_of(:number) }
      it { should_not allow_value(23.5).for(:number) }
      it { should_not allow_value(0).for(:number) }
      it { should allow_value(1).for(:number) }

      describe "uniqueness" do
        before do
          @c = FactoryGirl.create(:competitor, :number => 5)
        end
        
        it "should require uniqueness for numbers in the same race" do
          series = FactoryGirl.create(:series, :race => @c.series.race)
          competitor = FactoryGirl.build(:competitor, :series => series, :number => 6)
          competitor.should be_valid
          competitor.number = 5
          competitor.should_not be_valid
        end
        
        it "should allow updating the competitor" do
          @c.should be_valid
        end
        
        it "should allow same number in another race" do
          race = FactoryGirl.create(:race)
          series = FactoryGirl.create(:series)
          FactoryGirl.build(:competitor, :series => series, :number => 5).should be_valid
        end
        
        it "should allow two nils for same series" do
          c = FactoryGirl.create(:competitor, :number => nil)
          FactoryGirl.build(:competitor, :number => nil, :series => c.series).
            should be_valid
        end
      end

      context "when series has start list" do
        it "should not be nil" do
          series = FactoryGirl.build(:series, :has_start_list => true)
          competitor = FactoryGirl.build(:competitor, :series => series, :number => nil)
          competitor.should have(1).errors_on(:number)
        end
      end
    end

    describe "start_time" do
      it { should allow_value(nil).for(:start_time) }

      context "when series has start list" do
        it "should not be nil" do
          series = FactoryGirl.build(:series, :has_start_list => true)
          competitor = FactoryGirl.build(:competitor, :series => series, :start_time => nil)
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
        comp = FactoryGirl.build(:competitor, :shots_total_input => 50)
        comp.shots << FactoryGirl.build(:shot, :competitor => comp, :value => 8)
        comp.shots << FactoryGirl.build(:shot, :competitor => comp, :value => 8)
        comp.should have(1).errors_on(:base)
      end

      it "can be given if individual shots only with nils" do
        comp = FactoryGirl.build(:competitor, :shots_total_input => 50)
        comp.shots << FactoryGirl.build(:shot, :competitor => comp, :value => nil)
        comp.should be_valid
      end
    end
    
    describe "shots" do
      it "should have at maximum ten shots" do
        comp = FactoryGirl.build(:competitor)
        10.times do
          comp.shots << FactoryGirl.build(:shot, :competitor => comp, :value => 8)
        end
        comp.should be_valid
        comp.shots << FactoryGirl.build(:shot, :competitor => comp, :value => 8)
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
        FactoryGirl.build(:competitor, :start_time => '14:00', :arrival_time => nil).
          should be_valid
      end

      it "should not be before start time" do
        FactoryGirl.build(:competitor, :start_time => '14:00', :arrival_time => '13:59').
          should have(1).errors_on(:arrival_time)
      end

      it "should not be same as start time" do
        FactoryGirl.build(:competitor, :start_time => '14:00', :arrival_time => '14:00').
          should have(1).errors_on(:arrival_time)
      end

      it "is valid when later than start time" do
        FactoryGirl.build(:competitor, :start_time => '14:00', :arrival_time => '14:01').
          should be_valid
      end

      it "cannot be given if no start time" do
        FactoryGirl.build(:competitor, :start_time => nil, :arrival_time => '13:59').
          should_not be_valid
      end
    end

    describe "no_result_reason" do
      it { should allow_value(nil).for(:no_result_reason) }
      it { should allow_value(Competitor::DNS).for(:no_result_reason) }
      it { should allow_value(Competitor::DNF).for(:no_result_reason) }
      it { should_not allow_value('test').for(:no_result_reason) }

      it "converts empty string to nil" do
        comp = FactoryGirl.build(:competitor, :no_result_reason => '')
        comp.should be_valid
        comp.save!
        comp.no_result_reason.should == nil
      end
    end
    
    describe "names" do
      it "should be unique for same series" do
        c1 = FactoryGirl.create(:competitor)
        s2 = FactoryGirl.create(:series, :race => c1.race)
        FactoryGirl.build(:competitor, :first_name => c1.first_name,
          :last_name => c1.last_name, :series => c1.series).should_not be_valid
        FactoryGirl.build(:competitor, :first_name => 'Other first name',
          :last_name => c1.last_name, :series => c1.series).should be_valid
        FactoryGirl.build(:competitor, :first_name => c1.first_name,
          :last_name => 'Other last name', :series => c1.series).should be_valid
        FactoryGirl.build(:competitor, :first_name => c1.first_name,
          :last_name => c1.last_name, :series => s2).should be_valid
      end
    end
  end

  describe "race" do
    it "should be the series.race" do
      race = FactoryGirl.build(:race)
      series = FactoryGirl.build(:series, :race => race)
      competitor = FactoryGirl.build(:competitor, :series => series)
      competitor.race.should == race
    end
  end
  
  describe "save" do
    context "when series has no start time nor number but competitor has" do
      it "should set series start time and first number" do
        series = FactoryGirl.create(:series, :start_time => nil, :first_number => nil)
        comp = FactoryGirl.create(:competitor, :series => series, :start_time => '12:35:30', :number => 15)
        series.reload
        series.first_number.should == 15
        series.start_time.strftime('%H:%M:%S').should == '12:35:30'
      end
    end
    
    context "when series already has start time and number" do
      it "should not modify series start time and first number" do
        series = FactoryGirl.create(:series, :start_time => '11:35:30', :first_number => 20)
        comp = FactoryGirl.build(:competitor, :series => series, :start_time => '12:00:30', :number => 25)
        comp.series.should_not_receive(:save!)
        comp.save!
        series.reload
        series.first_number.should == 20
        series.start_time.strftime('%H:%M:%S').should == '11:35:30'
      end
    end
    
    context "when competitor has no start time or number" do
      it "should not save series for nothing" do
        series = FactoryGirl.create(:series, :start_time => nil, :first_number => nil)
        comp = FactoryGirl.build(:competitor, :series => series, :start_time => nil, :number => nil)
        comp.series.should_not_receive(:save!)
        comp.save!
        series.reload
        series.first_number.should be_nil
        series.start_time.should be_nil
      end
    end
  end
  
  describe "concurrency check" do
    context "on create" do
      it "should do nothing" do
        @competitor = FactoryGirl.build(:competitor)
        @competitor.should_not_receive(:values_equal?)
        @competitor.save!
      end
    end
    
    context "on update" do
      before do
        @competitor = FactoryGirl.create(:competitor)
      end
    
      it "should pass if old and current values equal" do
        @competitor.should_receive(:values_equal?).and_return(true)
        @competitor.save
        @competitor.should have(0).errors
      end
      
      it "should fail if old and current values differ" do
        @competitor.should_receive(:values_equal?).and_return(false)
        @competitor.should have(1).errors_on(:base)
      end
    end
  end

  describe "#sort_competitors" do
    before do
      @second_partial = mock_model(Competitor, :points => nil, :points! => 12,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30,
        :time_in_seconds => 999, :unofficial => false, :estimate_points => nil)
      @worst_partial = mock_model(Competitor, :points => nil, :points! => nil,
        :no_result_reason => nil, :shot_points => 51, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => nil)
      @best_partial = mock_model(Competitor, :points => nil, :points! => 88,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => nil)
      @best_time = mock_model(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 87, :time_points => 30,
        :time_in_seconds => 999, :unofficial => false, :estimate_points => 250)
      @best_points = mock_model(Competitor, :points => 201, :points! => 201,
        :no_result_reason => nil, :shot_points => 50, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => 250)
      @worst_points = mock_model(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 87, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => 250)
      @best_shots = mock_model(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 88, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => 250)
      @best_estimates = mock_model(Competitor, :points => 199, :points! => 199,
        :no_result_reason => nil, :shot_points => 86, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => 252)
      @c_dnf = mock_model(Competitor, :points => 300, :points! => 300,
        :no_result_reason => "DNF", :shot_points => 88, :time_points => 30,
        :time_in_seconds => 999, :unofficial => false, :estimate_points => 256)
      @c_dns = mock_model(Competitor, :points => 300, :points! => 300,
        :no_result_reason => "DNS", :shot_points => 88, :time_points => 30,
        :time_in_seconds => 1000, :unofficial => false, :estimate_points => 255)
      @unofficial = mock_model(Competitor, :points => 300, :points! => 300,
        :no_result_reason => nil, :shot_points => 100, :time_points => 100,
        :time_in_seconds => 1000, :unofficial => true, :estimate_points => 250)
    end

    it "should return empty list when no competitors defined" do
      Competitor.sort_competitors([], false).should == []
    end

    # note that partial points equal points when all results are available
    it "should sort by: 1. points 2. partial points 3. shot points " +
        "4. time (secs) 5. normal competitors before DNS/DNF " +
        "6. unofficial competitors before DNS/DNF" do
      competitors = [@unofficial, @second_partial, @worst_partial, @best_partial,
        @c_dnf, @c_dns, @best_time, @best_points, @worst_points, @best_shots]
      Competitor.sort_competitors(competitors, false).should ==
        [@best_points, @best_shots, @best_time, @worst_points, @best_partial,
        @second_partial, @worst_partial, @unofficial, @c_dnf, @c_dns]
    end

    context "when unofficial competitors are handled equal" do
      it "should sort by: 1. points 2. partial points 3. shot points " +
          "4. time (secs) 5. normal competitors before DNS/DNF" do
        competitors = [@unofficial, @second_partial, @worst_partial, @best_partial,
          @c_dnf, @c_dns, @best_time, @best_points, @worst_points, @best_shots]
        Competitor.sort_competitors(competitors, true).should ==
          [@unofficial, @best_points, @best_shots, @best_time, @worst_points,
          @best_partial, @second_partial, @worst_partial, @c_dnf, @c_dns]
      end
    end
    
    describe "by time" do
      it "should sort by: 1. time (secs) 2. points 3. partial points 4. shot points 5. DNS/DNF " do
        competitors = [@second_partial, @worst_partial, @best_partial,
          @c_dnf, @c_dns, @best_time, @best_points, @worst_points, @best_shots]
        Competitor.sort_competitors(competitors, false, Competitor::SORT_BY_TIME).should ==
          [@best_time, @second_partial, @best_points, @best_shots, @worst_points,
            @best_partial, @worst_partial, @c_dnf, @c_dns]
      end
    end
    
    describe "by shots" do
      it "should sort by: 1. shot points 2. points 3. partial points 4. time (secs) 5. DNS/DNF " do
        competitors = [@second_partial, @worst_partial, @best_partial,
          @c_dnf, @c_dns, @best_time, @best_points, @worst_points, @best_shots]
        Competitor.sort_competitors(competitors, false, Competitor::SORT_BY_SHOTS).should ==
        [@best_shots, @best_time, @worst_points, @worst_partial, @best_points,
          @best_partial, @second_partial, @c_dnf, @c_dns]
      end
    end
    
    describe "by estimates" do
      it "should sort by: 1. estimate points 2. points 3. partial points 4. shot points 5. DNS/DNF " do
        competitors = [@worst_partial, @best_partial,
          @c_dnf, @c_dns, @best_time, @best_points, @worst_points, @best_shots, @best_estimates]
        Competitor.sort_competitors(competitors, false, Competitor::SORT_BY_ESTIMATES).should ==
        [@best_estimates, @best_points, @best_shots, @best_time, @worst_points, @best_partial,
          @worst_partial, @c_dnf, @c_dns]
      end
    end
  end

  describe "#shots_sum" do
    it "should return nil when total input is nil and no shots" do
      FactoryGirl.build(:competitor).shots_sum.should be_nil
    end

    it "should be shots_total_input when it is given" do
      FactoryGirl.build(:competitor, :shots_total_input => 55).shots_sum.should == 55
    end

    it "should be sum of defined individual shots if no input sum" do
      comp = FactoryGirl.build(:competitor, :shots_total_input => nil)
      comp.shots << FactoryGirl.build(:shot, :value => 8, :competitor => comp)
      comp.shots << FactoryGirl.build(:shot, :value => 9, :competitor => comp)
      comp.shots << FactoryGirl.build(:shot, :value => nil, :competitor => comp)
      comp.shots_sum.should == 17
    end
  end

  describe "#shot_points" do
    it "should be nil if shots not defined" do
      competitor = FactoryGirl.build(:competitor)
      competitor.should_receive(:shots_sum).and_return(nil)
      competitor.shot_points.should be_nil
    end

    it "should be 6 times shots_sum" do
      competitor = FactoryGirl.build(:competitor)
      competitor.should_receive(:shots_sum).and_return(50)
      competitor.shot_points.should == 300
    end
  end

  describe "#estimate_diff1_m" do
    it "should be nil when no correct estimate1" do
      FactoryGirl.build(:competitor, :estimate1 => 100, :correct_estimate1 => nil).
        estimate_diff1_m.should be_nil
    end

    it "should be nil when no estimate1" do
      FactoryGirl.build(:competitor, :estimate1 => nil, :correct_estimate1 => 100).
        estimate_diff1_m.should be_nil
    end

    it "should be positive diff when estimate1 is more than correct" do
      FactoryGirl.build(:competitor, :estimate1 => 105, :correct_estimate1 => 100).
        estimate_diff1_m.should == 5
    end

    it "should be negative diff when estimate1 is less than correct" do
      FactoryGirl.build(:competitor, :estimate1 => 91, :correct_estimate1 => 100).
        estimate_diff1_m.should == -9
    end
  end

  describe "#estimate_diff2_m" do
    it "should be nil when no correct estimate2" do
      FactoryGirl.build(:competitor, :estimate2 => 100, :correct_estimate2 => nil).
        estimate_diff2_m.should be_nil
    end

    it "should be nil when no estimate2" do
      FactoryGirl.build(:competitor, :estimate2 => nil, :correct_estimate2 => 200).
        estimate_diff2_m.should be_nil
    end

    it "should be positive diff when estimate2 is more than correct" do
      FactoryGirl.build(:competitor, :estimate2 => 205, :correct_estimate2 => 200).
        estimate_diff2_m.should == 5
    end

    it "should be negative diff when estimate2 is less than correct" do
      FactoryGirl.build(:competitor, :estimate2 => 191, :correct_estimate2 => 200).
        estimate_diff2_m.should == -9
    end
  end

  describe "#estimate_diff3_m" do
    it "should be nil when no correct estimate3" do
      FactoryGirl.build(:competitor, :estimate3 => 100, :correct_estimate3 => nil).
        estimate_diff3_m.should be_nil
    end

    it "should be nil when no estimate3" do
      FactoryGirl.build(:competitor, :estimate3 => nil, :correct_estimate3 => 100).
        estimate_diff3_m.should be_nil
    end

    it "should be positive diff when estimate3 is more than correct" do
      FactoryGirl.build(:competitor, :estimate3 => 105, :correct_estimate3 => 100).
        estimate_diff3_m.should == 5
    end

    it "should be negative diff when estimate3 is less than correct" do
      FactoryGirl.build(:competitor, :estimate3 => 91, :correct_estimate3 => 100).
        estimate_diff3_m.should == -9
    end
  end

  describe "#estimate_diff4_m" do
    it "should be nil when no correct estimate4" do
      FactoryGirl.build(:competitor, :estimate4 => 100, :correct_estimate4 => nil).
        estimate_diff4_m.should be_nil
    end

    it "should be nil when no estimate4" do
      FactoryGirl.build(:competitor, :estimate4 => nil, :correct_estimate4 => 200).
        estimate_diff4_m.should be_nil
    end

    it "should be positive diff when estimate4 is more than correct" do
      FactoryGirl.build(:competitor, :estimate4 => 205, :correct_estimate4 => 200).
        estimate_diff4_m.should == 5
    end

    it "should be negative diff when estimate4 is less than correct" do
      FactoryGirl.build(:competitor, :estimate4 => 191, :correct_estimate4 => 200).
        estimate_diff4_m.should == -9
    end
  end

  describe "#estimate_points" do
    describe "estimate missing" do
      it "should be nil if estimate1 is missing" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => nil, :estimate2 => 145,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should be_nil
      end

      it "should be nil if estimate2 is missing" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 156, :estimate2 => nil,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should be_nil
      end

      context "when 4 estimates for the series" do
        before do
          @series = FactoryGirl.build(:series, :estimates => 4)
        end

        it "should be nil if estimate3 is missing" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 145,
            :estimate3 => nil, :estimate4 => 150,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 100, :correct_estimate4 => 200)
          competitor.estimate_points.should be_nil
        end

        it "should be nil if estimate4 is missing" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
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
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => nil, :correct_estimate2 => 200)
        competitor.estimate_points.should be_nil
      end

      it "should be nil if correct estimate 2 is missing" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => nil)
        competitor.estimate_points.should be_nil
      end

      context "when 4 estimates for the series" do
        before do
          @series = FactoryGirl.build(:series, :estimates => 4)
        end

        it "should be nil if correct estimate 3 is missing" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 200,
            :estimate3 => 100, :estimate4 => 200,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => nil, :correct_estimate4 => 200)
          competitor.estimate_points.should be_nil
        end

        it "should be nil if correct estimate 4 is missing" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
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
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 100, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 300
      end

      it "should be 298 when the first is 1 meter too low" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 99, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 298
      end

      it "should be 298 when the second is 1 meter too low" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 100, :estimate2 => 199,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 298
      end

      it "should be 298 when the first is 1 meter too high" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 101, :estimate2 => 200,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 298
      end

      it "should be 298 when the second is 1 meter too high" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 100, :estimate2 => 201,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 298
      end

      it "should be 296 when both have 1 meter difference" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 99, :estimate2 => 201,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 296
      end

      it "should never be negative" do
        competitor = FactoryGirl.build(:competitor,
          :estimate1 => 111111, :estimate2 => 222222,
          :correct_estimate1 => 100, :correct_estimate2 => 200)
        competitor.estimate_points.should == 0
      end
      
      context "when 4 estimates for the series" do
        before do
          @series = FactoryGirl.build(:series, :estimates => 4)
        end
        
        it "should be 600 when perfect estimates" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
            :estimate1 => 100, :estimate2 => 200,
            :estimate3 => 80, :estimate4 => 140,
            :correct_estimate1 => 100, :correct_estimate2 => 200,
            :correct_estimate3 => 80, :correct_estimate4 => 140)
          competitor.estimate_points.should == 600
        end

        it "should be 584 when each estimate is 2 meters wrong" do
          competitor = FactoryGirl.build(:competitor, :series => @series,
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
      FactoryGirl.build(:competitor, :start_time => nil).time_in_seconds.should be_nil
    end

    it "should be nil when arrival time is not known yet" do
      FactoryGirl.build(:competitor, :start_time => '14:00', :arrival_time => nil).
        time_in_seconds.should be_nil
    end

    it "should be difference of arrival and start times" do
      FactoryGirl.build(:competitor, :start_time => '13:58:02', :arrival_time => '15:02:04').
        time_in_seconds.should == 64 * 60 + 2
    end
  end

  describe "#time_points" do
    before do
      @all_competitors = true
      @series = FactoryGirl.build(:series)
      @competitor = FactoryGirl.build(:competitor, :series => @series)
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
        @competitor = FactoryGirl.build(:competitor, :series => @series,
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
      @competitor = FactoryGirl.build(:competitor)
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
      @competitor = FactoryGirl.build(:competitor)
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
      c = FactoryGirl.build(:competitor)
      c.shots << FactoryGirl.build(:shot, :value => 10, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 3, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 4, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 9, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 1, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 0, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 9, :competitor => c)
      c.shots << FactoryGirl.build(:shot, :value => 7, :competitor => c)
      c.shot_values.should == [10,9,9,7,4,3,1,0,nil,nil]
    end
  end

  describe "#next_competitor" do
    before do
      @series = FactoryGirl.create(:series)
      @c = FactoryGirl.create(:competitor, :series => @series, :number => 15)
      FactoryGirl.create(:competitor) # another series
    end

    it "should return itself when no other competitors" do
      @c.next_competitor.should == @c
    end

    context "other competitors" do
      before do
        @first = FactoryGirl.create(:competitor, :series => @series, :number => 10)
        @nil = FactoryGirl.create(:competitor, :series => @series, :number => nil)
        @prev = FactoryGirl.create(:competitor, :series => @series, :number => 12)
        @next = FactoryGirl.create(:competitor, :series => @series, :number => 17)
        @last = FactoryGirl.create(:competitor, :series => @series, :number => 20)
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
      @series = FactoryGirl.create(:series)
      @c = FactoryGirl.create(:competitor, :series => @series, :number => 15)
      FactoryGirl.create(:competitor) # another series
    end

    it "should return itself when no other competitors" do
      @c.previous_competitor.should == @c
    end

    context "other competitors" do
      before do
        @first = FactoryGirl.create(:competitor, :series => @series, :number => 10)
        @nil = FactoryGirl.create(:competitor, :series => @series, :number => nil)
        @prev = FactoryGirl.create(:competitor, :series => @series, :number => 12)
        @next = FactoryGirl.create(:competitor, :series => @series, :number => 17)
        @last = FactoryGirl.create(:competitor, :series => @series, :number => 20)
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
        c = FactoryGirl.build(:competitor, :no_result_reason => Competitor::DNS)
        c.should be_finished
      end
    end

    context "when competitor has no 'no result reason'" do
      before do
        # no need to have correct estimate
        series = FactoryGirl.build(:series)
        @competitor = FactoryGirl.build(:competitor, :no_result_reason => nil,
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
    it "should delegate call to series with own age group and all_competitors as parameters" do
      all_competitors = true
      series = mock_model(Series)
      age_group = mock_model(AgeGroup)
      competitor = FactoryGirl.build(:competitor, :series => series, :age_group => age_group)
      series.should_receive(:comparison_time_in_seconds).with(age_group, all_competitors).and_return(12345)
      competitor.comparison_time_in_seconds(all_competitors).should == 12345
    end
  end

  describe "#reset_correct_estimates" do
    it "should set all correct estimates to nil" do
      c = FactoryGirl.build(:competitor, :correct_estimate1 => 100,
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
        FactoryGirl.create(:competitor)
        FactoryGirl.create(:competitor)
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
      @race = FactoryGirl.create(:race)
      series = FactoryGirl.create(:series, :race => @race)
      @competitor = FactoryGirl.build(:competitor, :series => series, :number => 10)
    end

    context "when no correct estimates defined for this number" do
      it "should leave correct estimates as nil" do
        @competitor.save!
        verify_correct_estimates nil, nil, nil, nil
      end
    end

    context "when correct estimates defined for this number" do
      before do
        @race.correct_estimates << FactoryGirl.build(:correct_estimate, :race => @race,
          :min_number => 9, :distance1 => 101, :distance2 => 102,
          :distance3 => 103, :distance4 => 104)
      end

      it "should set the correct estimates for the competitor" do
        @competitor.number = 11
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
  
  describe "#relative_points" do
    before do
      @all_competitors = false
    end
    
    it "should be -2 when competitor did not start" do
      FactoryGirl.build(:competitor, :no_result_reason => Competitor::DNS).relative_points(@all_competitors).should == -2
    end
    
    it "should be -1 when competitor did not finish" do
      FactoryGirl.build(:competitor, :no_result_reason => Competitor::DNF).relative_points(@all_competitors).should == -1
    end
    
    it "should be 0 when competitor has no results yet" do
      FactoryGirl.build(:competitor).relative_points(@all_competitors).should == 0
    end
    
    it "should be 1000 x points + 100 x partial points + 10 x shot points + time points" do
      c = FactoryGirl.build(:competitor)
      c.stub!(:points).with(@all_competitors).and_return(800)
      c.stub!(:points!).with(@all_competitors).and_return(500)
      c.stub!(:shot_points).and_return(300)
      c.stub!(:time_points).with(@all_competitors).and_return(250)
      c.relative_points(@all_competitors).should == 1000*800 + 100*500 + 10*300 + 250
    end
  end
end
