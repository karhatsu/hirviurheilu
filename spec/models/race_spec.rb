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
    it { should validate_numericality_of(:team_competitor_count) }
    it { should allow_value(nil).for(:team_competitor_count) }
    it { should_not allow_value(0).for(:team_competitor_count) }
    it { should_not allow_value(1).for(:team_competitor_count) }
    it { should allow_value(2).for(:team_competitor_count) }
    it { should_not allow_value(2.1).for(:team_competitor_count) }

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
    it { should have_many(:correct_estimates) }
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
      @series = Factory.build(:series, :race => @race)
      @race.series << @series
      @race.stub!(:each_competitor_has_correct_estimates?).and_return(true)
    end

    context "when competitors missing correct estimates" do
      before do
        @race.should_receive(:each_competitor_has_correct_estimates?).and_return(false)
      end

      it "should not be possible to finish the race" do
        confirm_unsuccessfull_finish(@race)
      end
    end

    context "when competitors not missing correct estimates" do
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

  describe "#days_count" do
    before do
      @race = Factory.build(:race, :start_date => '2010-12-20')
    end

    context "when only start date defined" do
      it "should return 1" do
        @race.end_date = nil
        @race.days_count.should == 1
      end
    end

    context "when end date same as start date" do
      it "should return 1" do
        @race.end_date = '2010-12-20'
        @race.days_count.should == 1
      end
    end

    context "when end date two days after start date" do
      it "should return 3" do
        @race.end_date = '2010-12-22'
        @race.days_count.should == 3
      end
    end
  end

  describe "#set_correct_estimates_for_competitors" do
    before do
      @race = Factory.create(:race)
      @series1 = Factory.create(:series, :race => @race)
      @series2 = Factory.create(:series, :race => @race, :estimates => 4)
      Factory.create(:correct_estimate, :min_number => 1, :max_number => 5,
        :distance1 => 100, :distance2 => 200,
        :distance3 => 80, :distance4 => 90, :race => @race)
      Factory.create(:correct_estimate, :min_number => 10, :max_number => nil,
        :distance1 => 50, :distance2 => 150, :race => @race)
      @c1 = Factory.create(:competitor, :series => @series1, :number => 1,
        :correct_estimate1 => 1, :correct_estimate2 => 2)
      @c4 = Factory.create(:competitor, :series => @series2, :number => 4)
      @c5 = Factory.create(:competitor, :series => @series1, :number => 5)
      @c6 = Factory.create(:competitor, :series => @series1, :number => 6,
        :correct_estimate1 => 10, :correct_estimate2 => 20,
        :correct_estimate3 => 100, :correct_estimate4 => 200)
      @c9 = Factory.create(:competitor, :series => @series2, :number => 9,
        :correct_estimate1 => 30, :correct_estimate2 => 40,
        :correct_estimate3 => 100, :correct_estimate4 => 200)
      @c10 = Factory.create(:competitor, :series => @series2, :number => 10)
      @c150 = Factory.create(:competitor, :series => @series1, :number => 150)
      @cnil = Factory.create(:competitor, :series => @series1, :number => nil,
        :correct_estimate1 => 50, :correct_estimate2 => 60)
      @race.reload
      @race.set_correct_estimates_for_competitors
      @c1.reload
      @c4.reload
      @c5.reload
      @c6.reload
      @c9.reload
      @c10.reload
      @c150.reload
      @cnil.reload
    end

    it "should copy correct estimates for those numbers that match" do
      @c1.correct_estimate1.should == 100
      @c1.correct_estimate2.should == 200
      @c4.correct_estimate1.should == 100
      @c4.correct_estimate2.should == 200
      @c4.correct_estimate3.should == 80
      @c4.correct_estimate4.should == 90
      @c5.correct_estimate1.should == 100
      @c5.correct_estimate2.should == 200
      @c10.correct_estimate1.should == 50
      @c10.correct_estimate2.should == 150
      @c150.correct_estimate1.should == 50
      @c150.correct_estimate2.should == 150
      @cnil.correct_estimate1.should == 50
      @cnil.correct_estimate2.should == 60
    end

    it "should reset such competitors' correct estimates whose numbers don't match" do
      @c6.correct_estimate1.should be_nil
      @c6.correct_estimate2.should be_nil
      @c6.correct_estimate3.should be_nil
      @c6.correct_estimate4.should be_nil
      @c9.correct_estimate1.should be_nil
      @c9.correct_estimate2.should be_nil
      @c9.correct_estimate3.should be_nil
      @c9.correct_estimate4.should be_nil
    end

    it "should reset those competitors' correct estimates 3 and 4 who need to have only 2" do
      @c1.correct_estimate3.should be_nil
      @c1.correct_estimate4.should be_nil
      @c5.correct_estimate3.should be_nil
      @c5.correct_estimate4.should be_nil
      @c10.correct_estimate3.should be_nil
      @c10.correct_estimate4.should be_nil
      @c150.correct_estimate3.should be_nil
      @c150.correct_estimate4.should be_nil
      @cnil.correct_estimate3.should be_nil
      @cnil.correct_estimate4.should be_nil
    end
  end

  describe "#each_competitor_has_correct_estimates?" do
    before do
      @race = Factory.create(:race)
      series1 = Factory.create(:series, :race => @race)
      series2 = Factory.create(:series, :race => @race)
      @c1 = Factory.create(:competitor, :series => series1,
        :correct_estimate1 => 55, :correct_estimate2 => 111)
      @c2 = Factory.create(:competitor, :series => series2,
        :correct_estimate1 => 100, :correct_estimate2 => 99)
      @c3 = Factory.create(:competitor, :series => series1,
        :correct_estimate1 => 123, :correct_estimate2 => 100)
      @c4 = Factory.create(:competitor, :series => series2,
        :correct_estimate1 => 77, :correct_estimate2 => 88)
    end

    it "should return true when correct estimates exists for all competitors" do
      @race.reload
      @race.each_competitor_has_correct_estimates?.should be_true
    end

    it "should return false when at least one competitor is missing correct estimates" do
      @c3.correct_estimate2 = nil
      @c3.save!
      @race.reload
      @race.each_competitor_has_correct_estimates?.should be_false
    end
  end

  describe "#estimates_at_most" do
    it "should return 2 when no series defined" do
      Factory.build(:race).estimates_at_most.should == 2
    end

    it "should return 2 when all series have 2 estimates" do
      race = Factory.build(:race)
      race.series.build(Factory.build(:series, :race => race))
      race.estimates_at_most.should == 2
    end

    it "should return 4 when at least one series has 4 estimates" do
      race = Factory.create(:race)
      race.series << Factory.build(:series, :race => race)
      race.series << Factory.build(:series, :race => race, :estimates => 4)
      race.estimates_at_most.should == 4
    end
  end

  describe "#has_team_competition?" do
    before do
      @race = Factory.build(:race)
    end

    context "when team_competitor_count is nil" do
      it "should return false" do @race.should_not have_team_competition end
    end

    context "when team_competitor_count is defined" do
      before do
        @race.team_competitor_count = 2
      end
      it "should return true" do @race.should have_team_competition end
    end
  end

  describe "#team_results" do
    before do
      @race = Factory.build(:race, :team_competitor_count => 2)
    end

    it "should return nil if the race has no team competition" do
      @race.team_competitor_count = nil
      @race.team_results.should be_nil
    end

    it "should return empty array if none of the clubs have enough competitors" do
      @club = mock_model(Club)
      @c = mock_model(Competitor, :points => 1100, :club => @club)
      Competitor.stub!(:sort).and_return([@c])
      @race.stub!(:competitors).and_return([])
      @race.team_results.should == []
      @results = @race.team_results
    end

    context "when the clubs have enough competitors" do
      before do
        @club1 = mock_model(Club, :name => 'Club 1')
        @club2 = mock_model(Club, :name => 'Club 2')
        @club_small = mock_model(Club, :name => 'Club small')
        @club1_c1 = mock_model(Competitor, :points => 1100, :club => @club1)
        @club1_c2 = mock_model(Competitor, :points => 1000, :club => @club1)
        @club1_c3 = mock_model(Competitor, :points => 999, :club => @club1)
        @club2_c1 = mock_model(Competitor, :points => 1050, :club => @club2)
        @club2_c2 = mock_model(Competitor, :points => 800, :club => @club2)
        @club_small_c = mock_model(Competitor, :points => 1200, :club => @club_small)
        @club_small_nil_points = mock_model(Competitor, :points => nil, :club => @club_small)
        Competitor.stub!(:sort).and_return(
          [@club_small_c, @club1_c1, @club2_c1, @club1_c2, @club2_c2, @club_small_nil_points])
        @results = @race.team_results
      end

      describe "should return an array of hashes" do
        it "including only the clubs with enough competitors with complete points" do
          @results.length.should == 2
          @results[0][:club].should == @club1
          @results[1][:club].should == @club2
        end

        it "including total points" do
          @results[0][:points].should == 1100 + 1000
          @results[1][:points].should == 1050 + 800
        end

        it "including ordered competitors inside of each team" do
          @results[0][:competitors].length.should == 2
          @results[0][:competitors][0].should == @club1_c1
          @results[0][:competitors][1].should == @club1_c2
          @results[1][:competitors].length.should == 2
          @results[1][:competitors][0].should == @club2_c1
          @results[1][:competitors][1].should == @club2_c2
        end
      end
    end
  end
end
