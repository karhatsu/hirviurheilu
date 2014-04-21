class RacesController < ApplicationController
  before_action :set_races
  before_action :assign_race_by_id, :only => :show

  def index
    @competitions = all_competitions_as_sorted
  end

  def show
    @is_race = true
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@race.name} - tulokset", :layout => true,
          :margin => pdf_margin, :header => pdf_header("#{@race.name} - Tuloskooste"), :footer => pdf_footer,
          :orientation => 'Landscape'
      end
    end
  end

  private
  def all_competitions_as_sorted
    all_cups = Cup.includes(:races)
    cup_races = Cup.cup_races(all_cups)
    (pick_non_cup_races(Race.all, cup_races) + all_cups).sort { |a,b| b.end_date <=> a.end_date }
  end

end
