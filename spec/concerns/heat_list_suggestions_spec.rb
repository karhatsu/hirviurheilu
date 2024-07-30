require 'spec_helper'

describe HeatListSuggestions do
  describe 'generic' do
    let(:race) { create :race, shooting_place_count: 3, track_count: 1 }

    context 'when no heat lists' do
      it 'first_available_heat_number returns 1' do
        expect(race.first_available_heat_number(false)).to eql 1
      end

      it 'first_available_track_place returns 1' do
        expect(race.first_available_track_place(false)).to eql 1
      end

      it 'suggested next track number returns 1' do
        expect(race.suggested_next_track_number(false)).to eql 1
      end

      it 'suggested minutes is nil' do
        expect(race.suggested_min_between_heats(false)).to be_nil
      end

      it 'next heat time is nil' do
        expect(race.suggested_next_heat_time(false)).to be_nil
      end
    end

    context 'when only one qualification round heat' do
      let!(:heat) { create :qualification_round_heat, race: race, number: 1, track: 1, time: '10:15' }
      let(:series) { create :series, race: race }

      it 'final round suggestions return default values' do
        expect(race.first_available_heat_number(true)).to eql 1
        expect(race.first_available_track_place(true)).to eql 1
        expect(race.suggested_min_between_heats(true)).to be_nil
        expect(race.suggested_next_heat_time(true)).to be_nil
      end

      context 'and the last track place of it is available' do
        let!(:competitor_1_2) { create :competitor, series: series, qualification_round_heat: heat, qualification_round_track_place: 2 }

        it 'suggested next track number returns 1' do
          expect(race.suggested_next_track_number(false)).to eql 1
        end

        it 'suggested minutes is nil' do
          expect(race.suggested_min_between_heats(false)).to be_nil
        end

        it 'suggested heat time is the heat time' do
          expect(race.suggested_next_heat_time(false)).to eql '10:15'
        end
      end

      context 'and the last track place of it is reserved' do
        let!(:competitor_1_3) { create :competitor, series: series, qualification_round_heat: heat, qualification_round_track_place: 3 }

        it 'suggested next track number returns 1 (as only 1 track)' do
          expect(race.suggested_next_track_number(false)).to eql 1
        end

        it 'suggested minutes is nil' do
          expect(race.suggested_min_between_heats(false)).to be_nil
        end

        it 'suggested heat time is nil' do
          expect(race.suggested_next_heat_time(false)).to be_nil
        end
      end
    end

    context 'when more than one qualification round heat' do
      let(:heat1) { create :qualification_round_heat, race: race, number: 1, track: 1, time: '10:10' }
      let(:heat3) { create :qualification_round_heat, race: race, number: 3, track: 1, time: '10:35' }
      let(:series) { create :series, race: race }
      let!(:competitor_1_3) { create :competitor, series: series, qualification_round_heat: heat1, qualification_round_track_place: 3 }
      let!(:competitor_3_2) { create :competitor, series: series, qualification_round_heat: heat3, qualification_round_track_place: 2 }

      context 'and the heat with biggest number has no competitors at all' do
        let!(:heat5) { create :qualification_round_heat, race: race, number: 5, time: '11:00' }

        it 'first_available_heat_number returns the number of the biggest heat' do
          expect(race.first_available_heat_number(false)).to eql 5
        end

        it 'first_available_track_place returns 1' do
          expect(race.first_available_track_place(false)).to eql 1
        end

        it 'suggested minutes is the difference of the last two heat times' do
          expect(race.suggested_min_between_heats(false)).to eql 25
        end

        it 'next heat time is the last heat time' do
          expect(race.suggested_next_heat_time(false)).to eql '11:00'
        end
      end

      context 'and the heat with biggest number has shooting places available' do
        it 'first_available_heat_number returns the number of the biggest heat' do
          expect(race.first_available_heat_number(false)).to eql 3
        end

        it 'first_available_track_place returns biggest track place + 1' do
          expect(race.first_available_track_place(false)).to eql 3
        end

        it 'suggested minutes is the difference of the last two heat times' do
          expect(race.suggested_min_between_heats(false)).to eql 25
        end

        it 'next heat time is the last heat time' do
          expect(race.suggested_next_heat_time(false)).to eql '10:35'
        end
      end

      context 'and the heat with biggest number has competitor assigned to the last place' do
        let!(:competitor_3_3) { create :competitor, series: series, qualification_round_heat: heat3, qualification_round_track_place: 3 }

        it 'first_available_heat_number returns the number of the biggest heat + 1' do
          expect(race.first_available_heat_number(false)).to eql 4
        end

        it 'first_available_track_place returns 1' do
          expect(race.first_available_track_place(false)).to eql 1
        end

        it 'suggested minutes is the difference of the last two heat times' do
          expect(race.suggested_min_between_heats(false)).to eql 25
        end

        it 'next heat time is the last heat time + suggested minutes' do
          expect(race.suggested_next_heat_time(false)).to eql '11:00'
        end
      end

      context 'when shooting_place_count not defined for the race' do
        before do
          race.update_attribute :shooting_place_count, nil
        end

        it 'first_available_heat_number returns the number of the biggest heat' do
          expect(race.first_available_heat_number(false)).to eql 3
        end

        it 'first_available_track_place returns biggest track place + 1' do
          expect(race.first_available_track_place(false)).to eql 3
        end

        it 'suggested minutes is the difference of the last two heat times' do
          expect(race.suggested_min_between_heats(false)).to eql 25
        end

        it 'next heat time is the last heat time' do
          expect(race.suggested_next_heat_time(false)).to eql '10:35'
        end
      end

      context 'and two final round heats as well' do
        let(:heat3f) { create :final_round_heat, race: race, number: 3, time: '11:00' }
        let(:heat5f) { create :final_round_heat, race: race, number: 5, time: '11:30' }
        let!(:competitor_3f_3) { create :competitor, series: series, final_round_heat: heat3f, final_round_track_place: 3 }
        let!(:competitor_5f_1) { create :competitor, series: series, final_round_heat: heat5f, final_round_track_place: 1 }

        it 'first_available_heat_number for final round returns the number of the biggest heat' do
          expect(race.first_available_heat_number(true)).to eql 5
        end

        it 'first_available_track_place for final round returns biggest track place + 1' do
          expect(race.first_available_track_place(true)).to eql 2
        end

        it 'suggested minutes for final round is the difference of the last two heat times' do
          expect(race.suggested_min_between_heats(true)).to eql 30
        end

        it 'next heat time for qualification round is the last qualification round heat time' do
          expect(race.suggested_next_heat_time(false)).to eql '10:35'
        end

        it 'next heat time for final round is the last final round heat time' do
          expect(race.suggested_next_heat_time(true)).to eql '11:30'
        end
      end
    end

    context 'when one qualification round heat from the second day' do
      let(:race2) { create :race, start_date: '2020-02-15', end_date: '2020-02-16' }
      let!(:heat1) { create :qualification_round_heat, race: race2, number: 1, day: 1, time: '16:00' }
      let!(:heat2) { create :qualification_round_heat, race: race2, number: 2, day: 2, time: '10:00' }

      it 'suggested minutes is nil' do
        expect(race2.suggested_min_between_heats(false)).to be_nil
      end

      it 'next heat time suggestion is based on the second day heat' do
        expect(race2.suggested_next_heat_time(false)).to eql '10:00'
      end

      context 'and another heat from the second day' do
        let!(:heat3) { create :qualification_round_heat, race: race2, number: 3, day: 2, time: '10:15' }

        it 'suggested minutes is the difference of the last two second day heat times' do
          expect(race2.suggested_min_between_heats(false)).to eql 15
        end
      end
    end

    context 'when concurrent qualification round heats' do
      let(:race2) { create :race }
      let!(:heat1) { create :qualification_round_heat, race: race2, number: 1, track: 1, time: '10:00' }
      let!(:heat2) { create :qualification_round_heat, race: race2, number: 2, track: 2, time: '10:00' }
      let!(:heat3) { create :qualification_round_heat, race: race2, number: 3, track: 1, time: '10:30' }
      let!(:heat4) { create :qualification_round_heat, race: race2, number: 4, track: 2, time: '10:30' }

      it 'suggested minutes is calculated using the track number 1' do
        expect(race2.suggested_min_between_heats(false)).to eql 30
      end
    end

    context 'when latest heat is full' do
      let(:track_count) { 4 }
      let(:race2) { create :race, track_count: track_count, shooting_place_count: 2 }
      let(:series2) { create :series, race: race2 }
      let!(:heat1) { create :final_round_heat, race: race2, number: 7, track: 1, time: '10:00' }
      let!(:heat2) { create :final_round_heat, race: race2, number: 8, track: 1, time: '10:15' }
      let(:heat_last) { create :final_round_heat, race: race2, number: 10, track: last_heat_track, time: '10:30' }
      let!(:competitor1) { create :competitor, series: series2, final_round_heat: heat_last, final_round_track_place: 1 }
      let!(:competitor2) { create :competitor, series: series2, final_round_heat: heat_last, final_round_track_place: 2 }

      context 'and is not on the biggest track' do
        let(:last_heat_track) { track_count - 1 }

        it 'suggested next track number is the heat track + 1' do
          expect(race2.suggested_next_track_number(true)).to eql track_count
        end

        it 'suggested next heat time is the same as the last heat time' do
          expect(race2.suggested_next_heat_time(true)).to eql '10:30'
        end
      end

      context 'and is on the biggest track' do
        let(:last_heat_track) { track_count }

        it 'suggested next track number is 1' do
          expect(race2.suggested_next_track_number(true)).to eql 1
        end

        it 'suggested next heat time is incremented from the last heat time' do
          expect(race2.suggested_next_heat_time(true)).to eql '10:45'
        end
      end
    end

    context 'when latest heat is full and no track numbers are used' do
      let(:track_count) { 1 }
      let(:race2) { create :race, track_count: track_count, shooting_place_count: 2 }
      let(:series2) { create :series, race: race2 }
      let(:heat1) { create :qualification_round_heat, race: race2, number: 1, track: nil, time: '10:00' }
      let!(:competitor1) { create :competitor, series: series2, qualification_round_heat: heat1, qualification_round_track_place: 1 }
      let!(:competitor2) { create :competitor, series: series2, qualification_round_heat: heat1, qualification_round_track_place: 2 }

      it 'suggestions do not crash' do
        expect(race2.suggested_next_track_number(false)).to be_nil
        expect(race2.suggested_next_heat_time(false)).to be_nil
      end
    end
  end

  describe '#suggested_next_heat_day' do
    let(:race) { create :race, start_date: '2020-02-19', end_date: '2020-02-20' }

    context 'when no heats' do
      it 'is 1' do
        expect(race.suggested_next_heat_day(false)).to eql 1
      end
    end

    context 'when qualification round heats from the first day' do
      let!(:heat1) { create :qualification_round_heat, race: race, number: 1, day: 1, time: '15:00' }

      it 'is 1' do
        expect(race.suggested_next_heat_day(false)).to eql 1
      end

      context 'and final round heats from the second day' do
        let!(:heatf1) { create :final_round_heat, race: race, number: 1, day: 2, time: '09:00' }

        it 'is 1 for qualification round' do
          expect(race.suggested_next_heat_day(false)).to eql 1
        end

        it 'is 2 for final round' do
          expect(race.suggested_next_heat_day(true)).to eql 2
        end
      end

      context 'and qualification round heats also from the second day' do
        let!(:heat2) { create :qualification_round_heat, race: race, number: 2, day: 2, time: '10:00' }

        it 'is 2' do
          expect(race.suggested_next_heat_day(false)).to eql 2
        end
      end
    end
  end

  describe '#next_heat_number' do
    let(:race) { create :race }

    context 'when no heats' do
      it 'is 1' do
        expect(race.next_heat_number(false)).to eql 1
        expect(race.next_heat_number(true)).to eql 1
      end
    end

    context 'when heats' do
      let!(:heat5) { create :qualification_round_heat, race: race, number: 5 }
      let!(:heat7) { create :qualification_round_heat, race: race, number: 7 }

      it 'is the biggest number + 1' do
        expect(race.next_heat_number(false)).to eql 8
      end

      context 'and final round heats' do
        let!(:heatf1) { create :final_round_heat, race: race, number: 3 }

        it 'is the biggest qualification round heat number + 1' do
          expect(race.next_heat_number(false)).to eql 8
        end

        it 'is the biggest final round heat number + 1' do
          expect(race.next_heat_number(true)).to eql 4
        end
      end
    end
  end

  describe '#next_heat_time' do
    let(:race) { create :race, start_date: '2020-02-20', end_date: '2020-02-21' }
    let!(:heat1) { create :qualification_round_heat, race: race, number: 20, day: 2, time: '10:00' }
    let!(:heat2) { create :qualification_round_heat, race: race, number: 10, day: 2, time: '10:20' }
    let!(:heat3) { create :qualification_round_heat, race: race, number: 15, day: 1, time: '11:00' }
    let!(:heat1f) { create :final_round_heat, race: race, number: 1, day: 2, time: '09:00' }
    let!(:heat2f) { create :final_round_heat, race: race, number: 2, day: 2, time: '09:30' }

    context 'when cannot suggest minutes between qualification round heats' do
      before do
        expect(race).to receive(:suggested_min_between_heats).with(false).and_return(nil)
      end

      it 'is nil' do
        expect(race.next_heat_time(false)).to be_nil
      end
    end

    context 'when can suggest minutes between qualification round heats' do
      before do
        expect(race).to receive(:suggested_min_between_heats).with(false).and_return(15)
      end

      it 'biggest time (taking day into account) added with suggested minutes' do
        expect(race.next_heat_time(false)).to eql '10:35'
      end
    end

    context 'when can suggest minutes between final round heats' do
      before do
        expect(race).to receive(:suggested_min_between_heats).with(true).and_return(30)
      end

      it 'biggest time (taking day into account) added with suggested minutes' do
        expect(race.next_heat_time(true)).to eql '10:00'
      end
    end
  end
end
