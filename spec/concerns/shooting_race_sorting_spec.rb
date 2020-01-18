require 'spec_helper'

describe 'shooting race sorting' do
  let(:ilmaluodikko) { Sport.by_key Sport::ILMALUODIKKO }

  describe 'ilmaluodikko SM 2019' do
    let(:subdir) { 'ilmaluodikko-sm2019' }
    it 'M' do
      test_file subdir, 'm', ilmaluodikko
    end

    it 'M50' do
      test_file subdir, 'm50', ilmaluodikko
    end

    it 'M60' do
      test_file subdir, 'm60', ilmaluodikko
    end

    it 'M70' do
      test_file subdir, 'm70', ilmaluodikko
    end

    it 'N' do
      test_file subdir, 'n', ilmaluodikko
    end

    it 'S13' do
      test_file subdir, 's13', ilmaluodikko
    end

    it 'S15' do
      test_file subdir, 's15', ilmaluodikko
    end

    it 'S17' do
      test_file subdir, 's17', ilmaluodikko
    end
  end

  def test_file(subdir, file_name, sport)
    shot_lines = File.open("spec/concerns/shots/#{subdir}/#{file_name}").readlines
    competitors = shot_lines.each_with_index.map {|line, i| build_competitor line, i, sport }
    sorted_competitors = Competitor.sort_shooting_race_competitors competitors
    errors = []
    sorted_competitors.each_with_index do |c, i|
      errors << "Expected #{c.first_name} to have position #{c.number} but had #{i + 1}" if c.number != i + 1
    end
    expect(errors).to be_empty, errors.join("\n")
  end

  def build_competitor(line, index, sport)
    values = line.split ';'
    competitor = Competitor.new number: index + 1, first_name: values[0], shots: values[1].split(',').map(&:to_i)
    allow(competitor).to receive(:sport).and_return(sport)
    competitor
  end
end
