class Admin::VideosController < Admin::AdminController
  before_filter :assign_race_by_race_id
  
  def show
  end
end