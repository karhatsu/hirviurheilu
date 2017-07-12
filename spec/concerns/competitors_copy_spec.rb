require 'spec_helper'

describe CompetitorsCopy do
  let(:existing_club_name) { 'existing club name' }
  let(:existing_series_name) { 'existing series name' }
  let(:existing_age_group_name) { 'existing age group name' }
  let(:target_race) { create :race }
  let(:target_club) { create :club, race: target_race, name: existing_club_name }
  let(:target_series) { create :series, race: target_race, name: existing_series_name }
  let(:target_age_group) { create :age_group, series: target_series, name: existing_age_group_name }
  let(:source_race) { create :race }
  let(:source_club1) { create :club, race: source_race, name: 'non-existing club' }
  let(:source_club2) { create :club, race: source_race, name: existing_club_name }
  let(:source_series1) { create :series, race: source_race, name: 'non-existing series' }
  let(:source_series2) { create :series, race: source_race, name: existing_series_name }
  let(:source_age_group1) { create :age_group, series: source_series1, name: 'non-existing age group' }
  let(:source_age_group2) { create :age_group, series: source_series2, name: existing_age_group_name }
  let(:source_competitor1) { create :competitor, club: source_club1, series: source_series1,
                                    age_group: source_age_group1, number: 1, start_time: '00:01:00' }
  let(:source_competitor2) { create :competitor, club: source_club2, series: source_series2,
                                    age_group: source_age_group2, number: 2, start_time: '00:02:00' }
  let(:source_competitor3) { create :competitor, club: source_club2, series: source_series2,
                                    age_group: nil, number: 3, start_time: '00:03:00' }

  describe '#copy_competitors_from' do
    before do
      source_competitor1
      source_competitor2
      source_competitor3
      target_club
      target_age_group
    end

    context 'when data is valid' do
      it 'copies all competitors' do
        target_race.copy_competitors_from source_race
        competitors = target_race.reload.competitors
        expect(competitors.count).to eql 3
        expect_competitor_match competitors[0], source_competitor1
        expect_competitor_match competitors[1], source_competitor2
        expect_competitor_match competitors[2], source_competitor3
      end

      it 'create series, age groups and clubs only if needed' do
        target_race.copy_competitors_from source_race
        target_race.reload
        expect(target_race.clubs.count).to eql 2
        expect(target_race.series.count).to eql 2
        expect(target_race.age_groups.count).to eql 2
      end

      it 'does not return errors' do
        errors = target_race.copy_competitors_from source_race
        expect(errors).to be_empty
      end

      def expect_competitor_match(competitor, source_competitor)
        expect(competitor.first_name).to eql source_competitor.first_name
        expect(competitor.last_name).to eql source_competitor.last_name
        expect(competitor.series.name).to eql source_competitor.series.name
        expect(competitor.age_group.name).to eql source_competitor.age_group.name if source_competitor.age_group
        expect(competitor.age_group).to be_nil unless source_competitor.age_group
        expect(competitor.club.name).to eql source_competitor.club.name
        expect(competitor.number).to eql source_competitor.number
        expect(competitor.start_time.strftime('%H:%M:%S')).to eql source_competitor.start_time.strftime('%H:%M:%S')
      end
    end

    context 'when duplicate competitor number in source and target race' do
      before do
        create :competitor, series: target_series, number: source_competitor2.number
        create :competitor, series: target_series, number: source_competitor3.number
      end

      it 'returns errors' do
        errors = target_race.copy_competitors_from source_race
        expect(errors.length).to eql 2
        expect(errors[0]).to eql "Kilpailijanumero #{source_competitor2.number} on jo käytössä tässä kilpailussa."
        expect(errors[1]).to eql "Kilpailijanumero #{source_competitor3.number} on jo käytössä tässä kilpailussa."
      end
    end

    context 'when race requires start times but competitors do not have them' do
      before do
        target_race.update_attribute :start_order, Race::START_ORDER_MIXED
        source_competitor1.update_attribute :start_time, nil
      end

      it 'returns error' do
        errors = target_race.copy_competitors_from source_race
        expect(errors.length).to eql 1
        error = 'Kohdekilpailu vaatii, että kilpailijoilla on lähtöajat mutta valitusta kilpailusta lähtöajat puuttuvat.'
        expect(errors[0]).to eql error
      end
    end
  end
end