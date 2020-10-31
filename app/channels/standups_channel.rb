# frozen_string_literal: true

class StandupsChannel < ApplicationCable::Channel
  def subscribed
    standup = Standup.find(params[:standup_id])
    stream_for standup
  end

  def unsubscribed
    stop_all_streams
  end
end
