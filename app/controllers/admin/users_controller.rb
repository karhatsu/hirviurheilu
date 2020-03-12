class Admin::UsersController < Admin::AdminController
  def index
    @is_admin_users = true
    find_users
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
      NewUserMailer.from_admin(@user).deliver_now
      flash[:success] = 'Käyttäjä lisätty'
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def destroy
    @user = User.find params[:id]
    if @user.races.empty?
      @user.destroy
      redirect_to admin_users_path
    else
      flash[:error] = 'Käyttäjää ei voida poistaa, koska hänellä on kilpailuja'
      find_users
      render :index
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :club_name, :email, :password)
  end

  def find_users
    @users = User.order(Arel.sql("UPPER(last_name), UPPER(first_name)"))
  end
end
