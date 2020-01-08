class BatchListsController < ApplicationController
  before_action :assign_race_by_race_id, :set_menu

  def show
    @batches = @race.batches.includes(competitors: [:club, :series])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@race.name}-eraluettelo", layout: true,
               margin: pdf_margin, header: pdf_header("#{t :batch_list} - #{@race.name}"),
               footer: pdf_footer, disable_smart_shrinking: true
      end
    end
  end

  private

  def set_menu
    @is_races = true
    @is_batch_list = true
  end
end
