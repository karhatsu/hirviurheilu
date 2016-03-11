require 'spec_helper'

describe HomeHelper do
  describe '#group_future_races' do
    before do
      allow(Date).to receive(:today).and_return(Date.new(2016, 2, 1)) # Mon
      allow(Date).to receive(:tomorrow).and_return(Date.new(2016, 2, 2))
    end

    describe 'when no races' do
      it 'returns empty hash' do
        expect(helper.group_future_races([])).to eql({})
      end
    end

    describe 'when one race' do
      it 'allocates it to correct group and returns only that group' do
        race_day_after_tomorrow = create_race 2
        expect(helper.group_future_races([race_day_after_tomorrow])).to eql({day_after_tomorrow: [race_day_after_tomorrow]})
      end
    end

    describe 'when races' do
      before do
        @race_today = create_race 0
        @race_2_days_starts_today = create_race 0, 1
        @race_2_days_ends_today = create_race -1, 0
        @race_tomorrow = create_race 1
        @race_day_after_tomorrow = create_race 2
        @race_this_week_sunday = create_race 6
        @race_next_week_monday = create_race 7
        @race_next_week_sunday = create_race 13
        @race_monday_in_two_weeks = create_race 14
        @race_this_month_last_day = create_race 28
        @race_next_month_first_day = create_race 29
        @race_next_month_last_day = create_race 59
        @race_two_months_first_day = create_race 60
        @race_next_year = create_race 400
      end

      it 'allocates them to correct groups' do
        races = [@race_today, @race_2_days_starts_today, @race_2_days_ends_today, @race_tomorrow,
                 @race_day_after_tomorrow, @race_this_week_sunday, @race_next_week_monday, @race_next_week_sunday,
                 @race_monday_in_two_weeks, @race_this_month_last_day, @race_next_month_first_day,
                 @race_next_month_last_day, @race_two_months_first_day, @race_next_year]
        expected = {
            today: [@race_today, @race_2_days_starts_today, @race_2_days_ends_today],
            tomorrow: [@race_tomorrow],
            day_after_tomorrow: [@race_day_after_tomorrow],
            this_week: [@race_this_week_sunday],
            next_week: [@race_next_week_monday, @race_next_week_sunday],
            this_month: [@race_monday_in_two_weeks, @race_this_month_last_day],
            next_month: [@race_next_month_first_day, @race_next_month_last_day],
            later: [@race_two_months_first_day, @race_next_year]
        }
        expect(helper.group_future_races(races)).to eql(expected)
      end
    end

    def create_race(start_day_offset, end_day_offset=nil)
      end_date = end_day_offset ? Date.today + end_day_offset.days : nil
      double Race, start_date: Date.today + start_day_offset.days, end_date: end_date
    end
  end
end