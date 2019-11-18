require 'spec_helper'

describe TitleHelper do
  include TimeFormatHelper

  describe '#series_result_title' do
    before do
      @competitors = double(Array)
      allow(@competitors).to receive(:empty?).and_return(false)
      @race = instance_double(Race, :finished? => false)
      @series = instance_double(Series, :race => @race, :competitors => @competitors, :started? => true)
    end

    it "should return '(Ei kilpailijoita)' when no competitors" do
      expect(@competitors).to receive(:empty?).and_return(true)
      expect(series_result_title(@series)).to eq('(Ei kilpailijoita)')
    end

    it "should return '(Sarja ei ole vielä alkanut)' when the series has not started yet" do
      expect(@series).to receive(:started?).and_return(false)
      expect(series_result_title(@series)).to eq('(Sarja ei ole vielä alkanut)')
    end

    it "should return 'Tulokset' when competitors and the race is finished" do
      expect(@race).to receive(:finished?).and_return(true)
      expect(series_result_title(@series)).to eq('Tulokset')
    end

    it "should return 'Tilanne (päivitetty: <time>)' when series still active" do
      original_zone = Time.zone
      Time.zone = 'Tokyo' # UTC+9 (without summer time so that test settings won't change)
      time = Time.utc(2011, 5, 13, 13, 45, 58)
      expect(@series).to receive(:competitors).and_return(@competitors)
      expect(@competitors).to receive(:maximum).with(:updated_at).and_return(time) # db return UTC
      expect(series_result_title(@series)).to eq('Tilanne (päivitetty: 13.05.2011 22:45:58)')
      Time.zone = original_zone
    end

    it "should return 'Tulokset - Kaikki kilpailijat' when all competitors and the race is finished" do
      expect(@race).to receive(:finished?).and_return(true)
      title = series_result_title(@series, Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME)
      expect(title).to eq('Tulokset - Kaikki kilpailijat')
    end

    it "should return 'Tilanne (päivitetty: <time>) - Kaikki kilpailijat' when all competitors and series still active" do
      original_zone = Time.zone
      Time.zone = 'Tokyo' # UTC+9 (without summer time so that test settings won't change)
      time = Time.utc(2011, 5, 13, 13, 45, 58)
      expect(@series).to receive(:competitors).and_return(@competitors)
      expect(@competitors).to receive(:maximum).with(:updated_at).and_return(time) # db return UTC
      title = series_result_title(@series, Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME)
      expect(title).to eq('Tilanne (päivitetty: 13.05.2011 22:45:58) - Kaikki kilpailijat')
      Time.zone = original_zone
    end
  end

  describe '#relay_result_title' do
    before do
      @competitors = double(Array)
      @teams = double(Array)
      allow(@teams).to receive(:empty?).and_return(false)
      @race = instance_double(Race)
      @relay = instance_double(Relay, :race => @race, :started? => true,
                               :relay_teams => @teams, :finished? => false)
    end

    it "should return '(Ei joukkueita)' when no teams" do
      expect(@teams).to receive(:empty?).and_return(true)
      expect(relay_result_title(@relay)).to eq('(Ei joukkueita)')
    end

    it "should return '(Viesti ei ole vielä alkanut)' when the relay has not started yet" do
      expect(@relay).to receive(:started?).and_return(false)
      expect(relay_result_title(@relay)).to eq('(Viesti ei ole vielä alkanut)')
    end

    it "should return 'Tulokset' when teams and the race is finished" do
      expect(@relay).to receive(:finished?).and_return(true)
      expect(relay_result_title(@relay)).to eq('Tulokset')
    end

    it "should return 'Tilanne (päivitetty: <time>)' when relay still active" do
      original_zone = Time.zone
      Time.zone = 'Tokyo' # UTC+9 (without summer time so that test settings won't change)
      time = Time.utc(2011, 5, 13, 13, 45, 58)
      expect(@relay).to receive(:relay_competitors).and_return(@competitors)
      expect(@competitors).to receive(:maximum).with(:updated_at).and_return(time) # db return UTC
      expect(relay_result_title(@relay)).to eq('Tilanne (päivitetty: 13.05.2011 22:45:58)')
      Time.zone = original_zone
    end
  end

  describe '#time_title' do
    it "should be 'Juoksu' when run sport" do
      race = instance_double(Race, sport_key: Sport::RUN)
      expect(helper.time_title(race)).to eq('Juoksu')
    end

    it "should be 'Hiihto' when no run sport" do
      race = instance_double(Race, sport_key: Sport::SKI)
      expect(helper.time_title(race)).to eq('Hiihto')
    end
  end

  describe '#club_title' do
    it "should be 'Piiri' when club level such" do
      race = build(:race, :club_level => Race::CLUB_LEVEL_PIIRI)
      expect(helper.club_title(race)).to eq('Piiri')
    end

    it "should be 'Seura' when club level such" do
      race = build(:race, :club_level => Race::CLUB_LEVEL_SEURA)
      expect(helper.club_title(race)).to eq('Seura')
    end

    it 'should throw exception when unknown club level' do
      race = build(:race, :club_level => 100)
      expect { helper.club_title(race) }.to raise_error(RuntimeError)
    end
  end

  describe '#clubs_title' do
    it "should be 'Piirit' when club level such" do
      race = build(:race, :club_level => Race::CLUB_LEVEL_PIIRI)
      expect(helper.clubs_title(race)).to eq('Piirit')
    end

    it "should be 'Seurat' when club level such" do
      race = build(:race, :club_level => Race::CLUB_LEVEL_SEURA)
      expect(helper.clubs_title(race)).to eq('Seurat')
    end

    it 'should throw exception when unknown club level' do
      race = build(:race, :club_level => 100)
      expect { helper.clubs_title(race) }.to raise_error(RuntimeError)
    end
  end

  describe '#shots_total_title' do
    it 'should return empty string when no shots sum for competitor' do
      competitor = instance_double(Competitor)
      expect(competitor).to receive(:shots_sum).and_return(nil)
      expect(helper.shots_total_title(competitor)).to eq('')
    end

    it 'should return space and title attribute with title and shots sum when sum available' do
      competitor = instance_double(Competitor)
      expect(competitor).to receive(:shots_sum).and_return(89)
      expect(helper.shots_total_title(competitor)).to eq(" title='Ammuntatulos: 89'")
    end
  end

  describe '#title_prefix' do
    it "should be '(Dev) ' when development environment" do
      allow(Rails).to receive(:env).and_return('development')
      expect(helper.title_prefix).to eq('(Dev) ')
    end

    it "should be '(Testi) ' when test environment" do
      allow(Rails).to receive(:env).and_return('test')
      expect(helper.title_prefix).to eq('(Testi) ')
    end

    it "should be '(Testi) ' when staging environment" do
      allow(Rails).to receive(:env).and_return('production')
      allow(ProductionEnvironment).to receive(:production?).and_return(false)
      expect(helper.title_prefix).to eq('(Testi) ')
    end

    it "should be '' when production environment" do
      allow(Rails).to receive(:env).and_return('production')
      allow(ProductionEnvironment).to receive(:production?).and_return(true)
      expect(helper.title_prefix).to eq('')
    end

    describe '#competitor_title' do
      describe 'without age group' do
        it 'contains race, series and competitor full name' do
          race = create :race, name: 'Good race'
          series = create :series, race: race, name: 'Fast series'
          competitor = create :competitor, series: series, first_name: 'Gary', last_name: 'Robertson'
          expect(helper.competitor_title(competitor)).to eq('Good race - Fast series - Robertson Gary')
        end
      end

      describe 'with age group' do
        it 'contains race, series and competitor full name appended with age group name' do
          race = create :race, name: 'Good race'
          series = create :series, race: race, name: 'Fast series'
          age_group = create :age_group, series: series, name: 'Slower'
          competitor = create :competitor, series: series, first_name: 'Gary', last_name: 'Robertson', age_group: age_group
          expect(helper.competitor_title(competitor)).to eq('Good race - Fast series - Robertson Gary (Slower)')
        end
      end
    end
  end
end
