# frozen_string_literal: true

module Teams
  class Update
    include Teams::Shared

    def initialize(team, team_params)
      @team = team
      @team_params = team_params
    end

    def update
      team.attributes = team_params.except('days')
      days_of_the_week
      convert_zone_times_to_utc
      Webhooks::Github::Manage.new(team).manage
      team.save!
      Result.new(success: true, team: team)
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, team: team, error: e.message)
    end

    private

    attr_reader :team, :team_params
  end
end
