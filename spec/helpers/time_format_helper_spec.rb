require 'spec_helper'

describe TimeFormatHelper do
  describe '#datetime_print' do
    before do
      @time = Time.local(2010, 5, 8, 9, 8, 1)
    end

    it 'should print empty string if nil given' do
      expect(helper.datetime_print(nil)).to eq('')
    end

    it 'should print d.m.Y as default format' do
      expect(helper.datetime_print(@time)).to eq('08.05.2010')
    end

    it 'should include hours and minutes if asked' do
      expect(helper.datetime_print(@time, true)).to eq('08.05.2010 09:08')
    end

    it 'should include hours, minutes and seconds if asked' do
      expect(helper.datetime_print(@time, true, true)).to eq('08.05.2010 09:08:01')
    end

    it 'should not print seconds if H/M not wanted and seconds wanted' do
      expect(helper.datetime_print(@time, false, true)).to eq('08.05.2010')
    end

    it 'should print given string instead of empty string if defined and nil' do
      expect(helper.datetime_print(nil, true, false, 'none')).to eq('none')
    end
  end

  describe '#series_start_time_print' do
    it 'should call datetime_print with series date and time' do
      series = instance_double(Series)
      datetime = 'some date time'
      allow(series).to receive(:start_datetime).and_return(datetime)
      expect(helper).to receive(:datetime_print).with(datetime, true).and_return('result')
      expect(helper.series_start_time_print(series)).to eq('result')
    end
  end

  describe '#relay_start_time_print' do
    it 'should print relay start date and time' do
      race = build :race, start_date: '2015-03-03'
      relay = build :relay, race: race, start_day: 2, start_time: '12:30'
      expect(helper.relay_start_time_print(relay)).to eq('04.03.2015 12:30')
    end
  end

  describe '#date_print' do
    it 'should return DD.MM.YYYY' do
      time = Time.local(2010, 5, 8, 9, 8, 1)
      expect(helper.date_print(time)).to eq('08.05.2010')
    end
  end

  describe '#time_print' do
    before do
      @time = Time.local(2010, 5, 8, 9, 8, 1)
    end

    it 'should print empty string if nil given' do
      expect(helper.time_print(nil)).to eq('')
    end

    it 'should print HH:MM as default format' do
      expect(helper.time_print(@time)).to eq('09:08')
    end

    it 'should include seconds if asked' do
      expect(helper.time_print(@time, true)).to eq('09:08:01')
    end

    it 'should print given string instead of empty string if defined and nil' do
      expect(helper.time_print(nil, true, 'none')).to eq('none')
    end

    it 'should print given string as raw instead of empty string if defined and nil' do
      expect(helper.time_print(nil, true, '&nbsp;')).to eq('&nbsp;')
    end
  end

  describe '#time_from_seconds' do
    it 'should return dash when nil given' do
      expect(helper.time_from_seconds(nil)).to eq('-')
    end

    it 'should return seconds when less than 60' do
      expect(helper.time_from_seconds(59)).to eq('00:59')
    end

    it 'should return minutes and seconds when more than 60' do
      expect(helper.time_from_seconds(60)).to eq('01:00')
      expect(helper.time_from_seconds(61)).to eq('01:01')
      expect(helper.time_from_seconds(131)).to eq('02:11')
    end

    it 'should return hours, minutes and seconds when at least 1 hour' do
      expect(helper.time_from_seconds(3600)).to eq('1:00:00')
      expect(helper.time_from_seconds(3601)).to eq('1:00:01')
    end

    it 'should convert decimal seconds to integer' do
      expect(helper.time_from_seconds(60.0)).to eq('01:00')
      expect(helper.time_from_seconds(61.1)).to eq('01:01')
      expect(helper.time_from_seconds(131.2)).to eq('02:11')
      expect(helper.time_from_seconds(3601.6)).to eq('1:00:01')
    end

    it 'should return negative hours, minutes and seconds when at least 1 hour' do
      expect(helper.time_from_seconds(-3600)).to eq('-1:00:00')
      expect(helper.time_from_seconds(-3601)).to eq('-1:00:01')
    end
    it 'should return hours, minutes and seconds with minus or plus sign when always signed' do
      expect(helper.time_from_seconds(3600, true)).to eq('+1:00:00')
      expect(helper.time_from_seconds(3601, true)).to eq('+1:00:01')
      expect(helper.time_from_seconds(-3601, true)).to eq('-1:00:01')
    end
  end

  describe '#date_interval' do
    it 'should print start - end when dates differ' do
      expect(helper.date_interval('2010-08-01'.to_date, '2010-08-03'.to_date, false)).
          to eq('01.08.2010 - 03.08.2010')
    end

    it 'should print only start date when end date is same' do
      expect(helper.date_interval('2010-08-03'.to_date, '2010-08-03'.to_date, false)).
          to eq('03.08.2010')
    end

    it 'should print only start date when end date is nil' do
      expect(helper.date_interval('2010-08-03'.to_date, nil, false)).to eq('03.08.2010')
    end

    it 'should include time tag if it is wanted' do
      expect(helper.date_interval('2015-01-18'.to_date, nil)).to eq("<time itemprop='startDate' datetime='2015-01-18'>18.01.2015</time>")
    end
  end

  describe '#race_date_interval' do
    it 'should call date_interval with race dates' do
      race = build(:race)
      expect(helper).to receive(:date_interval).with(race.start_date, race.end_date, true).
                            and_return('result')
      expect(helper.race_date_interval(race)).to eq('result')
    end
  end
end