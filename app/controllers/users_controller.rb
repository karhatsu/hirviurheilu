# encoding: UTF-8
class UsersController < ApplicationController
  before_action :no_account_changes_in_offline
  before_action :require_no_user, :only => [:new, :create]
  before_action :require_user, :only => [:show, :edit, :update]
  before_action :set_account, :only => [:show, :edit, :update]
  before_action :set_start, :only => [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.add_official_rights
      NewUserMailer.new_user(@user).deliver
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
    if @user.update(user_params)
      flash[:success] = t('users.update.account_updated')
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  private
  def no_account_changes_in_offline
    redirect_to official_root_path if offline?
  end

  def set_account
    @is_account = true
  end

  def set_start
    @is_start = true
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
