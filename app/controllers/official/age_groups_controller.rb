class Official::AgeGroupsController < Official::OfficialController
  before_filter :assign_series_by_series_id
  
  def index
    age_groups = @series.age_groups
    unless age_groups.empty? or @series.competitors_only_to_age_groups?
      age_groups.unshift(AgeGroup.new(:id => nil, :name => @series.name))
    end
    respond_to do |format|
      format.json { render :json => age_groups }
    end
  end
end
