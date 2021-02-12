# frozen_string_literal: true

module Webhooks
  module Github
    class Manage
      def initialize(team)
        @team = team
      end

      def manage
        return if !team.integration_settings_changed? ||
                  (
                    team.integration_settings_change[0]&.dig('github_repos') ==
                    team.integration_settings_change[1]&.dig('github_repos')
                  )

        check_webhooks_to_remove
        check_webhooks_to_add
      end

      private

      attr_reader :team

      def check_webhooks_to_remove
        repos = (
          team.integration_settings_change[0]&.dig('github_repos') || [] -
          team.integration_settings_change[1]&.dig('github_repos') || []
        ) || []

        remove_webhook(repos)
      end

      def check_webhooks_to_add
        repos = (
          team.integration_settings_change[1]&.dig('github_repos') || [] -
          team.integration_settings_change[0]&.dig('github_repos') || []
        ) || []

        add_webhook(repos)
      end

      def add_webhook(repos)
        return if repos.empty?

        Webhooks::Github::Add.perform_later(repos, team)
      end

      def remove_webhook(repos)
        return if repos.empty?

        Webhooks::Github::Remove.perform_later(repos, team)
      end
    end
  end
end
