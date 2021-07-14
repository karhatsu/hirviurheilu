class RaceChannel < ApplicationCable::Channel
  def subscribed
    race = Race.find params[:race_id]
    stream_for race
  end
end
