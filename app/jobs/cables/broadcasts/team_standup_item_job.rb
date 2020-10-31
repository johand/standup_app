# frozen_string_literal: true

module Cables
  module Broadcasts
    class TeamStandupItemJob < ApplicationJob
      def perform(standup)
        teams = standup.user.teams
        date = Base64.urlsafe_encode64 standup.standup_date.iso8601, padding: false
        teams.each do |team|
          ActionCable.server.broadcast(
            "team:#{team.id}:standups:#{date}",
            html: render_standup(standups(team, standup.standup_date))
          )
        end
      end

      private

      def render_standup(standups)
        ApplicationController.render(
          partial: 'shared/standups',
          locals: { standups: standups }
        )
      end

      def standups(team, date)
        team.users.flat_map do |user|
          user.standups.where(standup_date: date).order(standup_date: :desc)
        end
      end
    end
  end
end
