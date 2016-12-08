class Admin::UsersController < Admin::AdminController
  def index
    @is_admin_users = true
    @users = User.order("UPPER('last_name'), UPPER('first_name')")
  end
  
  def new
    @is_admin_new_user = true
    @user = User.new
  end
  
  def create
    @is_admin_new_user = true
    @user = User.new(user_params)
    @user.password_confirmation = @user.password
    if @user.save
      @user.add_official_rights
      NewUserMailer.from_admin(@user, login_url).deliver_now
      flash[:success] = 'Käyttäjä lisätty'
      redirect_to admin_users_path
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
