class Official::OfficialController < ApplicationController
  before_filter :require_user, :check_rights

  protected
  def check_rights
    redirect_to root_path unless current_user.official? or current_user.admin?
  end

  def check_race(race)
    unless current_user.admin? or current_user.official_for_race?(race)
      flash[:error] = "Et ole kilpailun toimitsija"
      redirect_to official_root_path
    end
  end
end
