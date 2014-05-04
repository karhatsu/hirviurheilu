require 'spec_helper'

describe Official::CompetitorsController do
  describe "#handle_club" do
    before do
      @race = FactoryGirl.create(:race)
      @series = FactoryGirl.create(:series, :race => @race)
    end

    controller(Official::CompetitorsController) do
      skip_before_action :require_user, :check_rights, :set_official
      skip_before_action :assign_series_by_series_id, :check_assigned_series
      skip_before_action :assign_race_by_race_id, :check_assigned_race
      skip_before_action :handle_start_time, :handle_time_parameters
      skip_before_action :set_competitors, :ensure_user_in_offline

      def create
        series = Series.find(params[:series_id])
        competitor = series.competitors.build(params[:competitor])
        handle_club(competitor)
        @club_id = competitor.club_id
        @club = competitor.club
        render :nothing => true
      end

      def update
        series = Series.find(params[:series_id])
        competitor = series.competitors.find(params[:id])
        handle_club(competitor)
        @club_id = competitor.club_id
        @club = competitor.club
        render :nothing => true
      end
    end

    context "on create" do
      context "when club_id and club_name are given" do
        it "should set the id for the competitor and ignore the name" do
          Club.should_not_receive(:create!)
          post :create, :series_id => @series.id, :club_id => 7, :club_name => 'Test club'
          assigns(:club_id).should == 7
          assigns(:club).should be_nil
        end
      end

      context "when new club name is given" do
        it "should create a new club and set it for the competitor" do
          post :create, :series_id => @series.id, :club_name => 'Test club'
          club = Club.find_by_name('Test club')
          club.should_not be_nil
          assigns(:club).should == club
        end
      end

      context "when existing club name is given" do
        before do
          @club = FactoryGirl.create(:club, :name => 'Existing club', :race => @race)
        end

        it "should find the existing club and set it for the competitor" do
          post :create, :series_id => @series.id, :club_name => 'Existing club'
          assigns(:club).should == @club
        end
      end

      context "when club_id 0 and club name is given" do
        it "should ignore zero club id and use the name" do
          post :create, :series_id => @series.id, :club_id => 0, :club_name => 'Test club'
          club = Club.find_by_name('Test club')
          club.should_not be_nil
          assigns(:club).should == club
        end
      end
    end

    context "on update" do
      before do
        @competitor = FactoryGirl.create(:competitor, series: @series)
      end

      context "when club_id 0 and new club name is given" do
        it "should create a new club and set it for the competitor" do
          patch :update, series_id: @series.id, id: @competitor.id, club_id:0, club_name: 'Test club', competitor: {}
          club = Club.find_by_name('Test club')
          club.should_not be_nil
          assigns(:club).should == club
          assigns(:club_id).should == club.id
        end
      end
    end
  end
end

