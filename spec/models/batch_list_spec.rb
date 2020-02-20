require 'spec_helper'

describe BatchList do
  let(:another_race) { create :race }
  let!(:another_race_batch) { create :batch, race: another_race, number: 1 }
  let(:shooting_place_count) { 2 }
  let(:race) { create :race, shooting_place_count: shooting_place_count }
  let(:series) { create :series, race: race }
  let(:generator) { BatchList.new series }
  let(:first_batch_time) { '10:00' }
  let(:minutes_between_batches) { 10 }
  let(:second_batch_time) { '10:10' }

  context 'when no competitors' do
    it 'returns error' do
      generator.generate 1, 1, first_batch_time, 1, minutes_between_batches
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
      generator.generate 1, 1, first_batch_time, 1, minutes_between_batches
      expect(generator.errors).to eql ['Kilpailulle ei ole määritetty ammuntapaikkojen lukumäärää. Voit tallentaa tiedon kilpailun perustietojen lomakkeella.']
      expect(race.batches.length).to eql 0
    end
  end

  context 'when invalid values given as arguments' do
    let!(:competitor1) { create :competitor, series: series }

    it 'returns error when first_batch_number is 0' do
      generator.generate 0, 1, first_batch_time, 1, minutes_between_batches
      expect(generator.errors).to eql ['Ensimmäisen erän numero on virheellinen']
    end

    it 'returns error when first_track_place is 0' do
      generator.generate 1, 0, first_batch_time, 1, minutes_between_batches
      expect(generator.errors).to eql ['Ensimmäinen paikkanumero on virheellinen']
    end

    it 'returns error when invalid first_batch_time' do
      generator.generate 1, 1, 'xx:99', 1, minutes_between_batches
      expect(generator.errors).to eql ['Ensimmäinen erän kellonaika on virheellinen']
    end

    it 'returns error when concurrent_batches is 0' do
      generator.generate 1, 1, first_batch_time, 0, 1
      expect(generator.errors).to eql ['Yhtäaikaisten erien määrä on virheellinen']
    end

    it 'returns error when minutes_between_batches is 0' do
      generator.generate 1, 1, first_batch_time, 1, 0
      expect(generator.errors).to eql ['Erälle varattu aika on virheellinen']
    end

    it 'returns multiple errors when multiple invalid values' do
      generator.generate -1, -1, '10:60', 1, 0
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
      generator.generate 1, 1, first_batch_time, 1, minutes_between_batches
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
          generator2.generate 2, 1, second_batch_time, 1, minutes_between_batches
        end

        it 'returns error' do
          expect(generator2.errors).to eql ['Ensimmäisen erän aloituspaikka on jo käytössä']
          expect(race.batches.length).to eql 2
          verify_competitor competitor4, nil, nil
        end
      end

      context 'when next series first batch time is tried to change' do
        before do
          generator2.generate 2, 2, '15:15', 1, minutes_between_batches
        end

        it 'returns error' do
          expect(generator2.errors).to eql ['Ensimmäinen erä on jo tallennettu mutta sen aika on eri kuin syöttämäsi aika']
          expect(race.batches.length).to eql 2
          verify_competitor competitor4, nil, nil
        end
      end

      context 'when next series has 3 competitors and first competitor is assigned to place 2/2' do
        before do
          generator2.generate 2, 2, second_batch_time, 1, minutes_between_batches
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
      generator.generate 1, 1, first_batch_time, 1, minutes_between_batches
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
      generator.generate 1, 1, '13:30', 1, minutes_between_batches
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
      create :batch, race: race, day: 2, number: 2, time: first_batch_time, track: nil
      allow(generator).to receive(:shuffle_competitors).and_return([competitor1, competitor2, competitor3])
    end

    context 'and first batch number is for a batch in a different day' do
      before do
        generator.generate 1, 1, first_batch_time, 1, minutes_between_batches, batch_day: 2
      end

      it 'returns error' do
        expect(generator.errors).to eql ['Ensimmäinen erä on jo tallennettu mutta sen päivä on eri kuin syöttämäsi päivä']
        expect(race.batches.length).to eql 2
      end
    end

    context 'and first batch number is for the same day and time' do
      before do
        generator.generate 2, 1, first_batch_time, 1, minutes_between_batches, batch_day: 2
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
        generator.generate 3, 1, first_batch_time, 1, minutes_between_batches, batch_day: 2
      end

      it 'creates new batches with given day' do
        expect(generator.errors).to eql []
        expect(race.batches.length).to eql 4
        verify_batch 3, first_batch_time, 2
        verify_batch 4, second_batch_time, 2
      end
    end
  end

  describe 'when concurrent batches' do
    let(:competitor1) { create :competitor, series: series }
    let(:competitor2) { create :competitor, series: series }
    let(:competitor3) { create :competitor, series: series }
    let(:competitor4) { create :competitor, series: series }
    let(:competitor5) { create :competitor, series: series }
    let(:competitor6) { create :competitor, series: series }
    let(:competitor7) { create :competitor, series: series }

    context 'and no previous batches' do
      before do
        competitors = [competitor1, competitor2, competitor3, competitor4, competitor5, competitor6, competitor7]
        expect(generator).to receive(:shuffle_competitors).and_return(competitors)
        generator.generate 1, 1, first_batch_time, 2, minutes_between_batches
      end

      it 'generates concurrent batches' do
        expect(generator.errors).to eql []
        expect(race.batches.length).to eql 4
        verify_batch 1, first_batch_time, 1, 1
        verify_batch 2, first_batch_time, 1, 2
        verify_batch 3, second_batch_time, 1, 1
        verify_batch 4, second_batch_time, 1, 2
        verify_competitor competitor1, 1, 1
        verify_competitor competitor7, 4, 1
      end
    end

    context 'and competitors already allocated' do
      let(:batch1_1) { create :batch, race: race, number: 1, track: 1, time: first_batch_time }
      let(:batch1_2) { create :batch, race: race, number: 2, track: 2, time: first_batch_time }

      before do
        competitor1.batch = batch1_1
        competitor1.track_place = 1
        competitor1.save!
        competitor2.batch = batch1_1
        competitor2.track_place = 2
        competitor2.save!
        competitor3.batch = batch1_2
        competitor3.track_place = 1
        competitor3.save!
        competitors = [competitor4, competitor5, competitor6, competitor7]
        expect(generator).to receive(:shuffle_competitors).and_return(competitors)
        generator.generate 2, 2, first_batch_time, 2, minutes_between_batches
      end

      it 'continues from the last track' do
        expect(generator.errors).to eql []
        expect(race.batches.length).to eql 4
        verify_batch 3, second_batch_time, 1, 1
        verify_batch 4, second_batch_time, 1, 2
        verify_competitor competitor4, 2, 2
        verify_competitor competitor7, 4, 1
      end
    end

    context 'and previous allocation was without concurrent batches' do
      let(:batch1) { create :batch, race: race, number: 1, track: nil, time: first_batch_time }

      before do
        competitor1.batch = batch1
        competitor1.track_place = 1
        competitor1.save!
        competitors = [competitor2, competitor3, competitor4, competitor5, competitor6, competitor7]
        expect(generator).to receive(:shuffle_competitors).and_return(competitors)
        generator.generate 1, 2, first_batch_time, 2, minutes_between_batches
      end

      it 'is able to start using track numbers for batches' do
        expect(generator.errors).to eql []
        expect(race.batches.length).to eql 4
        verify_batch 1, first_batch_time, 1, 1
        verify_batch 2, first_batch_time, 1, 2
        verify_batch 3, second_batch_time, 1, 1
        verify_batch 4, second_batch_time, 1, 2
        verify_competitor competitor3, 2, 1
      end
    end
  end

  describe 'with track place assignment options' do
    let(:shooting_place_count) { 4 }
    let(:competitor1) { create :competitor, series: series }
    let(:competitor2) { create :competitor, series: series }
    let(:competitor3) { create :competitor, series: series }
    let(:competitor4) { create :competitor, series: series }
    let(:competitor5) { create :competitor, series: series }
    let(:competitor6) { create :competitor, series: series }
    let(:competitor7) { create :competitor, series: series }

    before do
      competitors = [competitor1, competitor2, competitor3, competitor4, competitor5, competitor6, competitor7]
      allow(generator).to receive(:shuffle_competitors).and_return(competitors)
    end

    context 'when the first track place is skipped' do
      before do
        generator.generate 1, 1, first_batch_time, 1, minutes_between_batches, skip_first_track_place: true
      end

      it 'assigns competitors to track places 2-n' do
        expect(generator.errors).to eql []
        verify_competitor competitor1, 1, 2
        verify_competitor competitor2, 1, 3
        verify_competitor competitor3, 1, 4
        verify_competitor competitor4, 2, 2
        verify_competitor competitor7, 3, 2
      end
    end

    context 'when the last track place is skipped' do
      before do
        generator.generate 1, 1, first_batch_time, 1, minutes_between_batches, skip_last_track_place: true
      end

      it 'assigns competitors to track places 1-(n-1)' do
        expect(generator.errors).to eql []
        verify_competitor competitor1, 1, 1
        verify_competitor competitor2, 1, 2
        verify_competitor competitor3, 1, 3
        verify_competitor competitor4, 2, 1
        verify_competitor competitor7, 3, 1
      end
    end

    context 'when only odd track places are used' do
      before do
        generator.generate 1, 1, first_batch_time, 1, minutes_between_batches, only_track_places: 'odd'
      end

      it 'assigns competitors to track places 1, 3,...' do
        expect(generator.errors).to eql []
        verify_competitor competitor1, 1, 1
        verify_competitor competitor2, 1, 3
        verify_competitor competitor3, 2, 1
        verify_competitor competitor4, 2, 3
      end
    end

    context 'when only even track places are used' do
      before do
        generator.generate 1, 1, first_batch_time, 1, minutes_between_batches, only_track_places: 'even'
      end

      it 'assigns competitors to track places 1, 3,...' do
        expect(generator.errors).to eql []
        verify_competitor competitor1, 1, 2
        verify_competitor competitor2, 1, 4
        verify_competitor competitor3, 2, 2
        verify_competitor competitor4, 2, 4
      end
    end

    context 'when specific track places are excluded' do
      before do
        generator.generate 1, 1, first_batch_time, 1, minutes_between_batches, skip_track_places: [2, 3]
      end

      it 'does not assign competitors to those track places' do
        expect(generator.errors).to eql []
        verify_competitor competitor1, 1, 1
        verify_competitor competitor2, 1, 4
        verify_competitor competitor3, 2, 1
        verify_competitor competitor4, 2, 4
      end
    end
  end

  def verify_batch(number, time, day=1, track=nil)
    batch = Batch.where('race_id=? AND number=?', race.id, number).first
    expect(batch.time.strftime('%H:%M')).to eql time
    expect(batch.day).to eql day
    if track
      expect(batch.track).to eql track
    else
      expect(batch.track).to be_nil
    end
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
