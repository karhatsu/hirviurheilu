class RaceChannel < ApplicationCable::Channel
  def subscribed
    unless params[:race_id].blank?
      race = Race.find params[:race_id]
      stream_for race
    end
  end
end
