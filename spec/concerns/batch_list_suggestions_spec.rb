require 'spec_helper'

describe BatchListSuggestions do
  describe 'generic' do
    let(:race) { create :race, shooting_place_count: 3, track_count: 1 }

    context 'when no batch lists' do
      it 'first_available_batch_number returns 1' do
        expect(race.first_available_batch_number(false)).to eql 1
      end

      it 'first_available_track_place returns 1' do
        expect(race.first_available_track_place(false)).to eql 1
      end

      it 'suggested next track number returns 1' do
        expect(race.suggested_next_track_number(false)).to eql 1
      end

      it 'suggested minutes is nil' do
        expect(race.suggested_min_between_batches(false)).to be_nil
      end

      it 'next batch time is nil' do
        expect(race.suggested_next_batch_time(false)).to be_nil
      end
    end

    context 'when only one qualification round batch' do
      let!(:batch) { create :qualification_round_batch, race: race, number: 1, track: 1, time: '10:15' }
      let(:series) { create :series, race: race }

      it 'final round suggestions return default values' do
        expect(race.first_available_batch_number(true)).to eql 1
        expect(race.first_available_track_place(true)).to eql 1
        expect(race.suggested_min_between_batches(true)).to be_nil
        expect(race.suggested_next_batch_time(true)).to be_nil
      end

      context 'and the last track place of it is available' do
        let!(:competitor_1_2) { create :competitor, series: series, qualification_round_batch: batch, qualification_round_track_place: 2 }

        it 'suggested next track number returns 1' do
          expect(race.suggested_next_track_number(false)).to eql 1
        end

        it 'suggested minutes is nil' do
          expect(race.suggested_min_between_batches(false)).to be_nil
        end

        it 'suggested batch time is the batch time' do
          expect(race.suggested_next_batch_time(false)).to eql '10:15'
        end
      end

      context 'and the last track place of it is reserved' do
        let!(:competitor_1_3) { create :competitor, series: series, qualification_round_batch: batch, qualification_round_track_place: 3 }

        it 'suggested next track number returns 1 (as only 1 track)' do
          expect(race.suggested_next_track_number(false)).to eql 1
        end

        it 'suggested minutes is nil' do
          expect(race.suggested_min_between_batches(false)).to be_nil
        end

        it 'suggested batch time is nil' do
          expect(race.suggested_next_batch_time(false)).to be_nil
        end
      end
    end

    context 'when more than one qualification round batch' do
      let(:batch1) { create :qualification_round_batch, race: race, number: 1, track: 1, time: '10:10' }
      let(:batch3) { create :qualification_round_batch, race: race, number: 3, track: 1, time: '10:35' }
      let(:series) { create :series, race: race }
      let!(:competitor_1_3) { create :competitor, series: series, qualification_round_batch: batch1, qualification_round_track_place: 3 }
      let!(:competitor_3_2) { create :competitor, series: series, qualification_round_batch: batch3, qualification_round_track_place: 2 }

      context 'and the batch with biggest number has no competitors at all' do
        let!(:batch5) { create :qualification_round_batch, race: race, number: 5, time: '11:00' }

        it 'first_available_batch_number returns the number of the biggest batch' do
          expect(race.first_available_batch_number(false)).to eql 5
        end

        it 'first_available_track_place returns 1' do
          expect(race.first_available_track_place(false)).to eql 1
        end

        it 'suggested minutes is the difference of the last two batch times' do
          expect(race.suggested_min_between_batches(false)).to eql 25
        end

        it 'next batch time is the last batch time' do
          expect(race.suggested_next_batch_time(false)).to eql '11:00'
        end
      end

      context 'and the batch with biggest number has shooting places available' do
        it 'first_available_batch_number returns the number of the biggest batch' do
          expect(race.first_available_batch_number(false)).to eql 3
        end

        it 'first_available_track_place returns biggest track place + 1' do
          expect(race.first_available_track_place(false)).to eql 3
        end

        it 'suggested minutes is the difference of the last two batch times' do
          expect(race.suggested_min_between_batches(false)).to eql 25
        end

        it 'next batch time is the last batch time' do
          expect(race.suggested_next_batch_time(false)).to eql '10:35'
        end
      end

      context 'and the batch with biggest number has competitor assigned to the last place' do
        let!(:competitor_3_3) { create :competitor, series: series, qualification_round_batch: batch3, qualification_round_track_place: 3 }

        it 'first_available_batch_number returns the number of the biggest batch + 1' do
          expect(race.first_available_batch_number(false)).to eql 4
        end

        it 'first_available_track_place returns 1' do
          expect(race.first_available_track_place(false)).to eql 1
        end

        it 'suggested minutes is the difference of the last two batch times' do
          expect(race.suggested_min_between_batches(false)).to eql 25
        end

        it 'next batch time is the last batch time + suggested minutes' do
          expect(race.suggested_next_batch_time(false)).to eql '11:00'
        end
      end

      context 'when shooting_place_count not defined for the race' do
        before do
          race.update_attribute :shooting_place_count, nil
        end

        it 'first_available_batch_number returns the number of the biggest batch' do
          expect(race.first_available_batch_number(false)).to eql 3
        end

        it 'first_available_track_place returns biggest track place + 1' do
          expect(race.first_available_track_place(false)).to eql 3
        end

        it 'suggested minutes is the difference of the last two batch times' do
          expect(race.suggested_min_between_batches(false)).to eql 25
        end

        it 'next batch time is the last batch time' do
          expect(race.suggested_next_batch_time(false)).to eql '10:35'
        end
      end

      context 'and two final round batches as well' do
        let(:batch3f) { create :final_round_batch, race: race, number: 3, time: '11:00' }
        let(:batch5f) { create :final_round_batch, race: race, number: 5, time: '11:30' }
        let!(:competitor_3f_3) { create :competitor, series: series, final_round_batch: batch3f, final_round_track_place: 3 }
        let!(:competitor_5f_1) { create :competitor, series: series, final_round_batch: batch5f, final_round_track_place: 1 }

        it 'first_available_batch_number for final round returns the number of the biggest batch' do
          expect(race.first_available_batch_number(true)).to eql 5
        end

        it 'first_available_track_place for final round returns biggest track place + 1' do
          expect(race.first_available_track_place(true)).to eql 2
        end

        it 'suggested minutes for final round is the difference of the last two batch times' do
          expect(race.suggested_min_between_batches(true)).to eql 30
        end

        it 'next batch time for qualification round is the last qualification round batch time' do
          expect(race.suggested_next_batch_time(false)).to eql '10:35'
        end

        it 'next batch time for final round is the last final round batch time' do
          expect(race.suggested_next_batch_time(true)).to eql '11:30'
        end
      end
    end

    context 'when one qualification round batch from the second day' do
      let(:race2) { create :race, start_date: '2020-02-15', end_date: '2020-02-16' }
      let!(:batch1) { create :qualification_round_batch, race: race2, number: 1, day: 1, time: '16:00' }
      let!(:batch2) { create :qualification_round_batch, race: race2, number: 2, day: 2, time: '10:00' }

      it 'suggested minutes is nil' do
        expect(race2.suggested_min_between_batches(false)).to be_nil
      end

      it 'next batch time suggestion is based on the second day batch' do
        expect(race2.suggested_next_batch_time(false)).to eql '10:00'
      end

      context 'and another batch from the second day' do
        let!(:batch3) { create :qualification_round_batch, race: race2, number: 3, day: 2, time: '10:15' }

        it 'suggested minutes is the difference of the last two second day batch times' do
          expect(race2.suggested_min_between_batches(false)).to eql 15
        end
      end
    end

    context 'when concurrent qualification round batches' do
      let(:race2) { create :race }
      let!(:batch1) { create :qualification_round_batch, race: race2, number: 1, track: 1, time: '10:00' }
      let!(:batch2) { create :qualification_round_batch, race: race2, number: 2, track: 2, time: '10:00' }
      let!(:batch3) { create :qualification_round_batch, race: race2, number: 3, track: 1, time: '10:30' }
      let!(:batch4) { create :qualification_round_batch, race: race2, number: 4, track: 2, time: '10:30' }

      it 'suggested minutes is calculated using the track number 1' do
        expect(race2.suggested_min_between_batches(false)).to eql 30
      end
    end

    context 'when latest batch is full' do
      let(:track_count) { 4 }
      let(:race2) { create :race, track_count: track_count, shooting_place_count: 2 }
      let(:series2) { create :series, race: race2 }
      let!(:batch1) { create :final_round_batch, race: race2, number: 7, track: 1, time: '10:00' }
      let!(:batch2) { create :final_round_batch, race: race2, number: 8, track: 1, time: '10:15' }
      let(:batch_last) { create :final_round_batch, race: race2, number: 10, track: last_batch_track, time: '10:30' }
      let!(:competitor1) { create :competitor, series: series2, final_round_batch: batch_last, final_round_track_place: 1 }
      let!(:competitor2) { create :competitor, series: series2, final_round_batch: batch_last, final_round_track_place: 2 }

      context 'and is not on the biggest track' do
        let(:last_batch_track) { track_count - 1 }

        it 'suggested next track number is the batch track + 1' do
          expect(race2.suggested_next_track_number(true)).to eql track_count
        end

        it 'suggested next batch time is the same as the last batch time' do
          expect(race2.suggested_next_batch_time(true)).to eql '10:30'
        end
      end

      context 'and is on the biggest track' do
        let(:last_batch_track) { track_count }

        it 'suggested next track number is 1' do
          expect(race2.suggested_next_track_number(true)).to eql 1
        end

        it 'suggested next batch time is incremented from the last batch time' do
          expect(race2.suggested_next_batch_time(true)).to eql '10:45'
        end
      end
    end
  end

  describe '#suggested_next_batch_day' do
    let(:race) { create :race, start_date: '2020-02-19', end_date: '2020-02-20' }

    context 'when no batches' do
      it 'is 1' do
        expect(race.suggested_next_batch_day(false)).to eql 1
      end
    end

    context 'when qualification round batches from the first day' do
      let!(:batch1) { create :qualification_round_batch, race: race, number: 1, day: 1, time: '15:00' }

      it 'is 1' do
        expect(race.suggested_next_batch_day(false)).to eql 1
      end

      context 'and final round batches from the second day' do
        let!(:batchf1) { create :final_round_batch, race: race, number: 1, day: 2, time: '09:00' }

        it 'is 1 for qualification round' do
          expect(race.suggested_next_batch_day(false)).to eql 1
        end

        it 'is 2 for final round' do
          expect(race.suggested_next_batch_day(true)).to eql 2
        end
      end

      context 'and qualification round batches also from the second day' do
        let!(:batch2) { create :qualification_round_batch, race: race, number: 2, day: 2, time: '10:00' }

        it 'is 2' do
          expect(race.suggested_next_batch_day(false)).to eql 2
        end
      end
    end
  end

  describe '#next_batch_number' do
    let(:race) { create :race }

    context 'when no batches' do
      it 'is 1' do
        expect(race.next_batch_number(false)).to eql 1
        expect(race.next_batch_number(true)).to eql 1
      end
    end

    context 'when batches' do
      let!(:batch5) { create :qualification_round_batch, race: race, number: 5 }
      let!(:batch7) { create :qualification_round_batch, race: race, number: 7 }

      it 'is the biggest number + 1' do
        expect(race.next_batch_number(false)).to eql 8
      end

      context 'and final round batches' do
        let!(:batchf1) { create :final_round_batch, race: race, number: 3 }

        it 'is the biggest qualification round batch number + 1' do
          expect(race.next_batch_number(false)).to eql 8
        end

        it 'is the biggest final round batch number + 1' do
          expect(race.next_batch_number(true)).to eql 4
        end
      end
    end
  end

  describe '#next_batch_time' do
    let(:race) { create :race, start_date: '2020-02-20', end_date: '2020-02-21' }
    let!(:batch1) { create :qualification_round_batch, race: race, number: 20, day: 2, time: '10:00' }
    let!(:batch2) { create :qualification_round_batch, race: race, number: 10, day: 2, time: '10:20' }
    let!(:batch3) { create :qualification_round_batch, race: race, number: 15, day: 1, time: '11:00' }
    let!(:batch1f) { create :final_round_batch, race: race, number: 1, day: 2, time: '09:00' }
    let!(:batch2f) { create :final_round_batch, race: race, number: 2, day: 2, time: '09:30' }

    context 'when cannot suggest minutes between qualification round batches' do
      before do
        expect(race).to receive(:suggested_min_between_batches).with(false).and_return(nil)
      end

      it 'is nil' do
        expect(race.next_batch_time(false)).to be_nil
      end
    end

    context 'when can suggest minutes between qualification round batches' do
      before do
        expect(race).to receive(:suggested_min_between_batches).with(false).and_return(15)
      end

      it 'biggest time (taking day into account) added with suggested minutes' do
        expect(race.next_batch_time(false)).to eql '10:35'
      end
    end

    context 'when can suggest minutes between final round batches' do
      before do
        expect(race).to receive(:suggested_min_between_batches).with(true).and_return(30)
      end

      it 'biggest time (taking day into account) added with suggested minutes' do
        expect(race.next_batch_time(true)).to eql '10:00'
      end
    end
  end
end
