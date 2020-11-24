# frozen_string_literal: true

module Cables
  module Broadcasts
    class StandupNotificationJob < ApplicationJob
      include StandupsHelper

      def perform(user)
        users = user.teams.flat_map(&:users)
        users.each do |notification_user|
          NotificationsChannel.broadcast_to(
            notification_user,
            html: render_standup(notification_user),
            json: Api::StandupsSerializer.new(notification_standups(user)).as_json
          )
        end
      end

      private

      def render_standup(user)
        ApplicationController.render(
          partial: 'layouts/navigation/notifications',
          locals: { notification_standups: notification_standups(user) }
        )
      end
    end
  end
end
