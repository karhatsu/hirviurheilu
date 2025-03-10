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
    return unless verify_series
    use_react
    respond_to do |format|
      format.html { render layout: true, html: '' }
      format.pdf {
        render template: 'nordic_races/show', pdf: "#{@race.name}-#{@sub_sport}-tulokset", layout: true, margin: pdf_margin,
               header: pdf_header("#{@race.name} - #{I18n.t("sport_name.nordic_sub.#{@sub_sport}")}\n"), footer: pdf_footer,
               orientation: 'Portrait', disable_smart_shrinking: true
      }
    end
  end

  def verify_series
    if @race.nordic_sub_results_for_series? && !params[:series_id]
      redirect_to "/races/#{@race.id}/series/#{@race.series.first.id}/#{@sub_sport}"
      return false
    elsif !@race.nordic_sub_results_for_series? && params[:series_id]
      redirect_to "/races/#{@race.id}/#{@sub_sport}"
      return false
    elsif @race.nordic_sub_results_for_series? && params[:series_id]
      @series = @race.series.where(id: params[:series_id]).first
      unless @series
        redirect_to "/races/#{@race.id}"
        return false
      end
    end
    true
  end
end
