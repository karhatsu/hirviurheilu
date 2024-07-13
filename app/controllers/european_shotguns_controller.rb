class EuropeanShotgunsController < ApplicationController
  before_action :set_races

  def index
    @rifle = true
    use_react
    respond_to do |format|
      format.html { render layout: true, html: '' }
      format.pdf {
        assign_race_with_optional_series
        file_name = @series ? "#{@series.race.name}-#{@series.name}-luodikko-tulokset" : "#{@race.name}-luodikko-tulokset"
        title = @series ? "#{@series.race.name} - #{@series.name} - #{I18n.t('sport_name.european_sub.rifle')}" : "#{@race.name} - #{I18n.t('sport_name.european_sub.shotgun')}"
        @competitors = @series ? @series.european_shotgun_results : @race.european_shotgun_results
        render pdf: file_name, layout: true, margin: pdf_margin, header: pdf_header(title),
               footer: pdf_footer, orientation: 'Landscape', disable_smart_shrinking: true
      }
    end
  end
end
