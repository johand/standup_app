# frozen_string_literal: true

class TeamStandupsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    date = Base64.urlsafe_encode64 params[:date], padding: false
    stream_from "team:#{params[:team_id]}:standups:#{date}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
