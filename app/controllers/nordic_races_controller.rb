class NordicRacesController < ApplicationController
  before_action :assign_race_by_race_id, :set_races

  def trap
    @sub_sport = :trap
    render_page
  end

  def shotgun
    @sub_sport = :shotgun
    render_page
  end

  def rifle_moving
    @sub_sport = :rifle_moving
    render_page
  end

  def rifle_standing
    @sub_sport = :rifle_standing
    render_page
  end

  private

  def render_page
    respond_to do |format|
      format.html {
        render :show
      }
      format.pdf {
        render template: 'nordic_races/show', pdf: "#{@race.name}-#{@sub_sport}-tulokset", layout: true, margin: pdf_margin,
               header: pdf_header("#{@race.name} - #{I18n.t("sport_name.nordic_sub.#{@sub_sport}")}\n"), footer: pdf_footer,
               orientation: 'Portrait', disable_smart_shrinking: true
      }
    end
  end
end
