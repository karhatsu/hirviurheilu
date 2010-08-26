class Admin::UsersController < Admin::AdminController
  active_scaffold :users do |config|
    config.columns = [:first_name, :last_name, :email, :roles, :races,
      :last_request_at, :last_login_at, :last_login_ip, :current_login_at,
      :current_login_ip
    ]
  end
end
