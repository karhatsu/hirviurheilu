require 'spec_helper'

describe TeamCompetition do
  it "create" do
    create(:team_competition)
  end

  describe "associations" do
    it { is_expected.to belong_to(:race) }
    it { is_expected.to have_and_belong_to_many(:series) }
    it { is_expected.to have_and_belong_to_many(:age_groups) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

    describe "team_competitor_count" do
      it { is_expected.to validate_numericality_of(:team_competitor_count) }
      it { is_expected.not_to allow_value(nil).for(:team_competitor_count) }
      it { is_expected.not_to allow_value(0).for(:team_competitor_count) }
      it { is_expected.not_to allow_value(1).for(:team_competitor_count) }
      it { is_expected.to allow_value(2).for(:team_competitor_count) }
      it { is_expected.not_to allow_value(2.1).for(:team_competitor_count) }
    end
  end

  describe "#results_for_competitors" do
    before do
      @tc = build(:team_competition, :team_competitor_count => 2)
    end

    context "when the race is not finished" do
      it "should return array with results even if none of the clubs have enough competitors" do
        @club = instance_double(Club)
        @race = instance_double(Race)
        @c = instance_double(Competitor, :points => 1100, :club => @club,
          :shot_points => 300, :time_in_seconds => 500, :unofficial => false,
                        :race => @race)
        expect(Competitor).to receive(:sort_competitors).with([@c], false).and_return([@c])
        allow(@race).to receive(:finished?).and_return(false)
        allow(@tc).to receive(:race).and_return(@race)
        @tc.results_for_competitors([@c])[0] == 1100
      end
    end

    context "when the race is finished" do
      it "should return empty array if none of the clubs have enough competitors" do
        @club = instance_double(Club)
        @race = instance_double(Race)
        @c = instance_double(Competitor, :points => 1100, :club => @club,
          :shot_points => 300, :time_in_seconds => 500, :unofficial => false,
                        :race => @race)
        expect(Competitor).to receive(:sort_competitors).with([@c], false).and_return([@c])
        allow(@race).to receive(:finished?).and_return(true)
        allow(@tc).to receive(:race).and_return(@race)
        expect(@tc.results_for_competitors([@c])).to eq([])
      end
    end

    context "when the clubs have enough competitors" do
      before do
        @race = instance_double(Race)
        @club_best_total_points = instance_double(Club, :name => 'Club 1')
        @club_best_single_points = instance_double(Club, :name => 'Club 2')
        @club_best_single_shots = instance_double(Club, :name => 'Club 3')
        @club_best_single_time = instance_double(Club, :name => 'Club 4')
        @club_worst = instance_double(Club, :name => 'Club 5')
        @club_small = instance_double(Club, :name => 'Club small')
        @club_unofficial = instance_double(Club, :name => 'Club unofficial')

        @club_best_total_points_c1 = create_competitor(@club_best_total_points, 1100,
          :time_in_seconds => nil)
        @club_best_total_points_c2 = create_competitor(@club_best_total_points, 1000)
        @club_best_total_points_c_excl = create_competitor(@club_best_total_points, 999)
        @club_best_single_points_c1 = create_competitor(@club_best_single_points, 1050)
        @club_best_single_points_c2 = create_competitor(@club_best_single_points, 800)
        @club_best_single_shots_c1 = create_competitor(@club_best_single_shots, 1049)
        @club_best_single_shots_c2 = create_competitor(@club_best_single_shots, 801,
          :shot_points => 201)
        @club_best_single_time_c1 = create_competitor(@club_best_single_time, 1049)
        @club_best_single_time_c2 = create_competitor(@club_best_single_time, 801,
          :time_in_seconds => 999)
        @club_worst_c1 = create_competitor(@club_worst, 1049)
        @club_worst_c2 = create_competitor(@club_worst, 801)

        @club_small_c = create_competitor(@club_small, 1200)
        @club_small_nil_points = create_competitor(@club_small, nil)
        @club_unofficial1 = create_competitor(@club_unofficial, 1200, :unofficial => true)
        @club_unofficial2 = create_competitor(@club_unofficial, 1200, :unofficial => true)

        @competitors =
          [@club_small_c, @club_best_total_points_c1, @club_best_single_points_c1,
            @club_best_single_shots_c1, @club_best_single_time_c1,
            @club_worst_c1,
            @club_best_total_points_c2, @club_best_total_points_c_excl,
            @club_best_single_shots_c2,
            @club_best_single_time_c2, @club_worst_c2,
            @club_best_single_points_c2,
            @club_unofficial1, @club_unofficial2, @club_small_nil_points]
        allow(@tc).to receive(:race).and_return(@race)
        allow(@race).to receive(:finished?).and_return(true)
        expect(Competitor).to receive(:sort_competitors).with(@competitors, false).and_return(@competitors)
      end

      describe "should return an array of hashes" do
        before do
          @results = @tc.results_for_competitors(@competitors)
        end
        
        context "when race is finished" do
          it "including only the clubs with enough official competitors with complete points " +
              "so that the clubs are ordered: 1. total points " +
              "2. best individual points 3. best individual shot points " +
              "4. fastest individual time" do
            expect(@results.length).to eq(5)
            expect(@results[0][:club]).to eq(@club_best_total_points)
            expect(@results[1][:club]).to eq(@club_best_single_points)
            expect(@results[2][:club]).to eq(@club_best_single_shots)
            expect(@results[3][:club]).to eq(@club_best_single_time)
            expect(@results[4][:club]).to eq(@club_worst)
          end
        end

        context "when race is not finished" do
          it "including all the clubs, even with not enough official competitors with complete points " +
              "so that the clubs are ordered: 1. total points " +
              "2. best individual points 3. best individual shot points " +
              "4. fastest individual time" do
            allow(@tc).to receive(:race).and_return(@race)
            allow(@race).to receive(:finished?).and_return(false)
            expect(Competitor).to receive(:sort_competitors).with(@competitors, false).and_return(@competitors)
            @results = @tc.results_for_competitors(@competitors)
            expect(@results.length).to eq(6)
            expect(@results[0][:club]).to eq(@club_best_total_points)
            expect(@results[1][:club]).to eq(@club_best_single_points)
            expect(@results[2][:club]).to eq(@club_best_single_shots)
            expect(@results[3][:club]).to eq(@club_best_single_time)
            expect(@results[4][:club]).to eq(@club_worst)
          end
        end

        it "including total points" do
          expect(@results[0][:points]).to eq(1100 + 1000)
          expect(@results[1][:points]).to eq(1050 + 800)
          expect(@results[2][:points]).to eq(1049 + 801)
          expect(@results[3][:points]).to eq(1049 + 801)
          expect(@results[4][:points]).to eq(1049 + 801)
        end

        it "including ordered competitors inside of each team" do
          expect(@results[0][:competitors].length).to eq(2)
          expect(@results[0][:competitors][0]).to eq(@club_best_total_points_c1)
          expect(@results[0][:competitors][1]).to eq(@club_best_total_points_c2)
          expect(@results[1][:competitors].length).to eq(2)
          expect(@results[1][:competitors][0]).to eq(@club_best_single_points_c1)
          expect(@results[1][:competitors][1]).to eq(@club_best_single_points_c2)
        end
      end

      def create_competitor(club, points, options={})
        instance_double(Competitor, {:points => points, :club => club,
            :shot_points => 200, :time_in_seconds => 1000,
            :unofficial => false, :team_name => nil}.merge(options))
      end

      context "and team name is wanted to use" do
        before do
          @tc.use_team_name = true
        end
        
        context "but no team names defined" do
          it "should return no results" do
            expect(@tc.results_for_competitors(@competitors)).to eq([])
          end
        end
        
        context "and team names defined for some competitors" do
          before do
            allow(@club_best_total_points_c1).to receive(:team_name).and_return('Team best')
            allow(@club_best_total_points_c2).to receive(:team_name).and_return('Team best')
            allow(@club_best_single_points_c1).to receive(:team_name).and_return('Team second')
            allow(@club_best_single_points_c2).to receive(:team_name).and_return('Team second')
            allow(@club_best_single_shots_c1).to receive(:team_name).and_return('')
            allow(@club_best_single_shots_c2).to receive(:team_name).and_return('')
            @results = @tc.results_for_competitors(@competitors)
          end
          
          it "should return results for teams with those competitors" do
            expect(@results.length).to eq(2)
          end
          
          it "should sort teams correctly" do
            expect(@results[0][:club]).to eq('Team best')
            expect(@results[1][:club]).to eq('Team second')
          end
        end
      end
    end
  end

  describe "#results" do
    before do
      race = create(:race)
      @tc = create(:team_competition, :race => race)

      # competitors belong to series without age groups, series included in competition
      series1 = build(:series, :race => race)
      @tc.series << series1
      @s_c1 = create(:competitor, :series => series1)
      @s_c2 = create(:competitor, :series => series1)

      # competitors belong to (series and) age groups, series included in competition
      series4 = build(:series, :race => race)
      @tc.series << series4
      age_group4 = create(:age_group, :series => series4)
      @s_c3 = create(:competitor, :series => series4, :age_group => age_group4)
      age_group5 = create(:age_group, :series => series4)
      @s_c4 = create(:competitor, :series => series4, :age_group => age_group5)

      # both series and age group included in competition, competitor should be only once
      series4 = create(:series, :race => race)
      age_group3 = create(:age_group, :series => series4)
      @tc.series << series4
      @tc.age_groups << age_group3
      @s_ag_c = create(:competitor, :series => series4, :age_group => age_group3)

      # competitors belong to (series and) age group, age group included in competition
      series2 = create(:series, :race => race)
      age_group1 = build(:age_group, :series => series2)
      @tc.age_groups << age_group1
      @ag_c1 = create(:competitor, :series => series2, :age_group => age_group1)
      @ag_c2 = create(:competitor, :series => series2, :age_group => age_group1)
      # another similar
      series3 = create(:series, :race => race)
      age_group2 = build(:age_group, :series => series3)
      @tc.age_groups << age_group2
      @ag_c3 = create(:competitor, :series => series3, :age_group => age_group2)
      @ag_c4 = create(:competitor, :series => series3, :age_group => age_group2)

      @tc.reload
    end

    it "should call #results_for_competitors with all unique competitors from " +
      "series and age groups as parameters, and return the result" do
      expect(@tc).to receive(:results_for_competitors).
        with([@s_c1, @s_c2, @s_c3, @s_c4, @s_ag_c, @ag_c1, @ag_c2, @ag_c3, @ag_c4]).
        and_return("results")
      expect(@tc.results).to eq("results")
    end
  end

  describe "#series_names" do
    before do
      @tc = create(:team_competition)
    end

    it "should return empty string when no series attached" do
      expect(@tc.series_names).to eq('')
    end

    it "should return the names of the series separated with comma" do
      @tc.series << build(:series, :name => 'first series')
      @tc.series << build(:series, :name => 'second series')
      expect(@tc.series_names).to eq('first series,second series')
    end
  end

  describe "#attach_series_by_names" do
    before do
      @race = create(:race)
      @tc = create(:team_competition, :race => @race)
      @series1 = create(:series, :race => @race, :name => 'first series')
      @series2 = create(:series, :race => @race, :name => 'second series')
    end

    it "should find the names from the race and attach the corresponding series" do
      @tc.attach_series_by_names('first series,second series')
      expect(@tc.series.size).to eq(2)
      expect(@tc.series[0].name).to eq('first series')
      expect(@tc.series[1].name).to eq('second series')
    end
  end

  describe "#age_groups_names" do
    before do
      @tc = create(:team_competition)
    end

    it "should return empty string when no age_groups attached" do
      expect(@tc.age_groups_names).to eq('')
    end

    it "should return the names of the age_groups separated with comma" do
      @tc.age_groups << build(:age_group, :name => 'first age_group')
      @tc.age_groups << build(:age_group, :name => 'second age_group')
      expect(@tc.age_groups_names).to eq('first age_group,second age_group')
    end
  end

  describe "#attach_age_groups_by_names" do
    before do
      @race = create(:race)
      @tc = create(:team_competition, :race => @race)
      series = create(:series, :race => @race)
      @age_groups1 = create(:age_group, :series => series,
        :name => 'first age_group')
      @age_groups2 = create(:age_group, :series => series,
        :name => 'second age_group')
    end

    it "should find the names from the race and attach the corresponding age_groups" do
      @tc.attach_age_groups_by_names('first age_group,second age_group')
      expect(@tc.age_groups.size).to eq(2)
      expect(@tc.age_groups[0].name).to eq('first age_group')
      expect(@tc.age_groups[1].name).to eq('second age_group')
    end
  end
  
  describe  "#started?" do
    context "when no series" do
      it "should return false" do
        expect(TeamCompetition.new).not_to be_started
      end
    end
    
    context "when series" do
      before do
        @tc = build(:team_competition)
      end
      
      context "but none of them started" do
        it "should return false" do
          s1 = instance_double(Series)
          expect(@tc).to receive(:series).and_return([s1])
          allow(s1).to receive(:started?).and_return(false)
          expect(@tc).not_to be_started
        end
      end
      
      context "and at least one of them started" do
        it "should return true" do
          s1 = instance_double(Series)
          s2 = instance_double(Series)
          expect(@tc).to receive(:series).and_return([s1, s2])
          allow(s1).to receive(:started?).and_return(false)
          allow(s2).to receive(:started?).and_return(true)
          expect(@tc).to be_started
        end
      end
    end
  end
end
