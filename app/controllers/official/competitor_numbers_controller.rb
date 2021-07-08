class Official::CompetitorNumbersController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def index
    respond_to do |format|
      format.pdf do
        @competitors = @race.competitors.except(:order).order(:number).includes(:club, :series, :qualification_round_batch)
        render pdf: "#{@race.name}-numerot", layout: true,
               margin: pdf_margin, header: pdf_header(@race.name),
               footer: pdf_footer, disable_smart_shrinking: true
      end
    end
  end
end
