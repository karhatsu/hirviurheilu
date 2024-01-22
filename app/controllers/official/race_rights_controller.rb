class Official::RaceRightsController < Official::OfficialController
  before_action :assign_race_by_race_id, :check_assigned_race, :set_race_rights

  def index
    @race_rights = @race.race_rights
    respond_to do |format|
      format.html do
        use_react true
        render layout: true, html: ''
      end
      format.json
    end
  end

  def create
    @race_right = @race.race_rights.build race_rights_params
    user = User.where('lower(email)=?', params[:email].downcase).first
    if !user
      render status: 400, json: { errors: ['Tietokannasta ei löytynyt syöttämääsi sähköpostiosoitetta'] }
    elsif user.races.include? @race
      render status: 400, json: { errors: ['Henkilö on jo tämän kilpailun toimitsija'] }
    else
      @race_right.user = user
      @race_right.save!
      send_invitation_mail @race_right
    end
  end

  def multiple
    @race_rights = []
    @errors = []
    params[:officials].each do |official|
      email = official[:email].strip
      user = find_user email
      @errors << "#{email} ei ole rekisteröitynyt Hirviurheiluun" unless user
    end
    return unless @errors.empty?

    RaceRight.transaction do
      params[:officials].each do |official|
        email = official[:email].strip
        user = find_user email
        unless user.races.include? @race
          race_right = @race.race_rights.build
          race_right.user = user
          club = find_or_create_club official[:club]&.strip
          if club
            race_right.club = club
            race_right.only_add_competitors = true
          end
          race_right.save!
          @race_rights << race_right
        end
      end
      @race_rights.each do |race_right|
        send_invitation_mail race_right
      end
    rescue => e
      @errors << "Odottamaton virhe: #{e.message}"
      @race_rights = []
    end
  end

  def update
    @race_right = @race.race_rights.find params[:id]
    @race_right.update(race_rights_params)
  end

  def destroy
    race_right = @race.race_rights.find params[:id]
    race_right.destroy
    render status: 201, body: nil
  end

  private
  def set_race_rights
    @is_race_rights = true
  end

  def send_invitation_mail(race_right)
    user = race_right.user
    if race_right.only_add_competitors
      InviteOfficialMailer.invite_only_competitor_adding(@race, current_user, user).deliver_now
    else
      InviteOfficialMailer.invite(@race, current_user, user).deliver_now
    end
  end

  def race_rights_params
    params.require(:race_right).permit(:only_add_competitors, :club_id, :new_clubs)
  end

  def find_user(email)
    User.where('LOWER(email)=?', email.downcase).first
  end

  def find_or_create_club(club_name)
    return nil unless club_name
    club = @race.clubs.where('lower(name)=?', club_name.downcase).first
    club = @race.clubs.create name: club_name unless club
    club
  end
end
