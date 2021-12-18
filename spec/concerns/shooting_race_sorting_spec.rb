require 'spec_helper'

describe 'shooting race sorting' do
  let(:basic_shots_count) { sport.shot_count }

  describe 'ilmaluodikko SM 2019' do
    let(:race) { build :race, sport_key: Sport::ILMALUODIKKO, start_date: '2019-07-01' }
    let(:sport) { race.sport }
    let(:subdir) { 'ilmaluodikko-sm2019' }

    it 'M' do
      test_file subdir, 'm'
    end

    it 'M50' do
      test_file subdir, 'm50'
    end

    it 'M60' do
      test_file subdir, 'm60'
    end

    it 'M70' do
      test_file subdir, 'm70'
    end

    it 'N' do
      test_file subdir, 'n'
    end

    it 'S13' do
      test_file subdir, 's13'
    end

    it 'S15' do
      test_file subdir, 's15'
    end

    it 'S17' do
      test_file subdir, 's17'
    end
  end

  describe 'ilmahirvi 2013' do
    let(:race) { build :race, sport_key: Sport::ILMAHIRVI, start_date: '2013-07-01' }
    let(:sport) { race.sport }
    let(:subdir) { 'ilmahirvi-sm2013' }

    it 'M' do
      test_file subdir, 'm'
    end

    it 'M60' do
      test_file subdir, 'm60'
    end

    it 'N' do
      test_file subdir, 'n'
    end

    it 'N50' do
      test_file subdir, 'n50'
    end
  end

  def test_file(subdir, file_name)
    shot_lines = File.open("spec/concerns/shots/#{subdir}/#{file_name}").readlines
    competitors = shot_lines.each_with_index.map {|line, i| build_competitor line, i }
    sorted_competitors = Competitor.sort_shooting_race_competitors competitors
    errors = []
    sorted_competitors.each_with_index do |c, i|
      errors << "Expected #{c.first_name} to have position #{c.number} but had #{i + 1}" if c.number != i + 1
    end
    expect(errors).to be_empty, errors.join("\n")
  end

  def build_competitor(line, index)
    values = line.split ';'
    all_shots = values[1].split(',').map(&:to_i)
    shots = all_shots[0...basic_shots_count]
    extra_shots = all_shots.length > basic_shots_count ? all_shots[basic_shots_count..-1] : nil
    competitor = Competitor.new number: index + 1, first_name: values[0], shots: shots, extra_shots: extra_shots
    allow(competitor).to receive(:sport).and_return(sport)
    competitor
  end
end
