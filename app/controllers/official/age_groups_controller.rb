class Official::AgeGroupsController < Official::OfficialController
  before_filter :assign_series_by_series_id
  
  def index
    age_groups = @series.age_groups
    age_groups.unshift(AgeGroup.new(:id => nil, :name => @series.name)) unless age_groups.empty?
    respond_to do |format|
      format.json { render :json => age_groups }
    end
  end
end
