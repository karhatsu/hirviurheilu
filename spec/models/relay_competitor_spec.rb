require 'spec_helper'

describe RelayCompetitor do
  it "create" do
    Factory.create(:relay_competitor)
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
        relay = Factory.build(:relay, :legs_count => 3)
        team = Factory.build(:relay_team, :relay => relay)
        competitor = Factory.build(:relay_competitor, :relay_team => team, :leg => 3)
        competitor.should be_valid
        competitor.leg = 4
        competitor.should have(1).errors_on(:leg)
      end

      describe "uniqueness" do
        before do
          Factory.create(:relay_competitor)
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

    describe "arrival_time" do
      it { should allow_value(nil).for(:arrival_time) }

      describe "compared to start time" do
        before do
          @relay = Factory.build(:relay, :start_time => '14:00')
          @team = Factory.build(:relay_team, :relay => @relay)
        end

        it "can be nil even when start time is not nil" do
          Factory.build(:relay_competitor, :relay_team => @team, :leg => 1,
            :arrival_time => nil).should be_valid
        end

        it "should not be before start time" do
          Factory.build(:relay_competitor, :relay_team => @team, :leg => 1,
            :arrival_time => '13:59').should have(1).errors_on(:arrival_time)
        end

        it "should not be same as start time" do
          Factory.build(:relay_competitor, :relay_team => @team, :leg => 1,
            :arrival_time => '14:00').should have(1).errors_on(:arrival_time)
        end

        it "is valid when later than start time" do
          Factory.build(:relay_competitor, :relay_team => @team, :leg => 1,
            :arrival_time => '14:01').should be_valid
        end

        it "cannot be given if no start time" do
          Factory.build(:relay_competitor, :relay_team => @team, :leg => 1,
            :arrival_time => '13:59').should_not be_valid
        end
      end
    end
  end

  describe "#previous_competitor" do
    before do
      @team = Factory.create(:relay_team)
      @c1 = Factory.create(:relay_competitor, :relay_team => @team, :leg => 1)
      @c2 = Factory.create(:relay_competitor, :relay_team => @team, :leg => 2)
      @c3 = Factory.create(:relay_competitor, :relay_team => @team, :leg => 3)
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

  describe "set start time in save" do
    before do
      @relay = Factory.create(:relay, :start_time => '10:30')
      @team = Factory.create(:relay_team, :relay => @relay)
      @c1 = Factory.build(:relay_competitor, :relay_team => @team, :leg => 1)
      @c2 = Factory.build(:relay_competitor, :relay_team => @team, :leg => 2)
    end

    context "when first competitor is saved" do
      it "should set the relay start time as competitor start time" do
        @c1.save!
        @c1.start_time.strftime('%H:%M:%S').should == '10:30:00'
        @relay.start_time = '13:15'
        @relay.save!
        @c1.save!
        @c1.start_time.strftime('%H:%M:%S').should == '13:15:00'
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
end
