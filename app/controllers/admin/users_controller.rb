class Admin::UsersController < Admin::AdminController
  before_filter :set_admin_users

  active_scaffold :users do |config|
    config.columns = [:first_name, :last_name, :email, :activation_key, :roles, :races,
      :last_request_at, :last_login_at, :last_login_ip, :current_login_at,
      :current_login_ip
    ]
  end

  private
  def set_admin_users
    @is_admin_users = true
  end
end
