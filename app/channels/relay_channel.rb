class RelayChannel < ApplicationCable::Channel
  def subscribed
    relay = Relay.find params[:relay_id]
    stream_for relay
  end
end
