require 'spec_helper'

describe Race do
  describe "create" do
    it "should create race with valid attrs" do
      FactoryGirl.create(:race)
    end
  end

  describe "validation" do
    it { should validate_presence_of(:sport) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:start_date) }

    describe "end_date" do
      it "can be nil which makes it same as start date" do
        race = FactoryGirl.create(:race, :end_date => nil)
        race.end_date.should == race.start_date
      end

      it "cannot be before start date" do
        FactoryGirl.build(:race, :start_date => Date.today + 3, :end_date => Date.today + 2).
          should have(1).errors_on(:end_date)
      end
    end

    describe "start_interval_seconds" do
      it { should validate_numericality_of(:start_interval_seconds) }
      it { should_not allow_value(nil).for(:start_interval_seconds) }
      it { should_not allow_value(23.5).for(:start_interval_seconds) }
      it { should_not allow_value(0).for(:start_interval_seconds) }
    end

    describe "batch_interval_seconds" do
      it { should validate_numericality_of(:batch_interval_seconds) }
      it { should_not allow_value(nil).for(:batch_interval_seconds) }
      it { should_not allow_value(23.5).for(:batch_interval_seconds) }
      it { should_not allow_value(0).for(:batch_interval_seconds) }
    end

    describe "batch_size" do
      it { should validate_numericality_of(:batch_size) }
      it { should_not allow_value(nil).for(:batch_size) }
      it { should_not allow_value(23.5).for(:batch_size) }
      it { should_not allow_value(-1).for(:batch_size) }
      it { should allow_value(0).for(:batch_size) }
    end

    describe "club_level" do
      it { should allow_value(Race::CLUB_LEVEL_SEURA).for(:club_level) }
      it { should allow_value(Race::CLUB_LEVEL_PIIRI).for(:club_level) }
      it { should_not allow_value(2).for(:club_level) }

      it "should convert nil to SEURA" do
        race = FactoryGirl.create(:race, :club_level => nil)
        race.club_level.should == Race::CLUB_LEVEL_SEURA
      end
    end
    
    describe "start_order" do
      it { should_not allow_value(Race::START_ORDER_BY_SERIES - 1).for(:start_order) }
      it { should allow_value(Race::START_ORDER_BY_SERIES).for(:start_order) }
      it { should allow_value(Race::START_ORDER_MIXED).for(:start_order) }
      it { should_not allow_value(Race::START_ORDER_MIXED + 1).for(:start_order) }
    end

    describe "race with same name" do
      before do
        @race = FactoryGirl.create(:race, :name => 'My race', :start_date => '2010-01-01',
          :location => 'My town')
      end

      it "should allow if same location, different start date" do
        FactoryGirl.build(:race, :name => 'My race', :start_date => '2011-01-01',
          :location => 'My town').should be_valid
      end

      it "should allow if different location, same start date" do
        FactoryGirl.build(:race, :name => 'My race', :start_date => '2010-01-01',
          :location => 'Different town').should be_valid
      end

      it "should allow updating the existing race" do
        @race.should be_valid
      end

      it "should prevent if same location, same start date" do
        FactoryGirl.build(:race, :name => 'My race', :start_date => '2010-01-01',
          :location => 'My town').should_not be_valid
      end
    end
  end

  describe "associations" do
    it { should belong_to(:sport) }
    it { should have_many(:series) }
    it { should have_many(:age_groups).through(:series) }
    it { should have_many(:competitors).through(:series) }
    it { should have_many(:clubs) }
    it { should have_many(:correct_estimates) }
    it { should have_many(:relays) }
    it { should have_many(:team_competitions) }
    it { should have_many(:race_rights) }
    it { should have_many(:users).through(:race_rights) }
    it { should have_and_belong_to_many(:cups) }
  end

  describe "default" do
    it "start time should be 00:00:00" do
      Race.new.start_time.strftime('%H:%M:%S').should == '00:00:00'
    end
  end

  describe "update" do
    context "when start order changed from mixed to by series" do
      before do
        @race = FactoryGirl.create(:race, :start_order => Race::START_ORDER_MIXED)
        @series = FactoryGirl.create(:series, :race => @race)
        FactoryGirl.create(:competitor, :series => @series, :start_time => '11:00:00', :number => 4)
        @race.reload
      end
  
      it "should be valid" do
        @race.start_order = Race::START_ORDER_BY_SERIES
        @race.should be_valid
      end
      
      it "should not modify series anyhow" do
        @race.start_order = Race::START_ORDER_BY_SERIES
        @race.series.each { |s| s.should_not_receive(:save!) }
        @race.save!
      end
    end
      
    context "when start order changed from by series to mixed" do
      before do
        @race = FactoryGirl.create(:race, :start_order => Race::START_ORDER_BY_SERIES)
        @series1 = FactoryGirl.create(:series, :race => @race, :has_start_list => false)
        @series2 = FactoryGirl.create(:series, :race => @race, :has_start_list => true)
        @series3 = FactoryGirl.create(:series, :race => @race, :has_start_list => false)
      end
    
      context "when at least one competitor without start time" do
        it "should not be allowed" do
          FactoryGirl.create(:competitor, :series => @series1, :number => 55)
          @race.reload
          @race.start_order = Race::START_ORDER_MIXED
          @race.should_not be_valid
        end
      end
      
      context "when only competitors with start time and number" do
        it "should be allowed" do
          FactoryGirl.create(:competitor, :series => @series1, :start_time => '12:00:00', :number => 2)
          @race.reload
          @race.start_order = Race::START_ORDER_MIXED
          @race.should be_valid
        end
        
        it "should set that all series have start list" do
          @race.reload
          @race.start_order = Race::START_ORDER_MIXED
          @race.save!
          @race.series.each do |s|
            s.should have_start_list
          end
        end
      end
    end
    
    context "when start order remains as mixed" do
      before do
        @race = FactoryGirl.create(:race, :start_order => Race::START_ORDER_MIXED)
        @series = FactoryGirl.create(:series, :race => @race)
        @race.reload
      end
      
      it "should not modify series anyhow" do
        @race.days_count = 2
        @race.series.each { |s| s.should_not_receive(:save!) }
        @race.save!
      end
    end
    
    context "when start order remains as by series" do
      before do
        @race = FactoryGirl.create(:race, :start_order => Race::START_ORDER_BY_SERIES)
        @series = FactoryGirl.create(:series, :race => @race)
        @race.reload
      end
      
      it "should not modify series anyhow" do
        @race.days_count = 2
        @race.series.each { |s| s.should_not_receive(:save!) }
        @race.save!
      end
    end
  end

  describe "past/ongoing/future" do
    before do
      @past1 = FactoryGirl.create(:race, :start_date => Date.today - 10,
        :end_date => nil)
      @past2 = FactoryGirl.create(:race, :start_date => Date.today - 2,
        :end_date => Date.today - 1)
      @current1 = FactoryGirl.create(:race, :start_date => Date.today - 1,
        :end_date => Date.today + 0)
      @current2 = FactoryGirl.create(:race, :start_date => Date.today,
        :end_date => nil)
      @current3 = FactoryGirl.create(:race, :start_date => Date.today,
        :end_date => Date.today + 1)
      @future1 = FactoryGirl.create(:race, :start_date => Date.today + 2,
        :end_date => Date.today + 3)
      @future2 = FactoryGirl.create(:race, :start_date => Date.today + 1,
        :end_date => nil)
    end

    it "#past should return past races" do
      Race.past.should == [@past2, @past1]
    end

    it "#ongoing should return ongoing races" do
      Race.ongoing.should == [@current1, @current2, @current3]
    end

    it "#future should return future races" do
      Race.future.should == [@future2, @future1]
    end

    describe "no date caching" do
      before do
        @zone = mock(Object)
        Time.stub!(:zone).and_return(@zone)
      end
      
      it "past" do
        @zone.stub!(:today).and_return(Date.today)
        Race.past.should_not be_empty
        @zone.stub!(:today).and_return(Date.today - 10)
        Race.past.should be_empty
      end
      
      it "ongoing" do
        @zone.stub!(:today).and_return(Date.today)
        Race.ongoing.should_not be_empty
        @zone.stub!(:today).and_return(Date.today + 10)
        Race.ongoing.should be_empty
      end
      
      it "future" do
        @zone.stub!(:today).and_return(Date.today)
        Race.future.should_not be_empty
        @zone.stub!(:today).and_return(Date.today + 10)
        Race.future.should be_empty
      end
    end
  end

  describe "#finish" do
    before do
      @race = FactoryGirl.create(:race)
      @series = FactoryGirl.build(:series, :race => @race)
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
          @series.competitors << FactoryGirl.build(:competitor, :series => @series)
        end

        it "should not be possible to finish the race" do
          confirm_unsuccessfull_finish(@race)
        end
      end

      context "when all competitors have results filled" do
        before do
          @series.competitors << FactoryGirl.build(:competitor, :series => @series,
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
      @race = FactoryGirl.build(:race)
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
  
  describe "#can_destroy?" do
    before do
      @race = FactoryGirl.create(:race)
    end
    
    it "should be false when competitors" do
      series = FactoryGirl.build(:series, :race => @race)
      @race.series << series
      series.competitors << FactoryGirl.build(:competitor)
      @race.can_destroy?.should be_false
    end
    
    it "should be false when relays" do
      @race.relays << FactoryGirl.build(:relay, :race => @race)
      @race.can_destroy?.should be_false
    end
    
    it "should be true when no competitors, nor relays" do
      @series = FactoryGirl.build(:series, :race => @race)
      @race.series << @series
      @race.can_destroy?.should be_true
    end
  end

  describe "#destroy" do
    before do
      @race = FactoryGirl.create(:race)
      @series = FactoryGirl.build(:series, :race => @race)
      @race.series << @series
      @competitor = FactoryGirl.build(:competitor, :series => @series)
      @series.competitors << @competitor
      @team_competition = FactoryGirl.build(:team_competition, :race => @race)
      @race.team_competitions << @team_competition
      @relay = FactoryGirl.build(:relay, :race => @race)
      @race.relays << @relay
      @relay_team = FactoryGirl.build(:relay_team, :relay => @relay)
      @relay.relay_teams << @relay_team
      @relay_competitor = FactoryGirl.build(:relay_competitor, :relay_team => @relay_team)
      @relay_team.relay_competitors << @relay_competitor
    end
  
    it "should destroy race and all its children" do
      @race.reload
      @race.destroy
      @race.should be_destroyed
      Series.exists?(@series.id).should be_false
      Competitor.exists?(@competitor.id).should be_false
      TeamCompetition.exists?(@team_competition.id).should be_false
      Relay.exists?(@relay.id).should be_false
      RelayTeam.exists?(@relay_team.id).should be_false
      RelayCompetitor.exists?(@relay_competitor.id).should be_false
    end
  end

  describe "#add_default_series" do
    before do
      @ds1 = DefaultSeries.new('DS1', ['DAG1', 1], ['DAG2', 2])
      @ds2 = DefaultSeries.new('DS2')
      DefaultSeries.stub!(:all).and_return([@ds1, @ds2])
      @race = FactoryGirl.build(:race)
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

  describe "DEFAULT_BATCH_INTERVAL" do
    specify { Race::DEFAULT_BATCH_INTERVAL.should == 180 }
  end

  describe "#days_count" do
    before do
      @race = FactoryGirl.build(:race, :start_date => '2010-12-20')
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
  
  describe "#days_count=" do
    before do
      @race = FactoryGirl.build(:race, :start_date => nil, :end_date => nil)
    end
    
    describe "invalid value" do
      it "should raise error when 0 given" do
        lambda { @race.days_count = 0 }.should raise_error
      end

      it "should raise error when negative number given" do
        lambda { @race.days_count = -1 }.should raise_error
      end

      it "should raise error when nil given" do
        lambda { @race.days_count = nil }.should raise_error
      end
    end
    
    context "when start date" do
      it "should set end date to same as start date when 1 given" do
        @race.start_date = '2011-12-17'
        @race.days_count = 1
        @race.end_date.should == @race.start_date
      end
      
      it "should set end date to one bigger than start date when 2 given" do
        @race.start_date = '2011-12-17'
        @race.days_count = 2
        @race.end_date.should == @race.start_date + 1
      end
    end
    
    context "when no start date" do
      it "should store days_count for future usage" do
        @race.days_count = 2
        @race.end_date.should be_nil
        @race.start_date = '2011-12-15'
        @race.end_date.should == @race.start_date + 1
      end
      
      it "should not be used after end date is set" do
        @race.days_count = 2
        end_date = '2011-12-17'
        @race.start_date = '2011-12-15'
        @race.end_date = end_date
        @race.start_date = '2011-12-10'
        @race.end_date.strftime('%Y-%m-%d').should == end_date
      end
    end
    
    context "when start date set twice" do
      it "should change end date in both times" do
        @race.days_count = 3
        @race.start_date = '2012-01-05'
        @race.end_date.should == @race.start_date + 2
        @race.start_date = '2012-01-10'
        @race.end_date.should == @race.start_date + 2
      end
    end
    
    it "should accept also string number" do
        @race.start_date = '2011-12-17'
        @race.days_count = "2"
        @race.end_date.should == @race.start_date + 1
    end
  end

  describe "#set_correct_estimates_for_competitors" do
    before do
      @race = FactoryGirl.create(:race)
      @series1 = FactoryGirl.create(:series, :race => @race)
      @series2 = FactoryGirl.create(:series, :race => @race, :estimates => 4)
      FactoryGirl.create(:correct_estimate, :min_number => 1, :max_number => 5,
        :distance1 => 100, :distance2 => 200,
        :distance3 => 80, :distance4 => 90, :race => @race)
      FactoryGirl.create(:correct_estimate, :min_number => 10, :max_number => nil,
        :distance1 => 50, :distance2 => 150, :race => @race)
      @c1 = FactoryGirl.create(:competitor, :series => @series1, :number => 1,
        :correct_estimate1 => 1, :correct_estimate2 => 2)
      @c4 = FactoryGirl.create(:competitor, :series => @series2, :number => 4)
      @c5 = FactoryGirl.create(:competitor, :series => @series1, :number => 5)
      @c6 = FactoryGirl.create(:competitor, :series => @series1, :number => 6,
        :correct_estimate1 => 10, :correct_estimate2 => 20,
        :correct_estimate3 => 100, :correct_estimate4 => 200)
      @c9 = FactoryGirl.create(:competitor, :series => @series2, :number => 9,
        :correct_estimate1 => 30, :correct_estimate2 => 40,
        :correct_estimate3 => 100, :correct_estimate4 => 200)
      @c10 = FactoryGirl.create(:competitor, :series => @series2, :number => 10)
      @c150 = FactoryGirl.create(:competitor, :series => @series1, :number => 150)
      @cnil = FactoryGirl.create(:competitor, :series => @series1, :number => nil,
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
      @race = FactoryGirl.create(:race)
      series1 = FactoryGirl.create(:series, :race => @race)
      series2 = FactoryGirl.create(:series, :race => @race)
      @c1 = FactoryGirl.create(:competitor, :series => series1,
        :correct_estimate1 => 55, :correct_estimate2 => 111)
      @c2 = FactoryGirl.create(:competitor, :series => series2,
        :correct_estimate1 => 100, :correct_estimate2 => 99)
      @c3 = FactoryGirl.create(:competitor, :series => series1,
        :correct_estimate1 => 123, :correct_estimate2 => 100)
      @c4 = FactoryGirl.create(:competitor, :series => series2,
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
      FactoryGirl.build(:race).estimates_at_most.should == 2
    end

    it "should return 2 when all series have 2 estimates" do
      race = FactoryGirl.create(:race)
      race.series << FactoryGirl.build(:series, :race => race)
      race.estimates_at_most.should == 2
    end

    it "should return 4 when at least one series has 4 estimates" do
      race = FactoryGirl.create(:race)
      race.series << FactoryGirl.build(:series, :race => race)
      race.series << FactoryGirl.build(:series, :race => race, :estimates => 4)
      race.estimates_at_most.should == 4
    end
  end

  describe "#has_team_competition?" do
    before do
      @race = FactoryGirl.build(:race)
    end

    context "when team_competitions is empty" do
      it "should return false" do @race.should_not have_team_competition end
    end

    context "when team_competitions is not empty" do
      before do
        @race.team_competitions << FactoryGirl.build(:team_competition, :race => @race)
      end
      it "should return true" do @race.should have_team_competition end
    end
  end

  describe "relays" do
    before do
      @race = FactoryGirl.create(:race)
      @race.relays << FactoryGirl.build(:relay, :race => @race, :name => 'C')
      @race.relays << FactoryGirl.build(:relay, :race => @race, :name => 'A')
      @race.relays << FactoryGirl.build(:relay, :race => @race, :name => 'B')
      @race.reload
    end

    it "should be ordered by name" do
      @race.relays[0].name.should == 'A'
      @race.relays[1].name.should == 'B'
      @race.relays[2].name.should == 'C'
    end
  end

  describe "#has_any_national_records_defined?" do
    before do
      @race = FactoryGirl.create(:race)
    end

    it "should return false when no series exists" do
      @race.should_not have_any_national_records_defined
    end

    context "when series exist" do
      before do
        @race.series << FactoryGirl.build(:series, :race => @race)
        @race.series << FactoryGirl.build(:series, :race => @race, :national_record => '')
      end

      it "should return false when no national records have been defined" do
        @race.should_not have_any_national_records_defined
      end

      it "should return true when at least one national record" do
        @race.series << FactoryGirl.build(:series, :race => @race, :national_record => 900)
        @race.should have_any_national_records_defined
      end
    end
  end

  describe "#race_day" do
    it "should return 0 if race ended in the past" do
      FactoryGirl.build(:race, :start_date => Date.today - 1).race_day.should == 0
      FactoryGirl.build(:race, :start_date => Date.today - 2).race_day.should == 0
    end

    it "should return 0 if race starts in the future" do
      FactoryGirl.build(:race, :start_date => Date.today + 1).race_day.should == 0
      FactoryGirl.build(:race, :start_date => Date.today + 2).race_day.should == 0
    end

    context "when race is today" do
      it "should return 1 if race started today" do
        FactoryGirl.build(:race, :start_date => Date.today).race_day.should == 1
      end

      it "should return 2 if race started yesterday" do
        FactoryGirl.build(:race, :start_date => Date.today - 1, :end_date => Date.today + 1).
          race_day.should == 2
      end

      it "should return 3 if race started two days ago" do
        FactoryGirl.build(:race, :start_date => Date.today - 2, :end_date => Date.today).
          race_day.should == 3
      end
    end
  end

  describe "#next_start_number" do
    before do
      @race = FactoryGirl.create(:race)
      @series = FactoryGirl.build(:series, :race => @race)
      @race.series << @series
    end

    it "should return 1 when no competitors" do
      @race.next_start_number.should == 1
    end

    it "should return 1 when competitors without numbers" do
      @series.competitors << FactoryGirl.build(:competitor, :series => @series, :number => nil)
      @race.next_start_number.should == 1
    end

    it "should return the biggest competitor number + 1 when competitors with numbers" do
      @series.competitors << FactoryGirl.build(:competitor, :series => @series, :number => 2)
      @series.competitors << FactoryGirl.build(:competitor, :series => @series, :number => 8)
      @race.next_start_number.should == 9
    end
  end

  describe "#next_start_time" do
    before do
      @race = FactoryGirl.create(:race, :start_interval_seconds => 40)
      @series = FactoryGirl.build(:series, :race => @race)
      @race.series << @series
    end

    it "should return nil when no competitors" do
      @race.next_start_time.should be_nil
    end

    it "should return nil when competitors without start times" do
      @series.competitors << FactoryGirl.build(:competitor, :series => @series)
      @race.next_start_time.should be_nil
    end

    context "when competitors with start times" do
      it "should return the biggest competitor start time + time interval" do
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '10:34:11')
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '18:06:20')
        @race.next_start_time.strftime('%H:%M:%S').should == '18:07:00'
      end

      it "should round up the suggested start time to full minutes" do
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '10:34:11')
        @series.competitors << FactoryGirl.build(:competitor, :series => @series,
          :start_time => '18:03:21')
        @race.next_start_time.strftime('%H:%M:%S').should == '18:05:00'
      end
    end
  end

  describe "#all_competitions_finished?" do
    before do
      @race = FactoryGirl.build(:race)
    end

    it "should return false when race is not finished" do
      @race.all_competitions_finished?.should be_false
    end

    context "when race is finished" do
      before do
        @race.finished = true
        @finished_relay = mock_model(Relay, :finished => true)
        @unfinished_relay = mock_model(Relay, :finished => false)
      end

      it "should return false when at least one relay is not finished" do
        @race.stub!(:relays).and_return([@finished_relay, @unfinished_relay])
        @race.all_competitions_finished?.should be_false
      end

      it "should return true when all relays are finished" do
        @race.stub!(:relays).and_return([@finished_relay, @finished_relay])
        @race.all_competitions_finished?.should be_true
      end
    end
  end
  
  describe "#has_team_competitions_with_team_names" do
    context "when no team competitions" do
      it "should return false" do
        Race.new.should_not have_team_competitions_with_team_names
      end
    end
    
    context "when team competitions but none of them uses team name" do
      it "should return false" do
        race = FactoryGirl.create(:race)
        race.team_competitions << FactoryGirl.build(:team_competition, :race => race, :use_team_name => false)
        race.should_not have_team_competitions_with_team_names
      end
    end
    
    context "when at least one team competition uses team name" do
      it "should return true" do
        race = FactoryGirl.create(:race)
        race.team_competitions << FactoryGirl.build(:team_competition, :race => race, :use_team_name => true)
        race.should have_team_competitions_with_team_names
      end
    end
  end

  describe "#start_time_defined?" do
    it "should be false when nil" do
      Race.new.start_time_defined?.should be_false
    end

    it "should be false when start time is 00:00" do
      FactoryGirl.build(:race, start_time: '00:00').start_time_defined?.should be_false
    end

    it "should be true when start time other than 00:00" do
      FactoryGirl.build(:race, start_time: '00:01').start_time_defined?.should be_true
    end
  end
end
