class Official::CompetitorNumbersController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def index
    respond_to do |format|
      format.pdf do
        @competitors = @race.competitors.where('number > 0').except(:order).order(:number).includes(:club, :series, :qualification_round_batch)
        @a5 = params[:size] == 'a5'
        header = @a5 ? nil : pdf_header(@race.name)
        footer = @a5 ? nil : pdf_footer
        render pdf: "#{@race.name}-numerot", layout: true, margin: pdf_margin, header: header, footer: footer, disable_smart_shrinking: true
      end
    end
  end
end
