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

    it_should_behave_like 'positive integer', :team_competitor_count, false
    it { is_expected.not_to allow_value(1).for(:team_competitor_count) }
    it { is_expected.to allow_value(2).for(:team_competitor_count) }

    it_should_behave_like 'positive integer', :national_record, true

    describe 'extra_shots' do
      it 'should accept nil for shots' do
        expect(build :team_competition, extra_shots: [{ "shots1" => nil, "shots2" => nil }]).to be_valid
      end

      it 'should accept empty array for shots' do
        expect(build :team_competition, extra_shots: [{ "shots1" => [], "shots2" => [] }]).to be_valid
      end

      it 'should accept array with zeros and ones for shots' do
        extra_shots = [{ "shots1" => [1, 0], "shots2" => [0, 1, 1] }, { "shots1" => [0], "shots2" => [1] }]
        expect(build :team_competition, extra_shots: extra_shots).to be_valid
      end

      it 'should not accept array with something else than zeros and ones for shots 1' do
        extra_shots = [{ "shots1" => [1], "shots2" => [0] }, { "shots1" => [11], "shots2" => [0] }]
        expect(build :team_competition, extra_shots: extra_shots).to have(1).errors_on(:extra_shots)
      end

      it 'should not accept array with something else than zeros and ones for shots 2' do
        extra_shots = [{ "shots1" => [1], "shots2" => [0] }, { "shots1" => [1], "shots2" => [1, 0, 2] }]
        expect(build :team_competition, extra_shots: extra_shots).to have(1).errors_on(:extra_shots)
      end
    end
  end

  describe '#cache_key' do
    let(:race) { create :race }
    let(:tc) { create :team_competition, race: race }
    let(:series1) { create :series, race: race }
    let(:series2) { create :series, race: race }

    it 'is a combination of team competition, race, and biggest series timestamp' do
      series2
      series1.update_attribute :name, 'new name'
      tc_ts = tc.updated_at.utc.to_s(:usec)
      race_ts = race.updated_at.utc.to_s(:usec)
      series_ts = series1.updated_at.utc.to_s(:usec)
      expect(tc.cache_key).to eq("team_competitions/#{tc.id}-#{tc_ts}-#{race_ts}-#{series_ts}")
    end
  end

  describe "#results_for_competitors" do
    let(:sport_key) { Sport::SKI }
    let(:race) { build :race, sport_key: sport_key }
    let(:sport) { race.sport }
    let(:tc) { build :team_competition, race: race, team_competitor_count: 2, multiple_teams: true }

    context 'when none of the clubs have enough competitors' do
      let(:club) { instance_double Club, display_name: 'Test club' }
      let(:club_id) { 5 }
      let(:competitor) { instance_double Competitor, club: club, shooting_score: 100, time_in_seconds: 500, unofficial: false, race: race, club_id: club_id }

      before do
        allow(competitor).to receive(:team_competition_points).with(sport, false).and_return(1100)
        allow(competitor).to receive(:unofficial?).and_return(false)
        expect(Competitor).to receive(:sort_team_competitors).with(sport, [competitor], false).and_return([competitor])
      end

      context "and the race is not finished" do
        before do
          allow(race).to receive(:finished?).and_return(false)
        end

        it "should return array with results" do
          expect(tc.results_for_competitors([competitor])[0].best_competitor_score).to eql 1100
        end
      end

      context "when the race is finished" do
        before do
          allow(race).to receive(:finished?).and_return(true)
        end

        it "should return empty array" do
          expect(tc.results_for_competitors([competitor])).to eq([])
        end
      end
    end

    context "when the clubs have enough competitors" do
      before do
        @default_shooting_score = 90
        @default_time_in_seconds = 1000

        @club_best_total_points = instance_double(Club, display_name: 'Club 1', id: 1)
        @club_best_single_points = instance_double(Club, display_name: 'Club 2', id: 2)
        @club_best_single_shots = instance_double(Club, display_name: 'Club 3', id: 3)
        @club_best_single_time = instance_double(Club, display_name: 'Club 4', id: 4)
        @club_worst = instance_double(Club, display_name: 'Club 5', id: 5)
        @club_small = instance_double(Club, display_name: 'Club small', id: 6)
        @club_unofficial = instance_double(Club, display_name: 'Club unofficial', id: 7)
        @club_no_result = instance_double(Club, display_name: 'Club no results yet', id: 8)

        @best_points_1 = 1100
        @best_points_2 = 1000
        @second_points_1 = 1050
        @second_points_2 = 800
        @club_best_team_2_points = 700
        @club_best_team_3_points = 600
        @club_best_total_points_c1 = create_competitor(@club_best_total_points, @best_points_1, time_in_seconds: nil)
        @club_best_total_points_c2 = create_competitor(@club_best_total_points, @best_points_2)
        @club_best_total_points_c_excl = create_competitor(@club_best_total_points, @best_points_2 - 1)
        @club_best_single_points_c1 = create_competitor(@club_best_single_points, @second_points_1 + 1)
        @club_best_single_points_c2 = create_competitor(@club_best_single_points, @second_points_2 - 1)
        @club_best_single_shots_c1 = create_competitor(@club_best_single_shots, @second_points_1)
        @club_best_single_shots_c2 = create_competitor(@club_best_single_shots, @second_points_2, shooting_score: @default_shooting_score + 1)
        @club_best_single_time_c1 = create_competitor(@club_best_single_time, @second_points_1)
        @club_best_single_time_c2 = create_competitor(@club_best_single_time, @second_points_2, time_in_seconds: @default_time_in_seconds - 1)
        @club_worst_c1 = create_competitor(@club_worst, @second_points_1)
        @club_worst_c2 = create_competitor(@club_worst, @second_points_2)
        @club_2_team_2_c1 = create_competitor(@club_best_single_points, @club_best_team_2_points)
        @club_2_team_2_c2 = create_competitor(@club_best_single_points, @club_best_team_2_points)
        @club_2_team_3_c1 = create_competitor(@club_best_single_points, @club_best_team_3_points)
        @club_2_team_3_c2 = create_competitor(@club_best_single_points, @club_best_team_3_points)

        @club_no_result_c1 = create_competitor(@club_no_result, 0, shooting_score: nil, time_in_seconds: nil)
        @club_no_result_c2 = create_competitor(@club_no_result, 0, shooting_score: nil)

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
            @club_best_single_points_c2, @club_2_team_2_c1, @club_2_team_2_c2,
            @club_2_team_3_c1, @club_2_team_3_c2,
            @club_no_result_c1, @club_no_result_c2,
            @club_unofficial1, @club_unofficial2, @club_small_nil_points]
        @official_competitors = @competitors - [@club_unofficial1, @club_unofficial2]
        allow(tc).to receive(:race).and_return(race)
        allow(race).to receive(:finished?).and_return(true)
        expect(Competitor).to receive(:sort_team_competitors).with(sport, @official_competitors, false).and_return(@official_competitors)
      end

      describe "should return an array of hashes" do
        before do
          @results = tc.results_for_competitors(@competitors)
        end

        context "when race is finished" do
          it "including only the clubs with enough official competitors with complete points " +
              "so that the clubs are ordered: 1. total points " +
              "2. best individual points 3. best individual shot points " +
              "4. fastest individual time" do
            expect(@results.length).to eq(8)
            expect(@results[0].name).to eq(@club_best_total_points.display_name)
            expect(@results[1].name).to eq(@club_best_single_points.display_name)
            expect(@results[2].name).to eq(@club_best_single_shots.display_name)
            expect(@results[3].name).to eq(@club_best_single_time.display_name)
            expect(@results[4].name).to eq(@club_worst.display_name)
            expect(@results[5].name).to eq(@club_best_single_points.display_name + ' II')
            expect(@results[6].name).to eq(@club_best_single_points.display_name + ' III')
            expect(@results[7].name).to eq(@club_no_result.display_name)
          end
        end

        context "when race is not finished" do
          it "including all the clubs, even with not enough official competitors with complete points " +
              "so that the clubs are ordered: 1. total points " +
              "2. best individual points 3. best individual shot points " +
              "4. fastest individual time" do
            allow(tc).to receive(:race).and_return(race)
            allow(race).to receive(:finished?).and_return(false)
            expect(Competitor).to receive(:sort_team_competitors).with(sport, @official_competitors, false).and_return(@official_competitors)
            @results = tc.results_for_competitors(@competitors)
            expect(@results.length).to eq(10)
            expect(@results[0].name).to eq(@club_best_total_points.display_name)
            expect(@results[1].name).to eq(@club_best_single_points.display_name)
            expect(@results[2].name).to eq(@club_best_single_shots.display_name)
            expect(@results[3].name).to eq(@club_best_single_time.display_name)
            expect(@results[4].name).to eq(@club_worst.display_name)
            expect(@results[5].name).to eq(@club_best_single_points.display_name + ' II')
            expect(@results[6].name).to eq(@club_small.display_name)
            expect(@results[7].name).to eq(@club_best_single_points.display_name + ' III')
            expect(@results[8].name).to eq(@club_best_total_points.display_name + ' II')
            expect(@results[9].name).to eq(@club_no_result.display_name)
          end
        end

        it "including total points" do
          expect(@results[0].total_score).to eq(@best_points_1 + @best_points_2)
          expect(@results[1].total_score).to eq(@second_points_1 + 1 + @second_points_2 - 1)
          expect(@results[2].total_score).to eq(@second_points_1 + @second_points_2)
          expect(@results[3].total_score).to eq(@second_points_1 + @second_points_2)
          expect(@results[4].total_score).to eq(@second_points_1 + @second_points_2)
        end

        it "including ordered competitors inside of each team" do
          expect(@results[0].competitors.length).to eq(2)
          expect(@results[0].competitors[0]).to eq(@club_best_total_points_c1)
          expect(@results[0].competitors[1]).to eq(@club_best_total_points_c2)
          expect(@results[1].competitors.length).to eq(2)
          expect(@results[1].competitors[0]).to eq(@club_best_single_points_c1)
          expect(@results[1].competitors[1]).to eq(@club_best_single_points_c2)
        end
      end

      def create_competitor(club, points, options={})
        competitor = instance_double(Competitor, {club: club, shooting_score: @default_shooting_score,
                                     time_in_seconds: @default_time_in_seconds, club_id: club.id,
                                     team_name: nil}.merge(options))
        allow(competitor).to receive(:team_competition_points).with(sport, false).and_return(points)
        allow(competitor).to receive(:unofficial?).and_return(options[:unofficial])
        competitor
      end

      context 'when 3 competitors / team' do
        before do
          tc.team_competitor_count = 3
          @results = tc.results_for_competitors(@competitors)
        end

        it 'chooses teams that have at least 3 competitors' do
          expect(@results.length).to eq(3)
          expect(@results[0].name).to eq(@club_best_total_points.display_name)
          expect(@results[1].name).to eq(@club_best_single_points.display_name)
          expect(@results[2].name).to eq(@club_best_single_points.display_name + ' II')
        end
      end

      context 'when no multiple teams wanted' do
        before do
          tc.multiple_teams = false
          @results = tc.results_for_competitors(@competitors)
        end

        it 'does not create second teams' do
          expect(@results.length).to eq(6)
          expect(@results[0].total_score).to eq(@best_points_1 + @best_points_2)
        end
      end

      context "when team name is wanted to use" do
        before do
          tc.use_team_name = true
        end

        context "but no team names defined" do
          it "should return no results" do
            expect(tc.results_for_competitors(@competitors)).to eq([])
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
            @results = tc.results_for_competitors(@competitors)
          end

          it "should return results for teams with those competitors" do
            expect(@results.length).to eq(2)
          end

          it "should sort teams correctly" do
            expect(@results[0].name).to eq('Team best')
            expect(@results[1].name).to eq('Team second')
          end
        end
      end
    end

    context 'when two run race teams with equal points but other having time and other one not' do
      let(:club1) { build :club, name: 'Club 1' }
      let(:club2) { build :club, name: 'Club 2' }
      let(:c1a) { build :competitor, club: club1 }
      let(:c1b) { build :competitor, club: club1 }
      let(:c2a) { build :competitor, club: club2 }
      let(:c2b) { build :competitor, club: club2 }
      let(:competitors) { [c1a, c1b, c2a, c2b] }

      before do
        c1a.shooting_score_input = 90
        c1a.start_time = '00:00:00'
        c1a.arrival_time = '00:10:00'
        c2a.shooting_score_input = 90
        expect(Competitor).to receive(:sort_team_competitors).with(sport, competitors, false).and_return(competitors)
      end

      it 'should not crash' do
        expect(tc.results_for_competitors(competitors).map(&:name)).to eql ['Club 1', 'Club 2']
      end
    end

    context 'when shooting race' do
      let(:sport_key) { Sport::ILMAHIRVI }
      let(:club1) { build :club, id: 1, name: 'Best points' }
      let(:club2) { build :club, id: 2, name: 'Best competitor points' }
      let(:club3) { build :club, id: 3, name: 'Most hits' }
      let(:club4) { build :club, id: 4, name: 'More big shots' }
      let(:club5) { build :club, id: 5, name: 'Last' }
      let(:competitors) { [] }

      before do
        competitors << build_shooting_competitor(club1, 91, 9, [8, 8, 9, 9, 7, 7])
        competitors << build_shooting_competitor(club1, 90, 9, [8, 8, 9, 9, 7, 7])

        competitors << build_shooting_competitor(club2, 90, 9, [8, 8, 9, 9, 7, 7])
        competitors << build_shooting_competitor(club2, 88, 9, [8, 8, 9, 9, 7, 7])

        competitors << build_shooting_competitor(club3, 89, 9, [8, 8, 9, 9, 7, 7])
        competitors << build_shooting_competitor(club3, 88, 10, [8, 8, 9, 9, 7, 7])

        competitors << build_shooting_competitor(club4, 89, 9, [8, 10, 9, 9, 7, 8])
        competitors << build_shooting_competitor(club4, 88, 9, [10, 8, 9, 9, 7, 6])

        competitors << build_shooting_competitor(club5, 89, 9, [9, 8, 10, 9, 7, 7])
        competitors << build_shooting_competitor(club5, 88, 9, [9, 8, 9, 10, 7, 7])

        @results = tc.results_for_competitors competitors.shuffle
      end

      it 'sorts teams by 1. total points 2. best competitor points 3. count of hits for the team' do
        expect([0, 1, 2, 3, 4].map{|i| @results[i].name}).to eql [club1, club2, club3, club4, club5].map(&:name)
      end

      context 'and shotgun race with extra shots' do
        before do
          tc.extra_shots = []
          tc.extra_shots << { "club_id" => club1.id, "shots1" => [0] } # should ignore this
          tc.extra_shots << { "club_id" => club2.id, "shots2" => [1] } # should ignore this
          tc.extra_shots << { "club_id" => club3.id, "shots1" => [0], "shots2" => [0, 1, 0] }
          tc.extra_shots << { "club_id" => club4.id, "shots1" => [0, 0], "shots2" => [0, 1, 1] }
          tc.extra_shots << { "club_id" => club5.id, "shots1" => [1], "shots2" => [0] }
          @results = tc.results_for_competitors competitors
        end

        it 'sorts teams with equal points using extra shots' do
          expect([0, 1, 2, 3, 4].map{|i| @results[i].name}).to eql [club1, club2, club5, club4, club3].map(&:name)
        end
      end

      def build_shooting_competitor(club, qualification_round_score, hits, shots)
        competitor = build :competitor, club: club
        allow(competitor).to receive(:qualification_round_score).and_return(qualification_round_score)
        allow(competitor).to receive(:hits).and_return(hits)
        allow(competitor).to receive(:shots).and_return(shots)
        allow(competitor).to receive(:club_id).and_return(club.id)
        competitor
      end
    end

    context 'when nordic race' do
      let(:sport_key) { Sport::NORDIC }
      let(:club1) { build :club, id: 1, name: 'Best points' }
      let(:club2) { build :club, id: 2, name: 'Best extra score' }
      let(:club3) { build :club, id: 3, name: 'Best competitor points' }
      let(:club4) { build :club, id: 4, name: 'Last' }
      let(:competitors) { [] }

      before do
        competitors << build_nordic_competitor(club1, 350)
        competitors << build_nordic_competitor(club1, 360)

        competitors << build_nordic_competitor(club2, 349)
        competitors << build_nordic_competitor(club2, 361)

        competitors << build_nordic_competitor(club3, 370)
        competitors << build_nordic_competitor(club3, 339)

        competitors << build_nordic_competitor(club4, 369)
        competitors << build_nordic_competitor(club4, 340)

        tc.extra_shots = [{"club_id" => club1.id, "score1" => 100, "score2" => 25}, {"club_id" => club2.id, "score1" => 99, "score2" => 25}]
        @results = tc.results_for_competitors competitors.shuffle
      end

      it 'sorts teams by 1. total points 2. best competitor points' do
        expect([0, 1, 2, 3].map{|i| @results[i].name}).to eql [club1, club2, club3, club4].map(&:name)
      end

      def build_nordic_competitor(club, nordic_score)
        competitor = build :competitor, club: club
        allow(competitor).to receive(:nordic_score).and_return(nordic_score)
        allow(competitor).to receive(:club_id).and_return(club.id)
        competitor
      end
    end

    context 'when european race' do
      let(:sport_key) { Sport::EUROPEAN }
      let(:club1) { build :club, id: 1, name: 'Best points' }
      let(:club2) { build :club, id: 2, name: 'Best competitor points' }
      let(:club3) { build :club, id: 3, name: 'Better rifle points' }
      let(:club4) { build :club, id: 4, name: 'Last' }
      let(:competitors) { [] }

      before do
        competitors << build_european_competitor(club1, 380, [380, 190, 40, 40])
        competitors << build_european_competitor(club1, 380, [380, 190, 40, 40])

        competitors << build_european_competitor(club2, 378, [378, 190, 40, 40])
        competitors << build_european_competitor(club2, 381, [381, 190, 40, 40])

        competitors << build_european_competitor(club3, 379, [379, 200, 50, 50])
        competitors << build_european_competitor(club3, 380, [380, 195, 50, 49])

        competitors << build_european_competitor(club4, 380, [380, 195, 50, 48])
        competitors << build_european_competitor(club4, 379, [379, 199, 50, 50])

        @results = tc.results_for_competitors competitors.shuffle
      end

      it 'sorts teams by 1. total points 2. best competitor points 3. best rifle points (etc)' do
        expect([0, 1, 2, 3].map{|i| @results[i].name}).to eql [club1, club2, club3, club4].map(&:name)
      end

      def build_european_competitor(club, european_score, results_array)
        competitor = build :competitor, club: club
        allow(competitor).to receive(:european_score).and_return(european_score)
        allow(competitor).to receive(:european_total_results).and_return(results_array)
        allow(competitor).to receive(:club_id).and_return(club.id)
        competitor
      end
    end

    describe 'rifle results' do
      let(:sport_key) { Sport::EUROPEAN }
      let(:club1) { build :club, id: 1, name: 'Best total score' }
      let(:club2) { build :club, id: 2, name: 'Best competitor rifle score' }
      let(:club3) { build :club, id: 3, name: 'Best competitor secondary rifle score' }
      let(:club4) { build :club, id: 4, name: 'Most hits for team' }
      let(:club5) { build :club, id: 5, name: 'Most tens, nines for team' }
      let(:club6) { build :club, id: 6, name: 'Last' }
      let(:competitors) { [] }

      before do
        competitors << build_european_rifle_competitor(club1, 180, [180, 40, 40], 18, [10, 9, 8, 7, 6])
        competitors << build_european_rifle_competitor(club1, 180, [180, 40, 40], 18, [10, 9, 8, 7, 6])

        competitors << build_european_rifle_competitor(club2, 178, [178, 40, 40], 18, [10, 9, 8, 7, 6])
        competitors << build_european_rifle_competitor(club2, 181, [181, 40, 40], 18, [10, 9, 8, 7, 6])

        competitors << build_european_rifle_competitor(club3, 178, [178, 40, 40], 18, [10, 9, 8, 7, 6])
        competitors << build_european_rifle_competitor(club3, 180, [180, 40, 42], 18, [10, 9, 8, 7, 6])

        competitors << build_european_rifle_competitor(club4, 178, [178, 40, 40], 19, [10, 9, 8, 7, 6])
        competitors << build_european_rifle_competitor(club4, 180, [180, 40, 41], 18, [10, 9, 8, 7, 6])

        competitors << build_european_rifle_competitor(club5, 178, [178, 40, 40], 18, [10, 9, 8, 7, 7])
        competitors << build_european_rifle_competitor(club5, 180, [180, 40, 41], 18, [10, 9, 8, 7, 6])

        competitors << build_european_rifle_competitor(club6, 178, [178, 40, 40], 18, [10, 9, 8, 7, 6])
        competitors << build_european_rifle_competitor(club6, 180, [180, 40, 41], 18, [10, 9, 8, 7, 6])

        @results = tc.results_for_competitors competitors.shuffle, true
      end

      it 'should sort teams by 1. total rifle points 2. best competitor rifle points etc 3. team hits 4. team tens etc' do
        expect([0, 1, 2, 3, 4, 5].map{|i| @results[i].name}).to eql [club1, club2, club3, club4, club5, club6].map(&:name)
      end

      def build_european_rifle_competitor(club, european_rifle_score, results_array, hits, shots)
        competitor = build :competitor, club: club
        allow(competitor).to receive(:european_rifle_score).and_return(european_rifle_score)
        allow(competitor).to receive(:european_rifle_results).and_return(results_array)
        allow(competitor).to receive(:hits).and_return(hits)
        allow(competitor).to receive(:european_rifle1_shots).and_return(shots)
        allow(competitor).to receive(:european_rifle2_shots).and_return(shots)
        allow(competitor).to receive(:european_rifle3_shots).and_return(shots)
        allow(competitor).to receive(:european_rifle4_shots).and_return(shots)
        allow(competitor).to receive(:club_id).and_return(club.id)
        competitor
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

  describe 'extra shots helpers' do
    let(:tc) { build :team_competition }

    context 'when extra_shots is nil' do
      it 'has_extra_score? returns false' do
        expect(tc.has_extra_score?).to be_falsey
      end

      it 'max_extra_shots returns 0' do
        expect(tc.max_extra_shots).to eql 0
      end
    end

    context 'when extra_shots contains empty array' do
      before do
        tc.extra_shots = []
      end

      it 'has_extra_score? returns false' do
        expect(tc.has_extra_score?).to be_falsey
      end

      it 'max_extra_shots returns 0' do
        expect(tc.max_extra_shots).to eql 0
      end
    end

    context 'when extra_shots contain shots' do
      before do
        tc.extra_shots = [{"shots1" => [1, 0]}, {"shots1" => [1, 1], "shots2" => [0, 1, 1, 1]}]
      end

      it 'has_extra_score? returns true' do
        expect(tc.has_extra_score?).to be_truthy
      end

      it 'max_extra_shots returns the biggest amount of shots' do
        expect(tc.max_extra_shots).to eql 4
      end
    end

    context 'when extra_shots contain scores (nordic)' do
      before do
        tc.extra_shots = [{"score1" => 98}]
      end

      it 'has_extra_score? returns true' do
        expect(tc.has_extra_score?).to be_truthy
      end

      it 'max_extra_shots returns 0' do
        expect(tc.max_extra_shots).to eql 0
      end
    end
  end
end
