require 'spec_helper'

describe Race do
  describe "create" do
    it "should create race with valid attrs" do
      Factory.create(:race)
    end
  end

  describe "validation" do
    it "should require sport" do
      Factory.build(:race, :sport => nil).should have(1).errors_on(:sport)
    end

    it "should require name" do
      Factory.build(:race, :name => nil).should have(1).errors_on(:name)
    end

    it "should require location" do
      Factory.build(:race, :location => nil).should have(1).errors_on(:location)
    end

    it "should require start date" do
      Factory.build(:race, :start_date => nil).should have(1).errors_on(:start_date)
    end

    describe "end_date" do
      it "can be nil which makes it same as start date" do
        race = Factory.create(:race, :end_date => nil)
        race.end_date.should == race.start_date
      end

      it "cannot be before start date" do
        Factory.build(:race, :start_date => Date.today + 3, :end_date => Date.today + 2).
          should have(1).errors_on(:end_date)
      end
    end

    describe "start_interval_seconds" do
      it "can be nil" do
        Factory.build(:race, :start_interval_seconds => nil).should be_valid
      end

      it "should be integer, not string" do
        Factory.build(:race, :start_interval_seconds => 'xyz').
          should have(1).errors_on(:start_interval_seconds)
      end

      it "should be integer, not decimal" do
        Factory.build(:race, :start_interval_seconds => 23.5).
          should have(1).errors_on(:start_interval_seconds)
      end

      it "should be greater than 0" do
        Factory.build(:race, :start_interval_seconds => 0).
          should have(1).errors_on(:start_interval_seconds)
      end
    end
  end

  describe "past/ongoing/future" do
    before do
      @past1 = Factory.create(:race, :start_date => Date.today - 10,
        :end_date => nil)
      @past2 = Factory.create(:race, :start_date => Date.today - 7,
        :end_date => Date.today - 6)
      @current1 = Factory.create(:race, :start_date => Date.today - 1,
        :end_date => Date.today + 0)
      @current2 = Factory.create(:race, :start_date => Date.today,
        :end_date => nil)
      @current3 = Factory.create(:race, :start_date => Date.today,
        :end_date => Date.today + 1)
      @future1 = Factory.create(:race, :start_date => Date.today + 1,
        :end_date => Date.today + 2)
      @future2 = Factory.create(:race, :start_date => Date.today + 1,
        :end_date => nil)
    end

    specify { Race.past.should == [@past1, @past2] }
    specify { Race.ongoing.should == [@current1, @current2, @current3] }
    specify { Race.future.should == [@future1, @future2] }
  end
end
