class BatchListsController < ApplicationController
  before_action :assign_race_by_race_id, :set_menu

  def show
    @batches = @race.batches.includes(competitors: [:club, :series])
  end

  private

  def set_menu
    @is_races = true
    @is_batch_list = true
  end
end
