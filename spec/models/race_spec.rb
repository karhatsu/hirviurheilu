require 'spec_helper'

describe Race do
  describe "create" do
    it "should create race with valid attrs" do
      Factory.create(:race)
    end
  end

  describe "validation" do
    it { should validate_presence_of(:sport) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:start_date) }

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
      it "should be required" do
        Factory.build(:race, :start_interval_seconds => nil).
          should have(1).errors_on(:start_interval_seconds)
      end

      it { should validate_numericality_of(:start_interval_seconds) }

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

  describe "associations" do
    it { should belong_to(:sport) }
    it { should have_many(:series) }
    it { should have_many(:competitors).through(:series) }
    it { should have_many(:clubs) }
    it { should have_and_belong_to_many(:users) }
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
      @race = Factory.create(:race)
      @series = Factory.build(:series, :correct_estimate1 => 100,
        :correct_estimate2 => 200, :race => @race)
      @race.series << @series
    end

    context "when series missing correct estimate" do
      before do
        @series.correct_estimate1 = nil
        @series.save!
      end

      context "when series have no competitors" do
        it "should be possible to finish the race" do
          confirm_successfull_finish(@race)
        end
      end

      context "when series have at least 1 competitor" do
        before do
          @series.competitors << Factory.build(:competitor, :series => @series)
        end

        describe "estimate 1 missing" do
          it "should not be possible to finish the race" do
            confirm_unsuccessfull_finish(@race)
          end
        end

        describe "estimate 2 missing" do
          before do
            @series.correct_estimate1 = 80
            @series.correct_estimate2 = nil
            @series.save!
          end

          it "should not be possible to finish the race" do
            confirm_unsuccessfull_finish(@race)
          end
        end
      end
    end

    context "when correct estimates filled" do
      context "when competitors missing results" do
        before do
          @series.competitors << Factory.build(:competitor, :series => @series)
        end

        it "should not be possible to finish the race" do
          confirm_unsuccessfull_finish(@race)
        end
      end

      context "when all competitors have results filled" do
        before do
          @series.competitors << Factory.build(:competitor, :series => @series,
            :no_result_reason => Competitor::DNF)
        end

        it "should be possible to finish the race" do
          confirm_successfull_finish(@race)
        end
      end
    end

    def confirm_successfull_finish(race)
      race.reload
      race.finish.should be_true
      race.should have(0).errors
      race.should be_finished
    end

    def confirm_unsuccessfull_finish(race)
      race.reload
      race.finish.should be_false
      race.should have(1).errors
      race.should_not be_finished
    end
  end

  describe "#finish!" do
    before do
      @race = Factory.build(:race)
    end

    it "should return true when finishing the race succeeds" do
      @race.should_receive(:finish).and_return(true)
      @race.finish!.should be_true
    end

    it "raise exception if finishing the race fails" do
      @race.should_receive(:finish).and_return(false)
      lambda { @race.finish! }.should raise_error
    end
  end

  describe "#destroy" do
    before do
      @race = Factory.create(:race)
    end

    it "should be prevented if race has series" do
      @race.series << Factory.build(:series, :race => @race)
      @race.destroy
      @race.should have(1).errors
      Race.should be_exist(@race.id)
    end

    it "should destroy race when no series" do
      @race.destroy
      Race.should_not be_exist(@race.id)
    end
  end

  describe "#add_default_series" do
    before do
      @ds1 = Factory.create(:default_series, :name => 'DS1')
      @ds1.default_age_groups << Factory.build(:default_age_group,
        :default_series => @ds1, :name => 'DAG1', :min_competitors => 1)
      @ds1.default_age_groups << Factory.build(:default_age_group,
        :default_series => @ds1, :name => 'DAG2', :min_competitors => 2)
      @ds2 = Factory.create(:default_series, :name => 'DS2')
      @race = Factory.build(:race)
    end

    it "should add default series and age groups for the race" do
      @race.add_default_series
      @race.should have(2).series
      s1 = @race.series.first
      s1.name.should == 'DS1'
      s1.should have(2).age_groups
      ag1 = s1.age_groups.first
      ag1.name.should == 'DAG1'
      ag1.min_competitors.should == 1
      ag2 = s1.age_groups.last
      ag2.name.should == 'DAG2'
      ag2.min_competitors.should == 2
      s2 = @race.series.last
      s2.name.should == 'DS2'
      s2.should have(0).age_groups
    end
  end

  describe "DEFAULT_START_INTERVAL" do
    specify { Race::DEFAULT_START_INTERVAL.should == 60 }
  end
end
