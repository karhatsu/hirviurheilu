class Official::EuropeanBatchListsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race

  def trap
    @sub_sport = :trap
    @time = :time
    render_pdf
  end

  def compak
    @sub_sport = :compak
    @time = :time2
    render_pdf
  end

  def rifle
    @sub_sport = :rifle
    @time = :time3
    render_pdf
  end

  private

  def render_pdf
    @batches = @race.batches.includes(competitors: [:club, :series])
    respond_to do |format|
      format.pdf do
        header = "#{t :batch_list} - #{@race.name} - #{t "sport_name.european_sub.#{@sub_sport}"}"
        orientation = @sub_sport == :rifle ? 'Landscape' : 'Portrait'
        render pdf: "#{@race.name}-eraluettelo", layout: true, template: 'official/european_batch_lists/index',
               orientation: orientation, margin: pdf_margin, header: pdf_header(header),
               footer: pdf_footer, disable_smart_shrinking: true
      end
    end
  end
end
