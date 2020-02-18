require 'spec_helper'

describe BatchList do
  let(:another_race) { create :race }
  let!(:another_race_batch) { create :batch, race: another_race, number: 1 }
  let(:race) { create :race, shooting_place_count: 2 }
  let(:series) { create :series, race: race }
  let(:generator) { BatchList.new series }
  let(:first_batch_time) { '10:00' }
  let(:minutes_between_batches) { 10 }
  let(:second_batch_time) { '10:10' }

  context 'when no competitors' do
    it 'returns error' do
      generator.generate 1, 1, 1, first_batch_time, minutes_between_batches
      expect(generator.errors).to eql ['Sarjassa ei ole yhtään kilpailijaa']
      expect(race.batches.length).to eql 0
    end
  end

  context 'when race is missing shooting place count' do
    let!(:competitor) { create :competitor, series: series, number: 10 }

    before do
      race.update_attribute :shooting_place_count, nil
    end

    it 'returns error' do
      generator.generate 1, 1, 1, first_batch_time, minutes_between_batches
      expect(generator.errors).to eql ['Kilpailulle ei ole määritetty ammuntapaikkojen lukumäärää. Voit tallentaa tiedon kilpailun perustietojen lomakkeella.']
      expect(race.batches.length).to eql 0
    end
  end

  context 'when invalid values given as arguments' do
    let!(:competitor1) { create :competitor, series: series }

    it 'returns error when first_batch_number is 0' do
      generator.generate 0, 1, 1, first_batch_time, minutes_between_batches
      expect(generator.errors).to eql ['Ensimmäisen erän numero on virheellinen']
    end

    it 'returns error when first_track_place is 0' do
      generator.generate 1, 0, 1, first_batch_time, minutes_between_batches
      expect(generator.errors).to eql ['Ensimmäinen paikkanumero on virheellinen']
    end

    it 'returns error when invalid first_batch_time' do
      generator.generate 1, 1, 1, 'xx:99', minutes_between_batches
      expect(generator.errors).to eql ['Ensimmäinen erän kellonaika on virheellinen']
    end

    it 'returns error when minutes_between_batches is 0' do
      generator.generate 1, 1, 1, first_batch_time, 0
      expect(generator.errors).to eql ['Erälle varattu aika on virheellinen']
    end

    it 'returns multiple errors when multiple invalid values' do
      generator.generate -1, -1, 1, '10:60', 0
      expect(generator.errors).to eql ['Ensimmäisen erän numero on virheellinen',
                                       'Ensimmäinen paikkanumero on virheellinen',
                                       'Ensimmäinen erän kellonaika on virheellinen',
                                       'Erälle varattu aika on virheellinen']
    end
  end

  context 'when no batches, 2 tracks per batch, 3 competitors, and assignments started from 1/1' do
    let(:competitor1) { create :competitor, series: series, number: 10 }
    let(:competitor2) { create :competitor, series: series, number: 9 }
    let(:competitor3) { create :competitor, series: series, number: 11 }

    before do
      expect(generator).to receive(:shuffle_competitors).and_return([competitor1, competitor2, competitor3])
      generator.generate 1, 1, 1, first_batch_time, minutes_between_batches
    end

    it 'assigns 2 competitors to the first batch and 1 competitor to the second batch' do
      expect(generator.errors).to eql []
      expect(race.batches.length).to eql 2
      verify_batch 1, first_batch_time
      verify_batch 2, second_batch_time
      verify_competitor competitor1, 1, 1
      verify_competitor competitor2, 1, 2
      verify_competitor competitor3, 2, 1
    end

    describe 'next series' do
      let(:series2) { create :series, race: race }
      let(:competitor4) { create :competitor, series: series2, number: 100 }
      let(:competitor5) { create :competitor, series: series2, number: 101 }
      let(:competitor6) { create :competitor, series: series2, number: 102 }
      let(:generator2) { BatchList.new series2 }

      before do
        allow(generator2).to receive(:shuffle_competitors).and_return([competitor4, competitor5, competitor6])
      end

      context 'when assignment for the next series is started from a place that is already in use' do
        before do
          generator2.generate 2, 1, 1, second_batch_time, minutes_between_batches
        end

        it 'returns error' do
          expect(generator2.errors).to eql ['Ensimmäisen erän aloituspaikka on jo käytössä']
          expect(race.batches.length).to eql 2
          verify_competitor competitor4, nil, nil
        end
      end

      context 'when next series first batch time is tried to change' do
        before do
          generator2.generate 2, 2, 1, '15:15', minutes_between_batches
        end

        it 'returns error' do
          expect(generator2.errors).to eql ['Ensimmäinen erä on jo tallennettu mutta sen aika on eri kuin syöttämäsi aika']
          expect(race.batches.length).to eql 2
          verify_competitor competitor4, nil, nil
        end
      end

      context 'when next series has 3 competitors and first competitor is assigned to place 2/2' do
        before do
          generator2.generate 2, 2, 1, second_batch_time, minutes_between_batches
        end

        it 'assign first competitor to the batch #2 and creates new batch for other two competitors' do
          expect(generator.errors).to eql []
          expect(race.batches.length).to eql 3
          verify_batch 3, '10:20'
          verify_competitor competitor4, 2, 2
          verify_competitor competitor5, 3, 1
          verify_competitor competitor6, 3, 2
        end
      end
    end
  end

  context 'when no batches, 3 tracks per batch, and 4 competitors' do
    let(:competitor1) { create :competitor, series: series, number: 10 }
    let(:competitor2) { create :competitor, series: series, number: 9 }
    let(:competitor3) { create :competitor, series: series, number: 11 }
    let(:competitor4) { create :competitor, series: series, number: 7 }

    before do
      race.update_attribute :shooting_place_count, 3
      expect(generator).to receive(:shuffle_competitors).and_return([competitor1, competitor2, competitor3, competitor4])
      generator.generate 1, 1, 1, first_batch_time, minutes_between_batches
    end

    it 'assigns 3 competitors to the first batch and 1 competitor to the second batch' do
      expect(generator.errors).to eql []
      expect(race.batches.length).to eql 2
      verify_competitor competitor1, 1, 1
      verify_competitor competitor2, 1, 2
      verify_competitor competitor3, 1, 3
      verify_competitor competitor4, 2, 1
    end
  end

  context 'when some of the competitors already have a batch place assigned' do
    let(:minutes_between_batches) { 15 }
    let(:batch1) { create :batch, race: race, number: 1, time: '13:30' }
    let(:batch2) { create :batch, race: race, number: 2, time: '13:45' }
    let(:batch3) { create :batch, race: race, number: 3, time: '14:00' }
    let(:competitor_1_1) { create :competitor, series: series, number: 1 }
    let!(:competitor_1_2) { create :competitor, series: series, number: 2, batch: batch1, track_place: 2 }
    let!(:competitor_2_1) { create :competitor, series: series, number: 3, batch: batch2, track_place: 1 }
    let!(:competitor_2_2) { create :competitor, series: series, number: 4, batch: batch2, track_place: 2 }
    let!(:competitor_3_1) { create :competitor, series: series, number: 5, batch: batch3, track_place: 1 }
    let(:competitor_3_2) { create :competitor, series: series, number: 6 }
    let(:competitor_4_1) { create :competitor, series: series, number: 7 }

    before do
      competitors_without_batches = [competitor_1_1, competitor_3_2, competitor_4_1]
      expect(generator).to receive(:shuffle_competitors).with(competitors_without_batches).and_return([competitor_1_1, competitor_3_2, competitor_4_1])
      generator.generate 1, 1, 1, '13:30', minutes_between_batches
    end

    it 'does not set two competitors to the same place and does not change existing allocations' do
      expect(generator.errors).to eql []
      expect(race.batches.length).to eql 4
      verify_batch 4, '14:15'
      verify_competitor competitor_1_1, 1, 1
      verify_competitor competitor_1_2, 1, 2
      verify_competitor competitor_2_1, 2, 1
      verify_competitor competitor_2_2, 2, 2
      verify_competitor competitor_3_1, 3, 1
      verify_competitor competitor_3_2, 3, 2
      verify_competitor competitor_4_1, 4, 1
    end
  end

  context 'when given batch day is 2' do
    let(:competitor1) { create :competitor, series: series }
    let(:competitor2) { create :competitor, series: series }
    let(:competitor3) { create :competitor, series: series }

    before do
      race.update_attribute :end_date, race.start_date + 1.day
      create :batch, race: race, day: 1, number: 1, time: first_batch_time
      create :batch, race: race, day: 2, number: 2, time: first_batch_time
      allow(generator).to receive(:shuffle_competitors).and_return([competitor1, competitor2, competitor3])
    end

    context 'and first batch number is for a batch in a different day' do
      before do
        generator.generate 1, 1, 2, first_batch_time, minutes_between_batches
      end

      it 'returns error' do
        expect(generator.errors).to eql ['Ensimmäinen erä on jo tallennettu mutta sen päivä on eri kuin syöttämäsi päivä']
        expect(race.batches.length).to eql 2
      end
    end

    context 'and first batch number is for the same day and time' do
      before do
        generator.generate 2, 1, 2, first_batch_time, minutes_between_batches
      end

      it 'assigns competitors for the batch' do
        expect(generator.errors).to eql []
        expect(race.batches.length).to eql 3
        verify_batch 2, first_batch_time, 2
        verify_batch 3, second_batch_time, 2
      end
    end

    context 'and first batch number refers to a new batch' do
      before do
        generator.generate 3, 1, 2, first_batch_time, minutes_between_batches
      end

      it 'creates new batches with given day' do
        expect(generator.errors).to eql []
        expect(race.batches.length).to eql 4
        verify_batch 3, first_batch_time, 2
        verify_batch 4, second_batch_time, 2
      end
    end
  end

  def verify_batch(number, time, day=1)
    batch = Batch.where('race_id=? AND number=?', race.id, number).first
    expect(batch.time.strftime('%H:%M')).to eql time
    expect(batch.day).to eql day
  end

  def verify_competitor(competitor, batch_number, track_place)
    batch = competitor.reload.batch
    if batch_number
      expect(batch.number).to eql batch_number
    else
      expect(batch).to be_nil
    end
    expect(competitor.track_place).to eql track_place
  end
end
