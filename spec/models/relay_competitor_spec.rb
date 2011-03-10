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
        relay = Factory.build(:relay, :legs => 3)
        team = Factory.build(:relay_team, :relay => relay)
        competitor = Factory.build(:relay_competitor, :relay_team => team, :leg => 3)
        competitor.should be_valid
        competitor.leg = 4
        competitor.should have(1).errors_on(:leg)
      end
    end

    describe "misses" do
      it { should validate_numericality_of(:misses) }
      it { should allow_value(nil).for(:misses) }
      it { should_not allow_value(0).for(:misses) }
      it { should allow_value(1).for(:misses) }
      it { should_not allow_value(1.1).for(:misses) }
      it { should allow_value(5).for(:misses) }
      it { should_not allow_value(6).for(:misses) }
    end

    describe "arrival_time" do
      it { should allow_value(nil).for(:arrival_time) }

      it "can be nil even when start time is not nil" do
        Factory.build(:relay_competitor, :start_time => '14:00', :arrival_time => nil).
          should be_valid
      end

      it "should not be before start time" do
        Factory.build(:relay_competitor, :start_time => '14:00', :arrival_time => '13:59').
          should have(1).errors_on(:arrival_time)
      end

      it "should not be same as start time" do
        Factory.build(:relay_competitor, :start_time => '14:00', :arrival_time => '14:00').
          should have(1).errors_on(:arrival_time)
      end

      it "is valid when later than start time" do
        Factory.build(:relay_competitor, :start_time => '14:00', :arrival_time => '14:01').
          should be_valid
      end

      it "cannot be given if no start time" do
        Factory.build(:relay_competitor, :start_time => nil, :arrival_time => '13:59').
          should_not be_valid
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
end
