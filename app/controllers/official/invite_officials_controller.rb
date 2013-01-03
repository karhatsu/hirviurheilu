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
        only_competitor_adding = params[:only_adding_competitors] == "1"
        user.add_race(@race, only_competitor_adding)
        send_invitation_mail only_competitor_adding, user
        flash[:success] = invitation_success_message(only_competitor_adding, user)
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
  
  def send_invitation_mail(only_competitor_adding, user)
    url = official_race_url(@race)
    if only_competitor_adding
      InviteOfficialMailer.invite_only_competitor_adding(@race, current_user, user, url).deliver
    else
      InviteOfficialMailer.invite(@race, current_user, user, url).deliver
    end
  end
  
  def invitation_success_message(only_competitor_adding, user)
    message = "Toimitsija #{user.first_name} #{user.
      last_name} lisätty kilpailun #{@race.name} toimitsijaksi"
    message += " rajoitetuin oikeuksin" if only_competitor_adding
    message
  end
end
