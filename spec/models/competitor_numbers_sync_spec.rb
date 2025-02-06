require 'spec_helper'

describe CompetitorNumbersSync do
  let(:race1) { create :race }
  let(:race2) { create :race }
  let(:race3) { create :race }
  let(:series1) { create :series, race: race1 }
  let(:series2) { create :series, race: race2 }
  let(:series3) { create :series, race: race3 }
  let(:club1_a) { create :club, race: race1, name: 'Club A' }
  let(:club1_b) { create :club, race: race1, name: 'Club B' }
  let(:club2_a) { create :club, race: race2, name: 'Club A' }
  let(:club2_b) { create :club, race: race2, name: 'Club B' }
  let(:club3_a) { create :club, race: race3, name: 'Club A' }
  let(:club3_b) { create :club, race: race3, name: 'Club B' }
  let(:club3_c) { create :club, race: race3, name: 'Club C' }
  let!(:competitor1_1) { create :competitor, series: series1, club: club1_a, number: 1, first_name: 'Timo', last_name: 'Testinen' }
  let!(:competitor1_2) { create :competitor, series: series1, club: club1_b, number: 2, first_name: 'Tiina', last_name: 'Testilä' }
  let!(:competitor1_nil) { create :competitor, series: series1, club: club1_b, number: nil, first_name: 'Tero', last_name: 'Testi' }
  let!(:competitor2_1) { create :competitor, series: series2, club: club2_a, number: 10, first_name: 'Timo', last_name: 'Testinen' }
  let!(:competitor2_2) { create :competitor, series: series2, club: club2_b, number: 1, first_name: 'Tiina', last_name: 'Testilä' }
  let!(:competitor2_3) { create :competitor, series: series2, club: club2_b, number: 2, first_name: 'Maija', last_name: 'Testilä' }
  let!(:competitor3_1) { create :competitor, series: series3, club: club3_b, number: 99, first_name: 'Tero', last_name: 'Testi' }
  let!(:competitor3_2) { create :competitor, series: series3, club: club3_b, number: 4, first_name: 'Timo', last_name: 'Testinen' }
  let!(:competitor3_3) { create :competitor, series: series3, club: club3_a, number: 5, first_name: 'Timo', last_name: 'Turunen' }

  it 'synchronises the numbers in given races based on the competitor names and clubs' do
    sync = CompetitorNumbersSync.new([race1, race2, race3].map(&:id), 1)
    sync.synchronize
    expect_number competitor1_1, 1, false
    expect_number competitor1_2, 2, false
    expect_number competitor1_nil, 3, true
    expect_number competitor2_1, 1, true
    expect_number competitor2_2, 2, true
    expect_number competitor2_3, 4, true # different first name
    expect_number competitor3_1, 3, true
    expect_number competitor3_2, 5, true # different club
    expect_number competitor3_3, 6, true # different last name
  end

  def expect_number(competitor, number, expect_change)
    updated_at = competitor.updated_at
    expect(competitor.reload.number).to eql number
    if expect_change
      expect(competitor.updated_at).not_to eql updated_at
    else
      expect(competitor.updated_at).to eql updated_at
    end
  end
end
