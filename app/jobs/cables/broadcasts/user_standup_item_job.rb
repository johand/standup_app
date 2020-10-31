# frozen_string_literal: true

module Cables
  module Broadcasts
    class UserStandupItemJob < ApplicationJob
      def perform(standup)
        standups = standup.user.standups.order(standup_date: :desc)
        UserStandupsChannel.broadcast_to(
          standup.user,
          html: render_standup(standups)
        )
      end

      private

      def render_standup(standups)
        ApplicationController.render(
          partial: 'users/standups/standups',
          locals: { standups: standups }
        )
      end
    end
  end
end
