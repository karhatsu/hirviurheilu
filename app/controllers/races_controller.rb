class RacesController < ApplicationController
  before_action :set_races
  before_action :build_sports_menu_options, only: :index
  before_action :assign_race_by_id, :only => :show

  def index
    sport_key = params[:sport_key]
    district_id = params[:district_id]
    search_text = params[:search_text]
    @races = Race.all
    @races = @races.where(sport_key: sport_key) unless sport_key.blank?
    @races = @races.where(district_id: district_id) unless district_id.blank?
    @races = @races.where('name ILIKE ? OR location ILIKE ?', "%#{search_text}%", "%#{search_text}%") unless search_text.blank?
    @races = @races.page(params[:page])
  end

  def show
    @is_race = true
    respond_to do |format|
      format.html
      format.pdf do
        @page_breaks = params[:page_breaks]
        orientation = @race.sport.only_shooting? ? 'Portrait' : 'Landscape'
        render pdf: "#{@race.name} - tulokset", layout: true,
               margin: pdf_margin, header: pdf_header("#{@race.name} - Tuloskooste"), footer: pdf_footer,
               orientation: orientation, disable_smart_shrinking: true
      end
    end
  end

end
