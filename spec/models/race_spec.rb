require 'spec_helper'

describe Race do
  describe "create" do
    it "should create race with valid attrs" do
      create(:race)
    end
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:start_date) }

    describe "end_date" do
      it "can be nil which makes it same as start date" do
        race = create(:race, :end_date => nil)
        expect(race.end_date).to eq(race.start_date)
      end

      it "cannot be before start date" do
        expect(build(:race, :start_date => Date.today + 3, :end_date => Date.today + 2)).
          to have(1).errors_on(:end_date)
      end
    end

    describe "start_interval_seconds" do
      it_should_behave_like 'non-negative integer', :start_interval_seconds, false

      context 'when shooting race' do
        it 'allows nil for start_interval_seconds' do
          race = build :race, sport_key: Sport::ILMAHIRVI, start_interval_seconds: nil
          expect(race).to have(0).errors_on(:start_interval_seconds)
        end
      end
    end

    describe "heat_interval_seconds" do
      it { is_expected.to validate_numericality_of(:heat_interval_seconds) }
      it { is_expected.not_to allow_value(nil).for(:heat_interval_seconds) }
      it { is_expected.not_to allow_value(23.5).for(:heat_interval_seconds) }
      it { is_expected.not_to allow_value(0).for(:heat_interval_seconds) }
    end

    describe "heat_size" do
      it { is_expected.to validate_numericality_of(:heat_size) }
      it { is_expected.not_to allow_value(nil).for(:heat_size) }
      it { is_expected.not_to allow_value(23.5).for(:heat_size) }
      it { is_expected.not_to allow_value(-1).for(:heat_size) }
      it { is_expected.to allow_value(0).for(:heat_size) }
    end

    describe "club_level" do
      it { is_expected.to allow_value(Race::CLUB_LEVEL_SEURA).for(:club_level) }
      it { is_expected.to allow_value(Race::CLUB_LEVEL_PIIRI).for(:club_level) }
      it { is_expected.not_to allow_value(2).for(:club_level) }

      it "should convert nil to SEURA" do
        race = create(:race, :club_level => nil)
        expect(race.club_level).to eq(Race::CLUB_LEVEL_SEURA)
      end
    end

    describe "start_order" do
      it { is_expected.not_to allow_value(Race::START_ORDER_BY_SERIES - 1).for(:start_order) }
      it { is_expected.to allow_value(Race::START_ORDER_BY_SERIES).for(:start_order) }
      it { is_expected.to allow_value(Race::START_ORDER_MIXED).for(:start_order) }
      it { is_expected.not_to allow_value(Race::START_ORDER_MIXED + 1).for(:start_order) }
    end

    describe 'shooting_place_count' do
      it_should_behave_like 'positive integer', :shooting_place_count, true
    end

    describe 'level' do
      it { is_expected.not_to allow_value('').for(:level) }
      it { is_expected.not_to allow_value(Race::LEVEL_OTHER - 1).for(:level) }
      it { is_expected.to allow_value(Race::LEVEL_OTHER).for(:level) }
      it { is_expected.to allow_value(Race::LEVEL_DISTRICT).for(:level) }
      it { is_expected.to allow_value(Race::LEVEL_AREA).for(:level) }
      it { is_expected.to allow_value(Race::LEVEL_NATIONAL).for(:level) }
      it { is_expected.to allow_value(Race::LEVEL_INTERNATIONAL).for(:level) }
      it { is_expected.not_to allow_value(Race::LEVEL_INTERNATIONAL + 1).for(:level) }
    end

    describe 'pending_official_email' do
      it { is_expected.to allow_value('valid@email.com').for(:pending_official_email)}
      it { is_expected.not_to allow_value('invalid.email').for(:pending_official_email)}
      it { is_expected.to allow_value(nil).for(:pending_official_email)}
    end

    describe "race with same name" do
      before do
        @race = create :race, name: 'My race', start_date: '2010-01-01', location: 'My town', sport_key: Sport::SKI
      end

      it "should allow if same location and sport but different start date" do
        expect(build(:race, name: 'My race', start_date: '2011-01-01', location: 'My town', sport_key: Sport::SKI)).to be_valid
      end

      it "should allow if same start date and sport but different location" do
        expect(build(:race, name: 'My race', start_date: '2010-01-01', location: 'Different town', sport_key: Sport::SKI)).to be_valid
      end

      it "should allow if same start date and location but different sport" do
        expect(build(:race, name: 'My race', start_date: '2010-01-01', location: 'My town', sport_key: Sport::ILMAHIRVI)).to be_valid
      end

      it "should allow updating the existing race" do
        expect(@race).to be_valid
      end

      it "should prevent if same location, start date and sport" do
        expect(build(:race, name: 'My race', start_date: '2010-01-01', location: 'My town', sport_key: Sport::SKI)).not_to be_valid
      end
    end

    it_should_behave_like 'positive integer', :track_count, true
  end

  describe "associations" do
    it { is_expected.to belong_to(:district) }
    it { is_expected.to have_many(:series) }
    it { is_expected.to have_many(:age_groups).through(:series) }
    it { is_expected.to have_many(:competitors).through(:series) }
    it { is_expected.to have_many(:clubs) }
    it { is_expected.to have_many(:correct_estimates) }
    it { is_expected.to have_many(:relays) }
    it { is_expected.to have_many(:team_competitions) }
    it { is_expected.to have_many(:race_rights) }
    it { is_expected.to have_many(:users).through(:race_rights) }
    it { is_expected.to have_and_belong_to_many(:cups) }
  end

  describe "default" do
    it "start time should be 00:00:00" do
      expect(Race.new.start_time.strftime('%H:%M:%S')).to eq('00:00:00')
    end
  end

  describe 'create' do
    it 'generates a random api secret' do
      api_secret1 = create(:race).api_secret
      api_secret2 = create(:race).api_secret
      expect(api_secret1).to be_truthy
      expect(api_secret2).to be_truthy
      expect(api_secret1).not_to eql api_secret2
    end

    it 'does not override already given api secret' do
      expect(create(:race, api_secret: 'very-secret').api_secret).to eql 'very-secret'
    end
  end

  describe "update" do
    context "when start order changed from mixed to by series" do
      before do
        @race = create(:race, :start_order => Race::START_ORDER_MIXED)
        @series = create(:series, :race => @race)
        create(:competitor, :series => @series, :start_time => '01:00:00', :number => 4)
        @race.reload
      end

      it "should be valid" do
        @race.start_order = Race::START_ORDER_BY_SERIES
        expect(@race).to be_valid
      end

      it "should not modify series anyhow" do
        @race.start_order = Race::START_ORDER_BY_SERIES
        @race.series.each { |s| expect(s).not_to receive(:save!) }
        @race.save!
      end
    end

    context "when start order changed from by series to mixed" do
      before do
        @race = create(:race, :start_order => Race::START_ORDER_BY_SERIES)
        @series1 = create(:series, :race => @race, :has_start_list => false)
        @series2 = create(:series, :race => @race, :has_start_list => true)
        @series3 = create(:series, :race => @race, :has_start_list => false)
      end

      context "when at least one competitor without start time" do
        it "should not be allowed" do
          create(:competitor, :series => @series1, :number => 55)
          @race.reload
          @race.start_order = Race::START_ORDER_MIXED
          expect(@race).not_to be_valid
        end
      end

      context "when only competitors with start time and number" do
        it "should be allowed" do
          create(:competitor, :series => @series1, :start_time => '02:00:00', :number => 2)
          @race.reload
          @race.start_order = Race::START_ORDER_MIXED
          expect(@race).to be_valid
        end

        it "should set that all series have start list" do
          @race.reload
          @race.start_order = Race::START_ORDER_MIXED
          @race.save!
          @race.series.each do |s|
            expect(s).to have_start_list
          end
        end
      end
    end

    context "when start order remains as mixed" do
      before do
        @race = create(:race, :start_order => Race::START_ORDER_MIXED)
        @series = create(:series, :race => @race)
        @race.reload
      end

      it "should not modify series anyhow" do
        @race.days_count = 2
        @race.series.each { |s| expect(s).not_to receive(:save!) }
        @race.save!
      end
    end

    context "when start order remains as by series" do
      before do
        @race = create(:race, :start_order => Race::START_ORDER_BY_SERIES)
        @series = create(:series, :race => @race)
        @race.reload
      end

      it "should not modify series anyhow" do
        @race.days_count = 2
        @race.series.each { |s| expect(s).not_to receive(:save!) }
        @race.save!
      end
    end
  end

  describe '.cache_key_for_all' do
    context 'when no races' do
      it 'is races/all-' do
        expect(Race.cache_key_for_all).to eq("races/all-")
      end
    end

    context 'when races' do
      before do
        @race1 = create :race
        create :race
        @race1.update_attribute :name, 'New name'
      end

      it 'contains timestamp of the latest updated race' do
        timestamp = @race1.updated_at.utc.to_formatted_s(:nsec)
        expect(Race.cache_key_for_all).to eq("races/all-#{timestamp}")
      end
    end
  end

  describe '#cache_key_for_all_series' do
    context 'when no series' do
      it 'is races/<id>-<timestamp>-allseries-' do
        race = create :race
        timestamp = race.updated_at.utc.to_formatted_s(:nsec)
        expect(race.cache_key_for_all_series).to eq("races/#{race.id}-#{timestamp}-allseries-")
      end
    end

    context 'when series' do
      before do
        @race = create :race
        @series1 = create :series, race: @race
        create :series, race: @race
        @series1.name = 'new name'
        @series1.save!
      end

      it 'contains timestamp of the latest updated series' do
        race_timestamp = @race.updated_at.utc.to_formatted_s(:nsec)
        series_timestamp = @series1.updated_at.utc.to_formatted_s(:nsec)
        expect(@race.cache_key_for_all_series).to eq("races/#{@race.id}-#{race_timestamp}-allseries-#{series_timestamp}")
      end
    end
  end

  describe "yesterday/past/todayfuture" do
    before do
      @yesterday1 = create :race, start_date: Date.today - 1, end_date: nil, name: 'Yesterday 1'
      @yesterday2 = create :race, start_date: Date.today - 2, end_date: Date.today - 1, name: 'Yesterday 2'
      @past1 = create :race, start_date: Date.today - 10, end_date: nil, name: 'Past B'
      @past2 = create :race, start_date: Date.today - 3, end_date: Date.today - 2, name: 'Past oldest'
      @past3 = create :race, start_date: Date.today - 10, end_date: nil, name: 'Past A'
      @current1 = create :race, start_date: Date.today - 1, end_date: Date.today + 0, name: 'C1'
      @current2 = create :race, start_date: Date.today, end_date: nil, name: 'C2'
      @current3 = create :race, start_date: Date.today, end_date: Date.today + 1, name: 'C3'
      @current4 = create :race, start_date: Date.today - 1, end_date: Date.today + 1, name: 'C4'
      @future1 = create :race, start_date: Date.today + 2, end_date: Date.today + 3, name: 'Future B'
      @future2 = create :race, start_date: Date.today + 1, end_date: nil, name: 'Future first'
      @future3 = create :race, start_date: Date.today + 2, end_date: Date.today + 3, name: 'Future A'
    end

    it "#yesterday should return races that finished yesterday" do
      expect(Race.yesterday.map(&:name)).to eq([@yesterday1, @yesterday2].map(&:name))
    end

    it "#past should return past races except yesterday" do
      expect(Race.past.map(&:name)).to eq([@past2, @past3, @past1].map(&:name))
    end

    it "#today should return races starting or ending today and ongoing multi-day races" do
      expect(Race.today.map(&:name)).to eq([@current1, @current4, @current2, @current3].map(&:name))
    end

    it "#future should return future races" do
      expect(Race.future.map(&:name)).to eq([@future2, @future3, @future1].map(&:name))
    end

    describe "no date caching" do
      before do
        @zone = double(Object)
        allow(Time).to receive(:zone).and_return(@zone)
      end

      it "past" do
        allow(@zone).to receive(:today).and_return(Date.today)
        expect(Race.past).not_to be_empty
        allow(@zone).to receive(:today).and_return(Date.today - 10)
        expect(Race.past).to be_empty
      end

      it "future" do
        allow(@zone).to receive(:today).and_return(Date.today)
        expect(Race.future).not_to be_empty
        allow(@zone).to receive(:today).and_return(Date.today + 10)
        expect(Race.future).to be_empty
      end
    end
  end

  describe '#race' do
    it 'should be self' do
      race = Race.new
      expect(race.race).to eq(race)
    end
  end

  describe '#start_datetime' do
    it 'returns date and start time as combined' do
      race = build :race, start_date: '2020-01-19', start_time: '08:30'
      expect(race.start_datetime.strftime('%d.%m.%Y %H:%M')).to eql '19.01.2020 08:30'
    end
  end

  describe "#can_destroy?" do
    before do
      @race = create(:race)
    end

    it "should be false when competitors" do
      series = build(:series, :race => @race)
      @race.series << series
      series.competitors << build(:competitor)
      expect(@race.can_destroy?).to be_falsey
    end

    it "should be false when relays" do
      @race.relays << build(:relay, :race => @race)
      expect(@race.can_destroy?).to be_falsey
    end

    it "should be true when no competitors, nor relays" do
      @series = build(:series, :race => @race)
      @race.series << @series
      expect(@race.can_destroy?).to be_truthy
    end
  end

  describe "#destroy" do
    before do
      @race = create(:race)
      @series = build(:series, :race => @race)
      @race.series << @series
      @competitor = build(:competitor, :series => @series)
      @series.competitors << @competitor
      @team_competition = build(:team_competition, :race => @race)
      @race.team_competitions << @team_competition
      @relay = build(:relay, :race => @race)
      @race.relays << @relay
      @relay_team = build(:relay_team, :relay => @relay)
      @relay.relay_teams << @relay_team
      @relay_competitor = build(:relay_competitor, :relay_team => @relay_team)
      @relay_team.relay_competitors << @relay_competitor
    end

    it "should destroy race and all its children" do
      @race.reload
      @race.destroy
      expect(@race).to be_destroyed
      expect(Series.exists?(@series.id)).to be_falsey
      expect(Competitor.exists?(@competitor.id)).to be_falsey
      expect(TeamCompetition.exists?(@team_competition.id)).to be_falsey
      expect(Relay.exists?(@relay.id)).to be_falsey
      expect(RelayTeam.exists?(@relay_team.id)).to be_falsey
      expect(RelayCompetitor.exists?(@relay_competitor.id)).to be_falsey
    end
  end

  describe "#add_default_series" do
    let(:sport_key) { Sport::SKI }
    let(:ds1) { DefaultSeries.new('M70', ['M75', 'M80']) }
    let(:ds2) { DefaultSeries.new('S17') }
    let(:race) { build :race, sport_key: sport_key }

    before do
      allow(DefaultSeries).to receive(:all).with(race.sport).and_return([ds1, ds2])
    end

    it "should add default series and age groups for the race" do
      race.add_default_series
      expect(race.series.size).to eq(2)
      s1 = race.series.first
      expect(s1.name).to eq('M70')
      expect(s1.age_groups.size).to eq(2)
      ag1 = s1.age_groups.first
      expect(ag1.name).to eq('M75')
      expect(ag1.min_competitors).to eq(2)
      ag2 = s1.age_groups.last
      expect(ag2.name).to eq('M80')
      expect(ag2.min_competitors).to eq(2)
      s2 = race.series.last
      expect(s2.name).to eq('S17')
      expect(s2.age_groups.size).to eq(0)
    end
  end

  describe "DEFAULT_START_INTERVAL" do
    specify { expect(Race::DEFAULT_START_INTERVAL).to eq(60) }
  end

  describe "DEFAULT_HEAT_INTERVAL" do
    specify { expect(Race::DEFAULT_HEAT_INTERVAL).to eq(180) }
  end

  describe "#days_count" do
    before do
      @race = build(:race, :start_date => '2010-12-20')
    end

    context "when only start date defined" do
      it "should return 1" do
        @race.end_date = nil
        expect(@race.days_count).to eq(1)
      end
    end

    context "when end date same as start date" do
      it "should return 1" do
        @race.end_date = '2010-12-20'
        expect(@race.days_count).to eq(1)
      end
    end

    context "when end date two days after start date" do
      it "should return 3" do
        @race.end_date = '2010-12-22'
        expect(@race.days_count).to eq(3)
      end
    end
  end

  describe "#days_count=" do
    before do
      @race = build(:race, :start_date => nil, :end_date => nil)
    end

    describe "invalid value" do
      it "should raise error when 0 given" do
        expect { @race.days_count = 0 }.to raise_error(RuntimeError)
      end

      it "should raise error when negative number given" do
        expect { @race.days_count = -1 }.to raise_error(RuntimeError)
      end

      it "should raise error when nil given" do
        expect { @race.days_count = nil }.to raise_error(RuntimeError)
      end
    end

    context "when start date" do
      it "should set end date to same as start date when 1 given" do
        @race.start_date = '2011-12-17'
        @race.days_count = 1
        expect(@race.end_date).to eq(@race.start_date)
      end

      it "should set end date to one bigger than start date when 2 given" do
        @race.start_date = '2011-12-17'
        @race.days_count = 2
        expect(@race.end_date).to eq(@race.start_date + 1)
      end
    end

    context "when no start date" do
      it "should store days_count for future usage" do
        @race.days_count = 2
        expect(@race.end_date).to be_nil
        @race.start_date = '2011-12-15'
        expect(@race.end_date).to eq(@race.start_date + 1)
      end

      it "should not be used after end date is set" do
        @race.days_count = 2
        end_date = '2011-12-17'
        @race.start_date = '2011-12-15'
        @race.end_date = end_date
        @race.start_date = '2011-12-10'
        expect(@race.end_date.strftime('%Y-%m-%d')).to eq(end_date)
      end
    end

    context "when start date set twice" do
      it "should change end date in both times" do
        @race.days_count = 3
        @race.start_date = '2012-01-05'
        expect(@race.end_date).to eq(@race.start_date + 2)
        @race.start_date = '2012-01-10'
        expect(@race.end_date).to eq(@race.start_date + 2)
      end
    end

    it "should accept also string number" do
        @race.start_date = '2011-12-17'
        @race.days_count = "2"
        expect(@race.end_date).to eq(@race.start_date + 1)
    end
  end

  describe "#set_correct_estimates_for_competitors" do
    before do
      @race = create(:race)
      @series2 = create(:series, race: @race)
      @series4 = create(:series, race: @race, points_method: Series::POINTS_METHOD_NO_TIME_4_ESTIMATES)
      @s2_updated_at = @series2.updated_at.to_s
      @s4_updated_at = @series4.updated_at.to_s
      create(:correct_estimate, min_number: 1, max_number: 5, distance1: 100, distance2: 200, distance3: 80, distance4: 90, race: @race)
      create(:correct_estimate, min_number: 10, max_number: nil, distance1: 50, distance2: 150, race: @race)
      @c1 = create(:competitor, series: @series2, number: 1, correct_estimate1: 1, correct_estimate2: 2)
      @c4 = create(:competitor, series: @series4, number: 4)
      @c5 = create(:competitor, series: @series2, number: 5)
      @c6 = create(:competitor, series: @series2, number: 6, correct_estimate1: 10, correct_estimate2: 20, correct_estimate3: 100, correct_estimate4: 200)
      @c9 = create(:competitor, series: @series4, number: 9, correct_estimate1: 30, correct_estimate2: 40, correct_estimate3: 100, correct_estimate4: 200)
      @c10 = create(:competitor, series: @series4, number: 10)
      @c150 = create(:competitor, series: @series2, number: 150)
      @cnil = create(:competitor, series: @series2, number: nil, correct_estimate1: 50, correct_estimate2: 60)
      @race.reload
      sleep 1 # because of the cache touch test
      @race.set_correct_estimates_for_competitors
      [@c1, @c4, @c5, @c6, @c9, @c10, @c150, @cnil].each {|r| r.reload }
    end

    it "should copy correct estimates for those numbers that match" do
      expect_correct_estimate @c1, 100, 200
      expect_correct_estimate @c4, 100, 200, 80, 90
      expect_correct_estimate @c5, 100, 200
      expect_correct_estimate @c10, 50, 150
      expect_correct_estimate @c150, 50, 150
      expect_correct_estimate @cnil, 50, 60
    end

    it "should reset such competitors' correct estimates whose numbers don't match" do
      expect_no_correct_estimates @c6
      expect_no_correct_estimates @c9
    end

    it "should reset those competitors' correct estimates 3 and 4 who need to have only 2" do
      expect_no_correct_estimates_3_and_4 @c1
      expect_no_correct_estimates_3_and_4 @c5
      expect_no_correct_estimates_3_and_4 @c10
      expect_no_correct_estimates_3_and_4 @c150
      expect_no_correct_estimates_3_and_4 @cnil
    end

    it 'should update cache for all series' do
      expect(@series2.reload.updated_at.to_s).not_to eq @s2_updated_at
      expect(@series4.reload.updated_at.to_s).not_to eq @s4_updated_at
    end

    def expect_correct_estimate(competitor, ce1, ce2, ce3=nil, ce4=nil)
      expect(competitor.correct_estimate1).to eq(ce1)
      expect(competitor.correct_estimate2).to eq(ce2)
      expect(competitor.correct_estimate3).to eq(ce3) if ce3
      expect(competitor.correct_estimate4).to eq(ce4) if ce4
    end

    def expect_no_correct_estimates(competitor)
      expect(competitor.correct_estimate1).to be_nil
      expect(competitor.correct_estimate2).to be_nil
      expect(competitor.correct_estimate3).to be_nil
      expect(competitor.correct_estimate4).to be_nil
    end

    def expect_no_correct_estimates_3_and_4(competitor)
      expect(competitor.correct_estimate3).to be_nil
      expect(competitor.correct_estimate4).to be_nil
    end
  end

  describe "#each_competitor_has_correct_estimates?" do
    before do
      @race = create(:race)
      series1 = create(:series, :race => @race)
      series2 = create(:series, :race => @race)
      @c1 = create(:competitor, :series => series1,
        :correct_estimate1 => 55, :correct_estimate2 => 111)
      @c2 = create(:competitor, :series => series2,
        :correct_estimate1 => 100, :correct_estimate2 => 99)
      @c3 = create(:competitor, :series => series1,
        :correct_estimate1 => 123, :correct_estimate2 => 100)
      @c4 = create(:competitor, :series => series2,
        :correct_estimate1 => 77, :correct_estimate2 => 88)
    end

    it "should return true when correct estimates exists for all competitors" do
      @race.reload
      expect(@race.each_competitor_has_correct_estimates?).to be_truthy
    end

    it "should return false when at least one competitor is missing correct estimates" do
      @c3.correct_estimate2 = nil
      @c3.save!
      @race.reload
      expect(@race.each_competitor_has_correct_estimates?).to be_falsey
    end
  end

  describe "#estimates_at_most" do
    it "should return 2 when no series defined" do
      expect(build(:race).estimates_at_most).to eq(2)
    end

    it "should return 2 when all series have 2 estimates" do
      race = create(:race)
      race.series << build(:series, :race => race)
      expect(race.estimates_at_most).to eq(2)
    end

    it "should return 4 when at least one series has 4 estimates" do
      race = create(:race)
      race.series << build(:series, :race => race)
      race.series << build(:series, :race => race, points_method: Series::POINTS_METHOD_NO_TIME_4_ESTIMATES)
      expect(race.estimates_at_most).to eq(4)
    end
  end

  describe "#has_team_competition?" do
    before do
      @race = build(:race)
    end

    context "when team_competitions is empty" do
      it "should return false" do expect(@race).not_to have_team_competition end
    end

    context "when team_competitions is not empty" do
      before do
        @race.team_competitions << build(:team_competition, :race => @race)
      end
      it "should return true" do expect(@race).to have_team_competition end
    end
  end

  describe "relays" do
    before do
      @race = create(:race)
      @race.relays << build(:relay, :race => @race, :name => 'C')
      @race.relays << build(:relay, :race => @race, :name => 'A')
      @race.relays << build(:relay, :race => @race, :name => 'B')
      @race.reload
    end

    it "should be ordered by name" do
      expect(@race.relays[0].name).to eq('A')
      expect(@race.relays[1].name).to eq('B')
      expect(@race.relays[2].name).to eq('C')
    end
  end

  describe "#has_any_national_records_defined?" do
    before do
      @race = create(:race)
    end

    it "should return false when no series exists" do
      expect(@race).not_to have_any_national_records_defined
    end

    context "when series exist" do
      before do
        @race.series << build(:series, :race => @race)
        @race.series << build(:series, :race => @race, :national_record => '')
      end

      it "should return false when no national records have been defined" do
        expect(@race).not_to have_any_national_records_defined
      end

      it "should return true when at least one national record" do
        @race.series << build(:series, :race => @race, :national_record => 900)
        expect(@race).to have_any_national_records_defined
      end
    end
  end

  describe "#race_day" do
    it "should return 0 if race ended in the past" do
      expect(build(:race, :start_date => Date.today - 1).race_day).to eq(0)
      expect(build(:race, :start_date => Date.today - 2).race_day).to eq(0)
    end

    it "should return 0 if race starts in the future" do
      expect(build(:race, :start_date => Date.today + 1).race_day).to eq(0)
      expect(build(:race, :start_date => Date.today + 2).race_day).to eq(0)
    end

    context "when race is today" do
      it "should return 1 if race started today" do
        expect(build(:race, :start_date => Date.today).race_day).to eq(1)
      end

      it "should return 2 if race started yesterday" do
        expect(build(:race, :start_date => Date.today - 1, :end_date => Date.today + 1).
          race_day).to eq(2)
      end

      it "should return 3 if race started two days ago" do
        expect(build(:race, :start_date => Date.today - 2, :end_date => Date.today).
          race_day).to eq(3)
      end
    end
  end

  describe "#next_start_number" do
    before do
      @race = create(:race)
      @series = build(:series, :race => @race)
      @race.series << @series
    end

    it "should return 1 when no competitors" do
      expect(@race.next_start_number).to eq(1)
    end

    it "should return 1 when competitors without numbers" do
      @series.competitors << build(:competitor, :series => @series, :number => nil)
      expect(@race.next_start_number).to eq(1)
    end

    it "should return the biggest competitor number + 1 when competitors with numbers" do
      @series.competitors << build(:competitor, :series => @series, :number => 2)
      @series.competitors << build(:competitor, :series => @series, :number => 8)
      expect(@race.next_start_number).to eq(9)
    end
  end

  describe "#next_start_time" do
    before do
      @race = create(:race, :start_interval_seconds => 30)
      @series = build(:series, :race => @race)
      @race.series << @series
    end

    it "should return 00:00:00 when no competitors" do
      expect(@race.next_start_time).to eq('00:00:00')
    end

    it "should return 00:00:00 when competitors without start times" do
      @series.competitors << build(:competitor, :series => @series)
      expect(@race.next_start_time).to eq('00:00:00')
    end

    context "when competitors with start times" do
      it "should return the biggest competitor start time + time interval" do
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '00:34:11')
        @series.competitors << build(:competitor, :series => @series,
          :start_time => '04:03:00')
        expect(@race.next_start_time.strftime('%H:%M:%S')).to eq('04:03:30')
      end
    end

    context 'when start_interval_seconds not defined' do
      before do
        @race.update_attribute :start_interval_seconds, nil
      end

      it 'should return biggest competitor start time' do
        @series.competitors << build(:competitor, series: @series, start_time: '00:34:11')
        expect(@race.next_start_time.strftime('%H:%M:%S')).to eq('00:34:11')
      end
    end
  end

  describe "#all_competitions_finished?" do
    before do
      @race = build(:race)
    end

    it "should return false when race is not finished" do
      expect(@race.all_competitions_finished?).to be_falsey
    end

    context "when race is finished" do
      before do
        @race.finished = true
        @finished_relay = instance_double(Relay, :finished => true)
        @unfinished_relay = instance_double(Relay, :finished => false)
      end

      it "should return false when at least one relay is not finished" do
        allow(@race).to receive(:relays).and_return([@finished_relay, @unfinished_relay])
        expect(@race.all_competitions_finished?).to be_falsey
      end

      it "should return true when all relays are finished" do
        allow(@race).to receive(:relays).and_return([@finished_relay, @finished_relay])
        expect(@race.all_competitions_finished?).to be_truthy
      end
    end
  end

  describe "#has_team_competitions_with_team_names" do
    context "when no team competitions" do
      it "should return false" do
        expect(Race.new).not_to have_team_competitions_with_team_names
      end
    end

    context "when team competitions but none of them uses team name" do
      it "should return false" do
        race = create(:race)
        race.team_competitions << build(:team_competition, :race => race, :use_team_name => false)
        expect(race).not_to have_team_competitions_with_team_names
      end
    end

    context "when at least one team competition uses team name" do
      it "should return true" do
        race = create(:race)
        race.team_competitions << build(:team_competition, :race => race, :use_team_name => true)
        expect(race).to have_team_competitions_with_team_names
      end
    end
  end

  describe "#start_time_defined?" do
    it "should be false when nil" do
      expect(Race.new.start_time_defined?).to be_falsey
    end

    it "should be false when start time is 00:00" do
      expect(build(:race, start_time: '00:00').start_time_defined?).to be_falsey
    end

    it "should be true when start time other than 00:00" do
      expect(build(:race, start_time: '00:01').start_time_defined?).to be_truthy
    end
  end

  describe '#competitors_per_heat and #concurrent_heats' do
    context 'when shooting place count is 1' do
      let(:race) { build :race, shooting_place_count: 1, track_count: 3 }

      it 'concurrent_heats is 1' do
        expect(race.concurrent_heats).to eql 1
      end

      it 'competitors_per_heat is track count' do
        expect(race.competitors_per_heat).to eql 3
      end
    end

    context 'when shooting place count is not 1' do
      let(:race) { build :race, shooting_place_count: 2, track_count: 5 }

      it 'concurrent_heats is track count' do
        expect(race.concurrent_heats).to eql 5
      end

      it 'competitors_per_heat is shooting place count' do
        race = build :race, shooting_place_count: 2, track_count: 5
        expect(race.competitors_per_heat).to eql 2
      end
    end
  end
end
