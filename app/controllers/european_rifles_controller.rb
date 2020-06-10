class EuropeanRiflesController < ApplicationController
  before_action :assign_series_by_series_id, :set_races

  def index
    @rifle = true
    respond_to do |format|
      format.html
      format.pdf {
        render pdf: "#{@series.race.name}-#{@series.name}-luodikko-tulokset", layout: true, margin: pdf_margin,
               header: pdf_header("#{@series.race.name} - #{@series.name} - #{I18n.t('sport_name.european_sub.rifle')}\n"),
               footer: pdf_footer, orientation: 'Portrait', disable_smart_shrinking: true
      }
    end
  end
end
