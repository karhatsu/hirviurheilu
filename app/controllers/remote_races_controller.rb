class RemoteRacesController < ApplicationController
  def create
    p "REMOTE_RACES_CONTROLLER!"
    race = Race.new(params[:remote_race])
    user = User.last # TODO: fix this
#    user = User.find_by_email(params[:email]) # TODO: password check
    respond_to do |format|
      if race.save
        user.races << race
        format.xml { render :xml => race, :status => :created, :location => race }
      else
        format.xml { render :xml => race.errors, :status => :unprocessable_entity }
      end
    end
  end
end
