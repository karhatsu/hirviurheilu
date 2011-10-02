# encoding: UTF-8
class Official::InviteOfficialsController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race, :set_clubs

  def index
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      if user.races.include?(@race)
        flash[:error] = "Henkilö on jo tämän kilpailun toimitsija"
        render :index
      else
        user.races << @race
        InviteOfficialMailer.invite(@race, current_user, user, site_url).deliver
        flash[:success] = "Toimitsija #{user.first_name} #{user.
          last_name} lisätty kilpailun #{@race.name} toimitsijaksi"
        redirect_to official_race_invite_officials_path(@race)
      end
    else
      flash[:error] = "Tietokannasta ei löytynyt syöttämääsi sähköpostiosoitetta"
      render :index
    end
  end

  private
  def set_clubs
    @is_officials = true
  end
end
