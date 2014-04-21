class VideosController < ApplicationController
  before_action :assign_race_by_race_id
  
  def show
    @is_races = true
    @is_video = true
  end
end