# frozen_string_literal: true

module Webhooks
  module Github
    module PushEvent
      class Record < ApplicationJob
        rescue_from('ActiveRecord::RecordNotFound') {}

        def perform(json, team_id)
          team = Team.find(team_id)
          json['commits'].each do |commit|
            next if Event.exists?(event_id: commit['id'])

            event = Events::Github.new(
              event_attributes(team, commit, json)
            )

            set_user!(commit, event)
            event.save!
          end
        end

        private

        def event_attributes(team, commit, json)
          {
            team_id: team.id,
            event_name: 'commit',
            event_body: commit['message'],
            event_id: commit['id'],
            event_time: Time.parse(commit['timestamp']),
            event_data: event_custom_attributes(commit, json)
          }
        end

        def event_custom_attributes(commit, json)
          {
            commit_time: commit['timestamp'],
            commit_url: commit['url'],
            branch: json['ref'].split('/')[-1],
            repo_name: json['repository']['name'],
            repo_url: json['repository']['html_url'],
            changed: {
              added: commit['added'],
              removed: commit['removed'],
              modified: commit['modified']
            }
          }
        end

        def set_user!(commit, event)
          if (user = User.find_by(github_username: commit['author']['username']))
            event.user_id = user.id
          elsif (user = User.find_by(email: commit['author']['email']))
            event.user_id = user.id
          else
            event.user_name = commit['author']['username']
          end
        end
      end
    end
  end
end
