class RemoteRacesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_user
  after_filter :set_series_for_team_competitions,
    :set_age_groups_for_team_competitions, :set_age_groups_for_competitors

  def create
    success = false
    Race.transaction do
      return unless prepare_clubs_for_competitors
      if @race.save
        @race.race_rights.create!(:user => @user)
        unless offline_or_fake_offline?
          PublishMailer.publish_mail(@race, @user).deliver_now
        end
        success = true
      end
    end
    if success
      redirect_to_success
    else
      redirect_to_error @race.errors.full_messages.join('. ') + '.'
    end
  end

  private
  def check_user
    if offline_or_fake_offline?
      @user = User.first
    else
      @user = User.find_by_email(params[:email])
      unless @user and @user.valid_password?(params[:password])
        redirect_to_error "Virheelliset tunnukset. " +
          "Varmista että olet syöttänyt palvelun #{params[:server]} tunnukset."
      end
    end
  end

  def offline_or_fake_offline?
    # this hack is for cucumber features
    (offline? and !Rails.env.test?) or (online? and Rails.env.test?)
  end

  def prepare_clubs_for_competitors
    if save_race_without_children # in order to get an id for the race
      include_children_to_saved_race
      club_names_ids = save_clubs
      set_club_ids_for_competitors(club_names_ids)
    end
  end

  def save_race_without_children
    @race = Race.new(Race.new(race_params).attributes) # no children in @race
    @race.billing_info = 'Offline' unless offline_or_fake_offline?
    unless @race.save
      redirect_to_error @race.errors.full_messages.join('. ') + '.'
      return false
    end
    true
  end

  def include_children_to_saved_race
    @race.attributes = race_params
  end

  def save_clubs
    club_names_ids = Hash.new
    @race.clubs.each do |club|
      unless club_names_ids.has_key?(club.name)
        club.race_id = @race.id
        club.save!
        club_names_ids[club.name] = club.id
      end
    end
    club_names_ids
  end

  def set_club_ids_for_competitors(club_names_ids)
    @race.series.each do |series|
      series.competitors.each do |competitor|
        competitor.club_id = club_names_ids[competitor.club_name]
      end
    end
  end

  def set_age_groups_for_competitors
    @race.series.each do |series|
      series.competitors.each do |competitor|
        if competitor.age_group_name
          competitor.age_group = series.age_groups.find_by_name(competitor.age_group_name)
          competitor.save!
        end
      end
    end
  end

  def set_series_for_team_competitions
    @race.team_competitions.each do |tc|
      tc.attach_series_by_names tc.temp_series_names
    end
  end

  def set_age_groups_for_team_competitions
    @race.team_competitions.each do |tc|
      tc.attach_age_groups_by_names tc.temp_age_groups_names
    end
  end

  def redirect_to_success
    redirect_to "#{params[:source]}/official/races/#{params[:source_race_id]}/export/success"
  end

  def redirect_to_error(message)
    path = "#{params[:source]}/official/races/#{params[:source_race_id]}/export/error?" +
        "message=#{CGI::escape(message)}"
    path << "&server=#{CGI::escape(params[:server])}" if params[:server]
    path << "&email=#{CGI::escape(params[:email])}" if params[:email]
    redirect_to path
  end

  def race_params
    params.require(:race).permit(:sport_id, :name, :location, :start_date, :end_date, :start_interval_seconds,
      :finished, :home_page, :batch_size, :batch_interval_seconds, :club_level, :start_order, :video_source,
      :video_description, :organizer, :organizer_phone, :start_time, :public_message, :api_secret,
      clubs_attributes: [:id, :name, :long_name],
      correct_estimates_attributes: [:id, :min_number, :max_number, :distance1, :distance2, :distance3, :distance4],
      series_attributes: [:id, :name, :start_time, :first_number, :has_start_list, :start_day, :estimates, :national_record, :time_points_type,
        age_groups_attributes: [:id, :name, :min_competitors, :shorter_trip],
        competitors_attributes: [:id, :first_name, :last_name, :number, :start_time, :arrival_time, :shots_total_input,
                                 :shot_0, :shot_1, :shot_2, :shot_3, :shot_4, :shot_5, :shot_6, :shot_7, :shot_8, :shot_9,
                                 :estimate1, :estimate2, :estimate3, :estimate4, :correct_estimate1, :correct_estimate2,
                                 :correct_estimate3, :correct_estimate4, :shooting_overtime_min,
                                 :no_result_reason, :unofficial, :team_name, :club_name, :age_group_name, :has_result,
                                 :shooting_start_time, :shooting_finish_time] ],
      relays_attributes: [:id, :start_day, :start_time, :name, :legs_count, :finished,
        relay_correct_estimates_attributes: [:id, :distance, :leg],
        relay_teams_attributes: [:id, :name, :number, :no_result_reason,
          relay_competitors_attributes: [:id, :first_name, :last_name, :leg, :start_time, :arrival_time, :misses, :estimate, :adjustment]]],
      team_competitions_attributes: [:id, :name, :team_competitor_count, :multiple_teams, :use_team_name, :temp_series_names, :temp_age_groups_names])
  end
end
