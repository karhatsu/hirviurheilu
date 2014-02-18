require 'spec_helper'

describe RelayCompetitor do
  it "create" do
    FactoryGirl.create(:relay_competitor)
  end

  describe "associations" do
    it { should belong_to(:relay_team) }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    describe "leg" do
      it { should validate_numericality_of(:leg) }
      it { should_not allow_value(0).for(:leg) }
      it { should allow_value(1).for(:leg) }
      it { should_not allow_value(1.1).for(:leg) }
      it "should not allow bigger leg value than relay legs count" do
        relay = FactoryGirl.build(:relay, :legs_count => 3)
        team = FactoryGirl.build(:relay_team, :relay => relay)
        competitor = FactoryGirl.build(:relay_competitor, :relay_team => team, :leg => 3)
        competitor.should be_valid
        competitor.leg = 4
        competitor.should have(1).errors_on(:leg)
      end

      describe "uniqueness" do
        before do
          FactoryGirl.create(:relay_competitor)
        end
        it { should validate_uniqueness_of(:leg).scoped_to(:relay_team_id) }
      end
    end

    describe "misses" do
      it { should validate_numericality_of(:misses) }
      it { should allow_value(nil).for(:misses) }
      it { should allow_value(0).for(:misses) }
      it { should allow_value(1).for(:misses) }
      it { should_not allow_value(1.1).for(:misses) }
      it { should allow_value(5).for(:misses) }
      it { should_not allow_value(6).for(:misses) }
    end

    describe "estimate" do
      it { should allow_value(nil).for(:estimate) }
      it { should_not allow_value(1.1).for(:estimate) }
      it { should_not allow_value(-1).for(:estimate) }
      it { should_not allow_value(0).for(:estimate) }
      it { should allow_value(1).for(:estimate) }
    end

    describe "adjustment" do
      it { should allow_value(nil).for(:adjustment) }
      it { should allow_value(-1).for(:adjustment) }
      it { should allow_value(0).for(:adjustment) }
      it { should allow_value(1).for(:adjustment) }
      it { should_not allow_value(1.1).for(:adjustment) }
    end

    describe "arrival_time" do
      it { should allow_value(nil).for(:arrival_time) }

      describe "compared to start time" do
        before do
          @relay = FactoryGirl.build(:relay, :start_time => '14:00')
          @team = FactoryGirl.build(:relay_team, :relay => @relay)
        end

        it "can be nil" do
          FactoryGirl.build(:relay_competitor, :relay_team => @team, :leg => 1,
            :arrival_time => nil).should be_valid
        end

        it "should not be before start time" do
          FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 1, :arrival_time => '00:10:00')
          FactoryGirl.build(:relay_competitor, :relay_team => @team, :leg => 2, :arrival_time => '00:09:59').
              should have(1).errors_on(:arrival_time)
        end

        it "should not be same as start time" do
          FactoryGirl.build(:relay_competitor, :relay_team => @team, :leg => 1,
            :arrival_time => '00:00').should have(1).errors_on(:arrival_time)
        end

        it "is valid when later than start time" do
          FactoryGirl.build(:relay_competitor, :relay_team => @team, :leg => 1,
            :arrival_time => '00:01').should be_valid
        end
      end

      describe "compared to the next competitor's arrival time" do
        it "cannot be later than the next one's arrival time" do
          relay = FactoryGirl.create(:relay, :start_time => '14:00')
          team = FactoryGirl.create(:relay_team, :relay => relay)
          comp1 = FactoryGirl.create(:relay_competitor, :relay_team => team, :leg => 1,
            :arrival_time => '00:10:00')
          FactoryGirl.create(:relay_competitor, :relay_team => team, :leg => 2,
            :arrival_time => '00:20:00')
          comp1.arrival_time = '00:20:01'
          comp1.should have(1).errors_on(:arrival_time)
        end
      end
    end
  end

  describe "#previous_competitor" do
    before do
      @team = FactoryGirl.create(:relay_team)
      @c1 = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 1)
      @c2 = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 2)
      @c3 = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 3)
      @team.reload
    end

    it "should return nil for the first competitor" do
      @c1.previous_competitor.should be_nil
    end

    it "should return the first competitor for the second competitor" do
      @c2.previous_competitor.should == @c1
    end

    it "should return the second competitor for the third competitor" do
      @c3.previous_competitor.should == @c2
    end
  end

  describe "#next_competitor" do
    before do
      @team = FactoryGirl.create(:relay_team)
      @c1 = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 1)
      @c2 = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 2)
      @c3 = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 3)
      @team.reload
    end

    it "should return the second competitor for the first competitor" do
      @c1.next_competitor.should == @c2
    end

    it "should return the third competitor for the second competitor" do
      @c2.next_competitor.should == @c3
    end

    it "should return nil for the last competitor" do
      @c3.next_competitor.should be_nil
    end
  end

  describe "set start time in save" do
    before do
      @relay = FactoryGirl.create(:relay, :start_time => '10:30')
      @team = FactoryGirl.create(:relay_team, :relay => @relay)
      @c1 = FactoryGirl.build(:relay_competitor, :relay_team => @team, :leg => 1)
      @c2 = FactoryGirl.build(:relay_competitor, :relay_team => @team, :leg => 2)
    end

    context "when first competitor is saved" do
      it "should set 00:00 as competitor start time" do
        @c1.save!
        @c1.start_time.strftime('%H:%M:%S').should == '00:00:00'
      end
    end

    context "when non-first competitor is saved" do
      it "should set the previous competitor arrival time as start time" do
        @c1.arrival_time = '10:45:13'
        @c1.save!
        @c2.save!
        @c2.start_time.strftime('%H:%M:%S').should == '10:45:13'
        @c1.arrival_time = '11:01:02'
        @c1.save!
        @c2.save!
        @c2.start_time.strftime('%H:%M:%S').should == '11:01:02'
      end
    end
  end

  describe "set start time for next competitor in update" do
    before do
      @relay = FactoryGirl.create(:relay, :start_time => '10:30', :legs_count => 2)
      @team = FactoryGirl.create(:relay_team, :relay => @relay)
      @c1 = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 1)
      @c2 = FactoryGirl.create(:relay_competitor, :relay_team => @team, :leg => 2)
      @c1.arrival_time = '10:53:29'
    end

    context "when non-last competitor" do
      it "should set the arrival time for the next competitor's start time" do
        @c1.save!
        @c2.reload
        @c2.start_time.strftime('%H:%M:%S').should == '10:53:29'
      end
    end

    context "when the last competitor" do
      it "should not fail" do
        @c1.save!
        @c2.arrival_time = '11:10:07'
        @c2.save!
      end
    end
  end

  describe "#estimate_penalties" do
    before do
      @relay = FactoryGirl.create(:relay)
      team = FactoryGirl.create(:relay_team, :relay => @relay)
      @comp = FactoryGirl.create(:relay_competitor, :relay_team => team, :leg => 2,
        :estimate => 100)
      @relay.stub(:correct_estimate).with(2).and_return(100)
    end

    context "when estimate is nil" do
      it "should be nil" do
        @comp.estimate = nil
        @comp.estimate_penalties.should be_nil
      end
    end

    context "when the correct estimate for the same leg is nil" do
      it "should be nil" do
        @relay.stub(:correct_estimate).with(2).and_return(nil)
        @comp.estimate_penalties.should be_nil
      end
    end

    context "when correct estimate and estimate available" do
      it "should be 0 when perfect estimate" do
        @comp.estimate_penalties.should == 0
      end

      it "should be 0 when estimate 1-5 meters too high" do
        @comp.estimate = 105
        @comp.estimate_penalties.should == 0
      end

      it "should be 0 when estimate 1-5 meters too low" do
        @comp.estimate = 95
        @comp.estimate_penalties.should == 0
      end

      it "should be 1 when estimate 6-10 meters too high" do
        @comp.estimate = 106
        @comp.estimate_penalties.should == 1
        @comp.estimate = 110
        @comp.estimate_penalties.should == 1
      end

      it "should be 1 when estimate 6-10 meters too low" do
        @comp.estimate = 94
        @comp.estimate_penalties.should == 1
        @comp.estimate = 90
        @comp.estimate_penalties.should == 1
      end

      it "should be 4 when estimate 21-25 meters too high" do
        @comp.estimate = 121
        @comp.estimate_penalties.should == 4
        @comp.estimate = 125
        @comp.estimate_penalties.should == 4
      end

      it "should be 4 when estimate 21-25 meters too low" do
        @comp.estimate = 79
        @comp.estimate_penalties.should == 4
        @comp.estimate = 75
        @comp.estimate_penalties.should == 4
      end

      it "should be 5 when estimate 26-30 meters too high" do
        @comp.estimate = 126
        @comp.estimate_penalties.should == 5
        @comp.estimate = 130
        @comp.estimate_penalties.should == 5
      end

      it "should be 5 when estimate 26-30 meters too low" do
        @comp.estimate = 74
        @comp.estimate_penalties.should == 5
        @comp.estimate = 70
        @comp.estimate_penalties.should == 5
      end

      it "should be 5 when estimate at least 31 meters too high" do
        @comp.estimate = 131
        @comp.estimate_penalties.should == 5
      end

      it "should be 5 when estimate at least 31 meters too low" do
        @comp.estimate = 69
        @comp.estimate_penalties.should == 5
      end
    end
  end

  describe "#time_in_seconds" do
    it "should be nil when start time not known yet" do
      FactoryGirl.build(:relay_competitor, :start_time => nil).time_in_seconds.should be_nil
    end

    it "should be nil when arrival time is not known yet" do
      FactoryGirl.build(:relay_competitor, :start_time => '14:00', :arrival_time => nil).
        time_in_seconds.should be_nil
    end

    it "should be difference of arrival and start times when no adjustment" do
      FactoryGirl.build(:relay_competitor, :start_time => '13:58:02', :arrival_time => '15:02:04').
        time_in_seconds.should == 64 * 60 + 2
    end
    it "should be difference of arrival and start times added with adjustment" do
      FactoryGirl.build(:relay_competitor, :start_time => '13:58:02', :arrival_time => '15:02:04', :adjustment => 15).
        time_in_seconds.should == 64 * 60 + 2 + 15
    end
    it "should be difference of arrival and start times added with negative adjustment" do
      FactoryGirl.build(:relay_competitor, :start_time => '13:58:02', :arrival_time => '15:02:04', :adjustment => -15).
        time_in_seconds.should == 64 * 60 + 2 + -15
    end
  end
end
