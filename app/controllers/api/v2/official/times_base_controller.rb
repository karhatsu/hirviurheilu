class Api::V2::Official::TimesBaseController < Api::V2::Official::OfficialApiBaseController
  before_action :find_and_validate_race

  def update
    return render status: 404, json: { errors: ['competitor not found'] } unless competitor
    return render status: 400, json: { errors: ['ms_since_midnight missing'] } unless ms_since_midnight
    return render status: 400, json: { errors: ['ms_since_midnight cannot be before race start'] } if ms_before_race_start
    competitor[time_field] = resolve_competitor_time
    if competitor.save
      real_time = competitor.real_time(time_field).strftime('%H:%M:%S')
      relative_time = competitor[time_field].strftime('%H:%M:%S')
      render status: 200, json: { real_time: real_time, relative_time: relative_time }
    else
      render status: 400, json: { errors: competitor.errors.full_messages }
    end
  end

  private

  def competitor
    @competitor ||= @race.competitors.where(number: params[:competitor_number]).first
  end

  def ms_before_race_start
    ms_since_midnight < 1000 * (60 * 60 * @race.start_time.hour + 60 * @race.start_time.min)
  end

  def resolve_competitor_time
    secs_since_midnight = ms_since_midnight / 1000
    race_advance = {hours: -@race.start_time.hour, minutes: -@race.start_time.min}
    ((Time.now.beginning_of_day + secs_since_midnight.seconds).advance(race_advance)).strftime('%H:%M:%S')
  end

  def ms_since_midnight
    params[:ms_since_midnight]
  end
end
