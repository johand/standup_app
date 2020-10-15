# frozen_string_literal: true

module Reminders
  class EmailUserOnTeamJob < ApplicationJob
    def perform(team)
      team.users.each do |user|
        EmailReminderMailer.reminder_email(user, team).deliver_later
      end
    end
  end
end
