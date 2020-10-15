# frozen_string_literal: true

module Reminders
  class FindTeamsJob < ApplicationJob
    def perform(*_args)
      teams.each { |team| Reminders::EmailUserOnTeamJob.perform_later(team) }
    end

    private

    def teams
      @teams ||=
        Team.includes(:days)
            .where(has_reminder: true,
                   reminder_time: Time.at(last_fifteen_marker).utc)
            .where('days_of_the_week_memberships.day = ?', current_day)
            .references(:days_of_the_week_memberships)
    end

    def current_day
      DaysOfTheWeekMembership.days[Time.now.utc.strftime('%A').downcase.to_sym]
    end

    def last_fifteen_marker
      Time.now.utc.to_i - (Time.now.utc.to_i % 15.minutes)
    end
  end
end
