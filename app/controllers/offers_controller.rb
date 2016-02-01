class OffersController < ApplicationController
  before_action :set_menu_selection, :set_variant

  def new
  end

  def create
    FeedbackMailer.offer_mail(params[:name], params[:email], params[:tel], params[:club], params[:competition_info], current_user).deliver_now
    redirect_to offer_sent_path
  end

  def sent
  end

  private

  def set_menu_selection
    @is_prices = true
    @is_ask_for_offer = true
  end
end