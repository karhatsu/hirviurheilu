class Api::V2::Public::RacesController < Api::V2::ApiBaseController
  def index
    if params[:grouped]
      @future = add_conditions Race.future
      @today = add_conditions Race.today
      @past = add_conditions Race.past
    else
      @races = Race.all
    end
  end

  def show
    @race = Race.where(id: params[:id]).includes(series: [:race, competitors: [:club, series: [:race]]]).first
    render status: 404, body: nil unless @race
  end

  private

  def add_conditions(races)
    sport_key = params[:sport_key]
    district_id = params[:district_id]
    level = params[:level]
    search_text = params[:search_text]
    time = params[:time]
    races = races.where(sport_key: sport_key) unless sport_key.blank?
    races = races.where(district_id: district_id) unless district_id.blank?
    races = races.where(level: level) unless level.blank?
    races = races.where('name ILIKE ? OR location ILIKE ?', "%#{search_text}%", "%#{search_text}%") unless search_text.blank?
    races = races.where('end_date < ?', Date.today) if time == 'past'
    races = races.where('start_date >= ?', Date.today) if time == 'future'
    races.limit(50)
  end
end
