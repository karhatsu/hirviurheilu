require 'spec_helper'

describe TeamCompetition do
  it "create" do
    Factory.create(:team_competition)
  end

  describe "associations" do
    it { should belong_to(:race) }
    it { should have_and_belong_to_many(:series) }
    it { should have_and_belong_to_many(:age_groups) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }

    describe "team_competitor_count" do
      it { should validate_numericality_of(:team_competitor_count) }
      it { should_not allow_value(nil).for(:team_competitor_count) }
      it { should_not allow_value(0).for(:team_competitor_count) }
      it { should_not allow_value(1).for(:team_competitor_count) }
      it { should allow_value(2).for(:team_competitor_count) }
      it { should_not allow_value(2.1).for(:team_competitor_count) }
    end
  end

  describe "#results_for_competitors" do
    before do
      @tc = Factory.build(:team_competition, :team_competitor_count => 2)
    end

    it "should return empty array if none of the clubs have enough competitors" do
      @club = mock_model(Club)
      @c = mock_model(Competitor, :points => 1100, :club => @club,
        :shot_points => 300, :time_in_seconds => 500, :unofficial => false)
      Competitor.should_receive(:sort).with([@c]).and_return([@c])
      @tc.results_for_competitors([@c]).should == []
    end

    context "when the clubs have enough competitors" do
      before do
        @club_best_total_points = mock_model(Club, :name => 'Club 1')
        @club_best_single_points = mock_model(Club, :name => 'Club 2')
        @club_best_single_shots = mock_model(Club, :name => 'Club 3')
        @club_best_single_time = mock_model(Club, :name => 'Club 4')
        @club_worst = mock_model(Club, :name => 'Club 5')
        @club_small = mock_model(Club, :name => 'Club small')
        @club_unofficial = mock_model(Club, :name => 'Club unofficial')

        @club_best_total_points_c1 = create_competitor(@club_best_total_points, 1100)
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

        competitors =
          [@club_small_c, @club_best_total_points_c1, @club_best_single_points_c1,
            @club_best_single_shots_c1, @club_best_single_time_c1,
            @club_worst_c1,
            @club_best_total_points_c2, @club_best_total_points_c_excl,
            @club_best_single_shots_c2,
            @club_best_single_time_c2, @club_worst_c2,
            @club_best_single_points_c2,
            @club_unofficial1, @club_unofficial2, @club_small_nil_points]
        Competitor.should_receive(:sort).with(competitors).and_return(competitors)
        @results = @tc.results_for_competitors(competitors)
      end

      describe "should return an array of hashes" do
        it "including only the clubs with enough official competitors with complete points " +
            "so that the clubs are ordered: 1. total points " +
            "2. best individual points 3. best individual shot points " +
            "4. fastest individual time" do
          @results.length.should == 5
          @results[0][:club].should == @club_best_total_points
          @results[1][:club].should == @club_best_single_points
          @results[2][:club].should == @club_best_single_shots
          @results[3][:club].should == @club_best_single_time
          @results[4][:club].should == @club_worst
        end

        it "including total points" do
          @results[0][:points].should == 1100 + 1000
          @results[1][:points].should == 1050 + 800
          @results[2][:points].should == 1049 + 801
          @results[3][:points].should == 1049 + 801
          @results[4][:points].should == 1049 + 801
        end

        it "including ordered competitors inside of each team" do
          @results[0][:competitors].length.should == 2
          @results[0][:competitors][0].should == @club_best_total_points_c1
          @results[0][:competitors][1].should == @club_best_total_points_c2
          @results[1][:competitors].length.should == 2
          @results[1][:competitors][0].should == @club_best_single_points_c1
          @results[1][:competitors][1].should == @club_best_single_points_c2
        end
      end

      def create_competitor(club, points, options={})
        mock_model(Competitor, {:points => points, :club => club,
            :shot_points => 200, :time_in_seconds => 1000,
            :unofficial => false}.merge(options))
      end
    end
  end

  describe "#results" do
    before do
      race = Factory.create(:race)
      @tc = Factory.create(:team_competition, :race => race)

      # competitors belong to series without age groups, series included in competition
      series1 = Factory.build(:series, :race => race)
      @tc.series << series1
      @s_c1 = Factory.create(:competitor, :series => series1)
      @s_c2 = Factory.create(:competitor, :series => series1)

      # competitors belong to (series and) age groups, series included in competition
      series4 = Factory.build(:series, :race => race)
      @tc.series << series4
      age_group4 = Factory.create(:age_group, :series => series4)
      @s_c3 = Factory.create(:competitor, :series => series4, :age_group => age_group4)
      age_group5 = Factory.create(:age_group, :series => series4)
      @s_c4 = Factory.create(:competitor, :series => series4, :age_group => age_group5)

      # both series and age group included in competition, competitor should be only once
      series4 = Factory.create(:series, :race => race)
      age_group3 = Factory.create(:age_group, :series => series4)
      @tc.series << series4
      @tc.age_groups << age_group3
      @s_ag_c = Factory.create(:competitor, :series => series4, :age_group => age_group3)

      # competitors belong to (series and) age group, age group included in competition
      series2 = Factory.create(:series, :race => race)
      age_group1 = Factory.build(:age_group, :series => series2)
      @tc.age_groups << age_group1
      @ag_c1 = Factory.create(:competitor, :series => series2, :age_group => age_group1)
      @ag_c2 = Factory.create(:competitor, :series => series2, :age_group => age_group1)
      # another similar
      series3 = Factory.create(:series, :race => race)
      age_group2 = Factory.build(:age_group, :series => series3)
      @tc.age_groups << age_group2
      @ag_c3 = Factory.create(:competitor, :series => series3, :age_group => age_group2)
      @ag_c4 = Factory.create(:competitor, :series => series3, :age_group => age_group2)

      @tc.reload
    end

    it "should call #results_for_competitors with all unique competitors from " +
      "series and age groups as parameters, and return the result" do
      @tc.should_receive(:results_for_competitors).
        with([@s_c1, @s_c2, @s_c3, @s_c4, @s_ag_c, @ag_c1, @ag_c2, @ag_c3, @ag_c4]).
        and_return("results")
      @tc.results.should == "results"
    end
  end
end
