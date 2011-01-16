class UsersController < ApplicationController
  skip_before_filter :set_competitions
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :set_account, :only => [:show, :edit, :update]
  before_filter :set_start, :only => [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.add_official_rights
      NewUserMailer.new_user(@user).deliver
      flash[:success] = "Käyttäjätili luotu. " +
        "Pääset syöttämään kilpailun tietoja Toimitsijan sivut -linkistä."
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
    if @user.update_attributes(params[:user])
      flash[:success] = "Käyttäjätili päivitetty"
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
end
