# frozen_string_literal: true

module Recaps
  class EmailUserOnTeamJob < ApplicationJob
    def perform(team, date = Date.today.iso8601)
      standups = team.users.flat_map do |u|
        u.standups.where(standup_date: date)
      end

      return if standups.empty?

      team.users.each do |user|
        EmailRecapMailer.recap_email(user, team, standups).deliver_later
      end
    end
  end
end
