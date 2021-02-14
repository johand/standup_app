# frozen_string_literal: true

module Webhooks
  module Github
    class Add < ActiveJob::Base
      queue_as :default

      def perform(repos, team)
        client = ::Github.new oauth_token: team.account.github.settings['token']
        webhooks = team.integration_settings['github_webhooks'] || []
        repos.each do |repo|
          repo_name, repo_owner = repo.split('|')
          response = client.repos.hooks.create(
            repo_owner,
            repo_name,
            webhook_attributes('https://webhooks.loca.lt', team)
          )

          response = response.to_h
          webhooks.push(
            webhook_record_attributes(repo_name, repo_owner, response)
          )
        end

        team.integration_settings['github_webhooks'] = webhooks
        team.save
      end

      private

      def webhook_attributes(domain, team)
        {
          name: 'web',
          config: {
            url: "#{domain}/integrations/github/webhook/#{team.id}",
            content_type: 'json',
            secret: team.id
          },
          active: true,
          events: %w[push pull_request]
        }
      end

      def webhook_record_attributes(repo_name, repo_owner, response)
        {
          repo_name: repo_name,
          repo_owner: repo_owner,
          id: response['id'],
          internal_url: response['config']['url'],
          external_url: response['url'],
          ping_url: response['ping_url'],
          test_url: response['test_url']
        }
      end
    end
  end
end
