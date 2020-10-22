# frozen_string_literal: true

module Cables
  module Broadcasts
    class StandupItemJob < ApplicationJob
      def perform(standup)
        StandupsChannel.broadcast_to(
          standup,
          id: standup.id,
          html: render_standup(standup)
        )
      end

      private

      def render_standup(standup)
        ApplicationController.render(
          partial: 'standups/standup',
          locals: { standup: standup }
        )
      end
    end
  end
end
