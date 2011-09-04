class Admin::UsersController < Admin::AdminController
  before_filter :set_admin_users

  def index
    @users = User.order(:last_name, :first_name)
  end

  private
  def set_admin_users
    @is_admin_users = true
  end
end
