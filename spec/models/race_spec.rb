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
      @past2 = Factory.create(:race, :start_date => Date.today - 2,
        :end_date => Date.today - 1)
      @current1 = Factory.create(:race, :start_date => Date.today - 1,
        :end_date => Date.today + 0)
      @current2 = Factory.create(:race, :start_date => Date.today,
        :end_date => nil)
      @current3 = Factory.create(:race, :start_date => Date.today,
        :end_date => Date.today + 1)
      @future1 = Factory.create(:race, :start_date => Date.today + 2,
        :end_date => Date.today + 3)
      @future2 = Factory.create(:race, :start_date => Date.today + 1,
        :end_date => nil)
    end

    specify { Race.past.should == [@past2, @past1] }
    specify { Race.ongoing.should == [@current1, @current2, @current3] }
    specify { Race.future.should == [@future2, @future1] }
  end

  describe "#finish" do
    before do
      @competitors = []
      @competitors << mock_model(Competitor, :finished? => true)
      @race = Factory.create(:race)
      @race.series << Factory.build(:series, :correct_estimate1 => 100,
        :correct_estimate2 => 200, :race => @race)
    end

    describe "should return false and sets error when" do
      context "series missing correct estimate" do
        describe "1" do
          before do
            @race.series << Factory.build(:series, :correct_estimate1 => nil,
              :correct_estimate2 => 200, :race => @race)
            @result = @race.finish
          end

          specify { @result.should be_false }
          specify { @race.should have(1).errors }
          specify { @race.should_not be_finished }
        end

        describe "2" do
          before do
            @race.series << Factory.build(:series, :correct_estimate1 => 80,
              :correct_estimate2 => nil, :race => @race)
            @result = @race.finish
          end

          specify { @result.should be_false }
          specify { @race.should have(1).errors }
          specify { @race.should_not be_finished }
        end
      end

      context "competitors missing results" do
        before do
          @competitors << mock_model(Competitor, :finished? => false,
            :first_name => "Test", :last_name => "Competitor")
          @race.should_receive(:competitors).and_return(@competitors)
          @result = @race.finish
        end

        specify { @result.should be_false }
        specify { @race.should have(1).errors }
        specify { @race.should_not be_finished }
      end
    end

    describe "should return true, finish the race and give no errors" do
      context "correct estimates and all results filled" do
        before do
          @race.should_receive(:competitors).and_return(@competitors)
          @result = @race.finish
        end

        specify { @result.should be_true }
        specify { @race.should have(0).errors }
        specify { @race.should be_finished }
      end
    end
  end
end
