class Official::AgeGroupsController < Official::OfficialController
  before_filter :assign_series_by_series_id
  
  def index
    respond_to do |format|
      format.json { render :json => @series.age_groups_with_main_series }
    end
  end
end
