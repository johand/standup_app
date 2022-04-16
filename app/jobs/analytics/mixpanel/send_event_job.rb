# frozen_string_literal: true

module Analytics
  module Mixpanel
    class SendEventJob < ApplicationJob
      def perform(user, event_name, event_data)
        TRACKER.track(user.id, event_name, event_data) if user
      end
    end
  end
end
