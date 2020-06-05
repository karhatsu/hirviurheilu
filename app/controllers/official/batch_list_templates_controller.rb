class Official::BatchListTemplatesController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def show
    respond_to do |format|
      format.pdf do
        render pdf: "#{@race.name}-template", layout: true,
               margin: pdf_margin, header: pdf_header("#{t :batch_list} - #{@race.name}"),
               footer: pdf_footer, disable_smart_shrinking: true
      end
    end
  end
end
