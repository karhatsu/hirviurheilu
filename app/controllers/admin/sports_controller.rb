class Admin::SportsController < Admin::AdminController
  before_filter :set_admin_sports

  active_scaffold :sport

  private
  def set_admin_sports
    @is_admin_sports = true
  end
end
