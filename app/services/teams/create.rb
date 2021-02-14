# frozen_string_literal: true

module Teams
  class Create
    include Teams::Shared

    def initialize(team, account, team_params, auth_lambda)
      @team = team
      @account = account
      @team_params = team_params
      @auth_lambda = auth_lambda
    end

    def create
      team.account_id = account.id
      team.days = days_of_the_week
      convert_zone_times_to_utc
      auth_lambda.call
      Webhooks::Github::Manage.new(team).manage
      team.save!
      Result.new(success: true, team: team)
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, team: team, error: e.message)
    end

    private

    attr_reader :team, :account, :team_params, :auth_lambda
  end
end
