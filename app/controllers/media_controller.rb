class MediaController < ApplicationController
  before_filter :assign_race_by_race_id, :set_media

  def index
    @competitors_count = (params[:competitors_count] || 3).to_i
    @show_results = params[:results]
    if @show_results and @competitors_count <= 0
      flash[:error] = 'Syötä kilpailijoiden määräksi positiivinen kokonaisluku'
    end
  end

  private
  def set_media
    @is_media = true
  end
end
