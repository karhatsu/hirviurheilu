require 'spec_helper'

describe ResultRotationHelper do
  describe '#next_result_rotation_path' do
    let(:race) { FactoryGirl.build :race }
    let(:competition) { FactoryGirl.build :relay, race: race }
    let(:competition_path) { '/competition/5' }

    context 'when no result rotation competition paths' do
      before do
        expect(helper).to receive(:result_rotation_competitions_paths).with(race).and_return([])
      end

      it 'should be the competition path' do
        expect_path competition_path, competition_path
      end
    end

    context 'when result rotation competition paths' do
      before do
        @result_rotation_list = %w(/series/1 /team_competition /series/2)
        expect(helper).to receive(:result_rotation_competitions_paths).with(race).and_return(@result_rotation_list)
      end

      context 'when unknown competition is given' do
        it 'should return path for the first competition' do
          expect_path '/unknown', @result_rotation_list[0]
        end
      end

      context 'when competition corresponding to the first list item is given' do
        it 'should return the second path' do
          expect_path @result_rotation_list[0], @result_rotation_list[1]
        end
      end

      context 'when competition corresponding to the second list item is given' do
        it 'should return the third path' do
          expect_path @result_rotation_list[1], @result_rotation_list[2]
        end
      end

      context 'when competition corresponding to the last list item is given' do
        it 'should return the first path' do
          expect_path @result_rotation_list[2], @result_rotation_list[0]
        end
      end
    end

    def expect_path(given_competition_path, expected_path)
      expect(helper).to receive(:result_path).with(competition).and_return(given_competition_path)
      expect(helper.next_result_rotation_path(competition)).to eq(expected_path)
    end
  end

  describe '#result_path' do
    context 'for series' do
      it 'is series competitors path' do
        competition = FactoryGirl.build :series, id: 123
        expect(helper.result_path(competition)).to eq(series_competitors_path(nil, 123))
      end
    end

    context 'for team competition' do
      it 'is race team competition path' do
        race = FactoryGirl.build :race, id: 456
        competition = FactoryGirl.build :team_competition, id: 789, race: race
        expect(helper.result_path(competition)).to eq(race_team_competition_path(nil, 456, 789))
      end
    end

    context 'for relay' do
      it 'is race relay path' do
        race = FactoryGirl.build :race, id: 111
        competition = FactoryGirl.build :relay, id: 222, race: race
        expect(helper.result_path(competition)).to eq(race_relay_path(nil, 111, 222))
      end
    end

    context 'for race' do
      it 'is race path' do
        competition = FactoryGirl.build :race, id: 444
        expect(helper.result_path(competition)).to eq(race_path(nil, 444))
      end
    end

    context 'for all others' do
      it 'raises ArgumentError' do
        competition = 'invalid'
        expect { helper.result_path(competition) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#result_rotation_competitions_paths' do
    let(:series1) { instance_double Series }
    let(:series2) { instance_double Series }
    let(:series1_path) { '/series/1' }
    let(:series2_path) { '/series/2' }
    let(:tc1) { instance_double TeamCompetition }
    let(:tc2) { instance_double TeamCompetition }
    let(:tc1_path) { '/tc/1' }
    let(:tc2_path) { '/tc/2' }
    let(:race) { FactoryGirl.build :race }

    before do
      allow(helper).to receive(:result_rotation_series).with(race).and_return([series1, series2])
      allow(helper).to receive(:result_rotation_team_competitions).with(race).and_return([tc1, tc2])
      allow(helper).to receive(:result_rotation_team_competitions_cookie).and_return(true)
      allow(helper).to receive(:result_path).with(series1).and_return(series1_path)
      allow(helper).to receive(:result_path).with(series2).and_return(series2_path)
      allow(helper).to receive(:result_path).with(tc1).and_return(tc1_path)
      allow(helper).to receive(:result_path).with(tc2).and_return(tc2_path)
    end

    context 'when offline' do
      it 'should return an empty list' do
        expect(Mode).to receive(:offline?).and_return(true)
        expect(helper.result_rotation_competitions_paths(race)).to be_empty
      end
    end

    context 'when online' do
      before do
        expect(Mode).to receive(:offline?).and_return(false)
      end

      context 'when series available and team competitions wanted' do
        it 'should return paths for all series and team competitions' do
          list = helper.result_rotation_competitions_paths(race)
          expect(list).to eq([series1_path, series2_path, tc1_path, tc2_path])
        end
      end

      context 'but no series' do
        it 'should not return series paths nor team competition paths' do
          expect(helper).to receive(:result_rotation_series).with(race).and_return([])
          expect(helper.result_rotation_competitions_paths(race)).to be_empty
        end
      end

      context 'and no cookie for team competitions' do
        it 'should not return team competition paths unless cookie for that' do
          allow(helper).to receive(:result_rotation_team_competitions_cookie).and_return(false)
          list = helper.result_rotation_competitions_paths(race)
          expect(list).to eq([series1_path, series2_path])
        end
      end
    end
  end

  describe '#result_rotation_series' do
    it 'should return an empty list when race in the future' do
      race = FactoryGirl.create :race, start_date: Date.today - 1
      race.series << build_series(race, 1, '0:00', true)
      expect(result_rotation_series(race).size).to eq(0)
    end

    it 'should return an empty list when race was in the past' do
      race = FactoryGirl.create :race, start_date: Date.today - 2, end_date: Date.today - 1
      race.series << build_series(race, 1, '0:00', true)
      expect(result_rotation_series(race).size).to eq(0)
    end

    context 'when race is today' do
      let(:race) { FactoryGirl.create :race, start_date: Date.today, end_date: Date.today + 1 }

      before do
        @series1_1 = build_series race, 1, '0:00', true
        @series1_2 = build_series race, 1, '0:00', true
        @series1_3 = build_series race, 1, '23:59', true
        @series1_4 = build_series race, 1, '0:00', false
        @series2_1 = build_series race, 2, '0:00', true
        @series2_2 = build_series race, 2, '23:59', true
        race.series << @series1_1
        race.series << @series1_2
        race.series << @series1_3
        race.series << @series2_1
        race.series << @series2_2
      end

      context 'when race has started today' do
        it 'should return the started series that have results' do
          list = result_rotation_series(race)
          expect(list.size).to eq(2)
          expect(list[0]).to eq(@series1_1)
          expect(list[1]).to eq(@series1_2)
        end
      end

      context 'when race started yesterday' do
        it 'should return the series started today' do
          race.start_date = Date.today - 1
          race.end_date = Date.today
          race.save!
          list = result_rotation_series(race)
          expect(list.size).to eq(1)
          expect(list[0]).to eq(@series2_1)
        end
      end
    end

    def build_series(race, start_day, start_time, has_results)
      series = FactoryGirl.build :series, race: race, start_day: start_day, start_time: start_time
      competitor = FactoryGirl.build :competitor, series: series
      competitor.estimate1 = 100 if has_results
      series.competitors << competitor
      series
    end
  end

  describe '#result_rotation_team_competitions' do
    let(:race) { FactoryGirl.build :race }
    let(:tc1) { FactoryGirl.build :team_competition }
    let(:tc2) { FactoryGirl.build :team_competition }

    it 'should return the team competitions' do
      expect(race).to receive(:team_competitions).and_return([tc1, tc2])
      list = result_rotation_team_competitions(race)
      expect(list.size).to eq(2)
      expect(list[0]).to eq(tc1)
      expect(list[1]).to eq(tc2)
    end
  end

  describe '#refresh_counter_min_seconds' do
    it { expect(helper.refresh_counter_min_seconds).to eq(20) }
  end

  describe '#refresh_counter_default_seconds' do
    it { expect(helper.refresh_counter_default_seconds).to eq(30) }
  end

  describe '#refresh_counter_auto_scroll' do
    context 'when menu_series defined and result rotation auto scroll cookie defined' do
      it 'should return true' do
        expect(helper).to receive(:menu_series).and_return(instance_double(Series))
        expect(helper).to receive(:result_rotation_auto_scroll).and_return('cookie')
        expect(helper.refresh_counter_auto_scroll).to be_truthy
      end
    end

    context 'when menu_series not available' do
      it 'should return false' do
        expect(helper).to receive(:menu_series).and_return(nil)
        expect(helper.refresh_counter_auto_scroll).to be_falsey
      end
    end

    context 'when result rotation auto scroll cookie not available' do
      it 'should return false' do
        expect(helper).to receive(:menu_series).and_return(instance_double(Series))
        expect(helper).to receive(:result_rotation_auto_scroll).and_return(nil)
        expect(helper.refresh_counter_auto_scroll).to be_falsey
      end
    end
  end

  describe '#refresh_counter_seconds' do
    context 'when explicit seconds given' do
      it 'should return given seconds' do
        expect(helper.refresh_counter_seconds(25)).to eq(25)
      end
    end

    context 'when no explicit seconds' do
      context 'and no autoscroll' do
        it 'should return refresh counter default seconds' do
          expect(helper).to receive(:refresh_counter_auto_scroll).and_return(false)
          expect(helper.refresh_counter_seconds).to eq(helper.refresh_counter_default_seconds)
        end
      end

      context 'and autoscroll' do
        context 'but no menu series' do
          it 'should return refresh counter default seconds' do
            competitors = double(Array)
            expect(helper).to receive(:refresh_counter_auto_scroll).and_return(true)
            expect(helper).to receive(:menu_series).and_return(nil)
            expect(helper.refresh_counter_seconds).to eq(helper.refresh_counter_default_seconds)
          end
        end

        context 'and menu series' do
          context 'but series have less competitors than minimum seconds' do
            it 'should return refresh counter default seconds' do
              expect(helper).to receive(:refresh_counter_auto_scroll).and_return(true)
              series = instance_double(Series)
              competitors = double(Array)
              expect(helper).to receive(:menu_series).and_return(series)
              expect(series).to receive(:competitors).and_return(competitors)
              expect(competitors).to receive(:count).and_return(helper.refresh_counter_min_seconds - 1)
              expect(helper.refresh_counter_seconds).to eq(helper.refresh_counter_min_seconds)
            end
          end

          context 'and series have at least as many competitors as minimum seconds' do
            it 'should return competitor count' do
              expect(helper).to receive(:refresh_counter_auto_scroll).and_return(true)
              series = instance_double(Series)
              competitors = double(Array)
              expect(helper).to receive(:menu_series).and_return(series)
              expect(series).to receive(:competitors).and_return(competitors)
              expect(competitors).to receive(:count).and_return(helper.refresh_counter_min_seconds)
              expect(helper.refresh_counter_seconds).to eq(helper.refresh_counter_min_seconds)
            end
          end
        end
      end
    end
  end
end