class Api::V2::Official::RelayArrivalTimesController < Api::V2::Official::OfficialApiBaseController
  before_action :find_and_validate_race

  def update
    @relay = @race.relays.where(id: params[:relay_id]).first
    return render status: 404, json: { errors: ['relay not found'] } unless @relay
    return render status: 400, json: { errors: ['cannot use api for relay that has no start time'] } unless @relay.start_time
    @relay_team = @relay.relay_teams.where(number: params[:team_number]).first
    return render status: 404, json: { errors: ['relay team not found'] } unless @relay_team
    leg = params[:leg].to_i
    return render status: 400, json: { errors: ['invalid leg number'] } if leg <= 0 || leg > @relay.legs_count
    @ms_since_midnight = params[:ms_since_midnight]
    return render status: 400, json: { errors: ['ms_since_midnight missing'] } unless @ms_since_midnight
    return render status: 400, json: { errors: ['ms_since_midnight cannot be before relay start'] } if ms_before_relay_start
    relay_competitor = @relay_team.relay_competitors.where(leg: leg).first
    return render status: 404, json: { errors: ['relay competitor not found'] } unless relay_competitor
    relay_competitor.arrival_time = resolve_competitor_time
    if relay_competitor.save
      relative_time = relay_competitor.arrival_time.strftime('%H:%M:%S')
      render status: 200, json: { relative_time: relative_time }
    else
      render status: 400, json: { errors: relay_competitor.errors.full_messages }
    end
  end

  private

  def ms_before_relay_start
    @ms_since_midnight < 1000 * (60 * 60 * @relay.start_time.hour + 60 * @relay.start_time.min)
  end

  def resolve_competitor_time
    secs_since_midnight = @ms_since_midnight / 1000
    relay_advance = {hours: -@relay.start_time.hour, minutes: -@relay.start_time.min}
    ((Time.now.beginning_of_day + secs_since_midnight.seconds).advance(relay_advance)).strftime('%H:%M:%S')
  end
end
