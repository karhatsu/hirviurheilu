class HeatsController < ApplicationController
  before_action :assign_race_by_race_id

  def index
    use_react
    respond_to do |format|
      format.html { render layout: true, html: '' }
      format.pdf do
        render pdf: "#{@race.name}-eraluettelo", layout: true,
               margin: pdf_margin, header: pdf_header("#{t :heat_list} - #{@race.name} - #{I18n.t("sport_name.#{@race.sport_key}")}"),
               footer: pdf_footer, disable_smart_shrinking: true
      end
    end
  end
end
