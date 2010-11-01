class ResetPasswordsController < ApplicationController
  skip_before_filter :set_competitions
  before_filter :require_no_user

  def new
  end

  def create
    reset_hash = generate_hash
    user = User.find_by_email(params[:email])
    if user
      user.reset_hash = reset_hash
      user.save!
      ResetPasswordMailer.reset_mail(params[:email], reset_hash, site_url).deliver
      flash[:notice] = "Sähköpostiisi on lähetetty linkki, " +
        "jonka avulla voit asettaa uuden salasanan."
      redirect_to reset_password_path
    else
      flash[:error] = "Tuntematon sähköpostiosoite"
      render :new
    end
  end

  def show
  end

  def edit
    @reset_hash = params[:reset_hash]
    @hash_ok = true
    unless User.find_by_reset_hash(@reset_hash)
      flash[:error] = "Tuntematon tunnus. Varmista, että selaimen " +
        "osoiterivillä on täsmälleen se linkki, jonka sait sähköpostiisi."
      @hash_ok = false
    end
  end

  def update
    @reset_hash = params[:reset_hash]
    @hash_ok = true
    if params[:password].blank?
      flash[:error] = "Syötä uusi salasana"
      render :edit
      return
    end
    user = User.find_by_reset_hash(@reset_hash)
    if user
      user.password = params[:password]
      user.password_confirmation = params[:password_confirmation]
      if user.save
        flash[:notice] = "Salasana vaihdettu"
        redirect_to account_path
      else
        flash[:error] = user.errors.full_messages.join(". ") + "."
        render :edit
      end
    else
      @hash_ok = false
      flash[:error] = "Käyttäjää ei löytynyt"
      render :edit
    end
  end

  private
  def generate_hash
    SecureRandom.hex.downcase
  end
end
