class MediaController < ApplicationController
  before_filter :assign_race_by_race_id, :set_media, :set_competitors_count

  def new
  end

  def create
    if @competitors_count <= 0
      flash[:error] = 'Syötä kilpailijoiden määräksi positiivinen kokonaisluku'
      render :new
    else
      redirect_to race_medium_path(@race, :competitors_count => @competitors_count,
        :club_id => params[:club_id])
    end
  end

  def show
  end

  private
  def set_media
    @is_media = true
  end

  def set_competitors_count
    @competitors_count = (params[:competitors_count] || 3).to_i
  end
end
