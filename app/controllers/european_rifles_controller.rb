class EuropeanRiflesController < ApplicationController
  before_action :assign_series_by_series_id, :set_races

  def index
    @rifle = true
    use_react
    respond_to do |format|
      format.html { render layout: true, html: '' }
      format.pdf {
        render pdf: "#{@series.race.name}-#{@series.name}-luodikko-tulokset", layout: true, margin: pdf_margin,
               header: pdf_header("#{@series.race.name} - #{@series.name} - #{I18n.t('sport_name.european_sub.rifle')}\n"),
               footer: pdf_footer, orientation: 'Landscape', disable_smart_shrinking: true
      }
    end
  end
end
