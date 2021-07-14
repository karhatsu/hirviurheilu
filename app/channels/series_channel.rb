class SeriesChannel < ApplicationCable::Channel
  def subscribed
    series = Series.find params[:series_id]
    stream_for series
  end
end
