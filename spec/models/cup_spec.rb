require 'spec_helper'

describe Cup do
  it "create" do
    create(:cup)
  end

  describe "associations" do
    it { is_expected.to have_many(:cup_series) }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_numericality_of(:top_competitions) }
    it { is_expected.not_to allow_value(nil).for(:top_competitions) }
    it { is_expected.not_to allow_value(0).for(:top_competitions) }
    it { is_expected.to allow_value(1).for(:top_competitions) }
    it { is_expected.not_to allow_value(2.1).for(:top_competitions) }
  end

  describe "relations" do
    it { is_expected.to have_and_belong_to_many(:races) }
    it { is_expected.to have_many(:cup_series) }

    describe "races" do
      it "should be ordered by start date and name" do
        cup = create(:cup)
        cup.races << build(:race, :start_date => '2012-04-01', name: 'Second B')
        cup.races << build(:race, :start_date => '2012-03-31', name: 'First')
        cup.races << build(:race, :start_date => '2012-04-01', name: 'Second A')
        expect(cup.races.collect { |r| r.name }).to eq(['First', 'Second A', 'Second B'])
      end
    end

    describe "cup_series" do
      it "should be ordered by name" do
        cup = create(:cup)
        cup.cup_series << build(:cup_series, :cup => cup, :name => 'S2')
        cup.cup_series << build(:cup_series, :cup => cup, :name => 'S3')
        cup.cup_series << build(:cup_series, :cup => cup, :name => 'S1')
        expect(cup.cup_series.collect { |cs| cs.name }).to eq(['S1', 'S2', 'S3'])
      end
    end
  end

  describe "#start_date" do
    it "should be nil when no races" do
      expect(build(:cup).start_date).to be_nil
    end

    it "should be the start date of the first race (since races are ordered by start date)" do
      cup = build(:cup)
      race1 = build(:race, :start_date => '2012-04-01')
      race2 = build(:race, :start_date => '2012-03-31')
      allow(cup).to receive(:races).and_return([race2, race1])
      expect(cup.start_date.strftime('%Y-%m-%d')).to eq('2012-03-31')
    end
  end

  describe "#end_date" do
    it "should be nil when no races" do
      expect(build(:cup).end_date).to be_nil
    end

    it "should be the end date of the last race (since races are ordered by start date)" do
      cup = build(:cup)
      race1 = build(:race, :start_date => '2012-04-01', :end_date => '2012-04-02')
      race2 = build(:race, :start_date => '2012-03-31', :end_date => '2012-03-31')
      allow(cup).to receive(:races).and_return([race2, race1])
      expect(cup.end_date.strftime('%Y-%m-%d')).to eq('2012-04-02')
    end
  end

  describe "#location" do
    it "should be nil when no races" do
      expect(build(:cup).location).to be_nil
    end

    context "when each race has different location" do
      it "should be all race locations separated with /" do
        cup = build(:cup)
        race1 = build(:race, :location => 'Shooting city')
        race2 = build(:race, :location => 'Skiing town')
        race3 = build(:race, :location => 'Running village')
        allow(cup).to receive(:races).and_return([race1, race2, race3])
        expect(cup.location).to eq('Shooting city / Skiing town / Running village')
      end
    end

    context "when each race has the same location" do
      it "should be the location" do
        cup = build(:cup)
        race1 = build(:race, :location => 'Shooting city')
        race2 = build(:race, :location => 'Shooting city')
        allow(cup).to receive(:races).and_return([race1, race2])
        expect(cup.location).to eq('Shooting city')
      end
    end

    context "when first and third race has the same location" do
      it "should be the first location / the second location" do
        cup = build(:cup)
        race1 = build(:race, :location => 'Shooting city')
        race2 = build(:race, :location => 'Skiing town')
        race3 = build(:race, :location => 'Shooting city')
        allow(cup).to receive(:races).and_return([race1, race2, race3])
        expect(cup.location).to eq('Shooting city / Skiing town')
      end
    end
  end

  describe "#create_default_cup_series" do
    context "when no races" do
      it "should do nothing" do
        cup = create(:cup)
        cup.create_default_cup_series
      end
    end

    context "when races" do
      before do
        race1 = instance_double(Race)
        series1_1 = instance_double(Series, :name => 'M50')
        series1_2 = instance_double(Series, :name => 'M60')
        allow(race1).to receive(:series).and_return([series1_1, series1_2])
        race2 = instance_double(Race)
        series2_1 = instance_double(Series, :name => 'M70')
        series2_2 = instance_double(Series, :name => 'M80')
        allow(race2).to receive(:series).and_return([series2_1, series2_2])
        races = [race1, race2]
        @cup = create(:cup)
        allow(@cup).to receive(:races).and_return(races)
      end

      it "should create cup series based on series names in the first race" do
        expect(@cup.cup_series).to be_empty
        @cup.create_default_cup_series
        @cup.reload
        cup_series = @cup.cup_series
        expect(cup_series.length).to eq(2)
        expect(cup_series[0].name).to eq('M50')
        expect(cup_series[1].name).to eq('M60')
      end
    end

    context "when already has cup series" do
      it "should raise an exception" do
        cup = build(:cup)
        allow(cup).to receive(:cup_series).and_return([instance_double(CupSeries)])
        expect { cup.create_default_cup_series }.to raise_error(RuntimeError)
      end
    end
  end

  describe "#create_default_cup_team_competitions" do
    context "when no races" do
      it "should do nothing" do
        cup = create(:cup)
        cup.create_default_cup_team_competitions
      end
    end

    context "when races" do
      before do
        race1 = instance_double(Race)
        tc1_1 = instance_double(TeamCompetition, name: 'Women')
        tc1_2 = instance_double(TeamCompetition, name: 'Men')
        allow(race1).to receive(:team_competitions).and_return([tc1_1, tc1_2])
        race2 = instance_double(Race)
        tc2_1 = instance_double(TeamCompetition, name: 'Men')
        tc2_2 = instance_double(TeamCompetition, name: 'Youngsters')
        allow(race2).to receive(:team_competitions).and_return([tc2_1, tc2_2])
        races = [race1, race2]
        @cup = create(:cup)
        allow(@cup).to receive(:races).and_return(races)
      end

      it "should create cup team competitions based on team competitions names in the first race" do
        expect(@cup.cup_team_competitions).to be_empty
        @cup.create_default_cup_team_competitions
        @cup.reload
        cup_team_competitions = @cup.cup_team_competitions
        expect(cup_team_competitions.length).to eq(2)
        expect(cup_team_competitions[0].name).to eq('Men')
        expect(cup_team_competitions[1].name).to eq('Women')
      end
    end

    context "when already has cup team competitions" do
      it "should raise an exception" do
        cup = build(:cup)
        allow(cup).to receive(:cup_team_competitions).and_return([instance_double(CupTeamCompetition)])
        expect { cup.create_default_cup_team_competitions }.to raise_error(RuntimeError)
      end
    end
  end

  describe ".cup_races" do
    it "should return an empty array when nothing given" do
      expect(Cup.cup_races([])).to eq([])
    end

    it "should return an empty array when cups without races" do
      expect(Cup.cup_races([create(:cup), create(:cup)])).to eq([])
    end

    it "should return all races that are assigned to cups" do
      cup1 = create(:cup)
      race11 = build(:race)
      race12 = build(:race)
      cup1.races << race11
      cup1.races << race12
      cup2 = create(:cup)
      race21 = build(:race)
      cup2.races << race21
      expect(Cup.cup_races(Cup.all)).to eq([race11, race12, race21])
    end
  end
end
