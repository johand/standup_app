# frozen_string_literal: true

module Webhooks
  module Github
    class Remove < ActiveJob::Base
      queue_as :default

      rescue_from('Github::Error::UnprocessableEntity') {}

      def perform(repos, team)
        client = ::Github.new oauth_token: team.account.github.settings['token']
        webhooks = team.integration_settings['github_webhooks'] || []
        repos.each do |repo|
          webhook = delete_remote_webhook(client, team, repo)
          webhooks.delete_if { |wh| wh['id'] == webhook['id'] }
        end

        team.integration_settings['github_webhooks'] = webhooks
        team.save
      end

      private

      def delete_remote_webhook(client, team, repo)
        repo_name, repo_owner = repo.split('|')
        webhook = team.integration_settings['github_webhooks'].find do |gwh|
          gwh['repo_name'] == repo_name && gwh['repo_owner'] == repo_owner
        end

        client.repos.hooks.delete(repo_owner, repo_name, webhook['id'])
        webhook
      end
    end
  end
end
