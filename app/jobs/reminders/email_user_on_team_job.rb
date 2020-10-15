# frozen_string_literal: true

module Reminders
  class EmailUserOnTeamJob < ApplicationJob
    def perform(team)
      EmailUserOnTeamJob.reminder_email(user, team).deliver_later
    end
  end
end
