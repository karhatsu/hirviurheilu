class UsersController < ApplicationController
  before_action :require_no_user, :only => [:new, :create]
  before_action :require_user, :only => [:show, :edit, :update]
  before_action :set_account, :only => [:show, :edit, :update]
  before_action :set_start, :only => [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(new_user_params)
    @captcha = params[:captcha]&.strip
    unless @captcha && %w[neljä fyra].include?(@captcha.downcase)
      flash[:error] = t(:wrong_captcha)
      return render :new
    end
    if @user.save
      @user.add_official_rights
      Race.where('pending_official_email=?', @user.email).each do |race|
        race.users << @user
        race.pending_official_email = nil
        race.save
      end
      NewUserMailer.new_user(@user).deliver_now
      flash[:success] = t('users.create.account_created')
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user
    if @user.update(old_user_params)
      flash[:success] = t('users.update.account_updated')
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  private

  def set_account
    @is_account = true
  end

  def set_start
    @is_start = true
  end

  def new_user_params
    params.require(:user).permit(:first_name, :last_name, :club_name, :email, :password, :password_confirmation)
  end

  def old_user_params
    params.require(:user).permit(:first_name, :last_name, :club_name, :email)
  end
end
