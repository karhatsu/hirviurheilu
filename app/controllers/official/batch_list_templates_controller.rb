class Official::BatchListTemplatesController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :check_competitors_per_batch

  def show
    respond_to do |format|
      format.pdf do
        render pdf: "#{@race.name}-template", layout: true,
               margin: pdf_margin, header: pdf_header("#{t :batch_list} - #{@race.name}"),
               footer: pdf_footer, disable_smart_shrinking: true
      end
    end
  end

  private

  def check_competitors_per_batch
    unless @race.competitors_per_batch
      @error = t '.show.competitors_per_batch_missing'
      render 'official/shared/pdf_error'
    end
  end
end
