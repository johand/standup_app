# frozen_string_literal: true

module Webhooks
  module Github
    module PullRequestEvent
      class Record < ApplicationJob
        rescue_from('ActiveRecord::RecordNotFound') {}

        def perform(json, team_id)
          pull_request = json['pull_request']
          team = Team.find(team_id)
          data_from_json = determine_event_name_and_time(
            json['action'],
            pull_request
          )

          return if Event.exists?(
            event_id: pull_request['id'],
            event_name: data_from_json[:event]
          )

          event = Events::Github.new(
            event_attributes(team, pull_request, json, data_from_json)
          )

          set_user!(pull_request, event)
          event.save!
        end

        private

        def determine_event_name_and_time(action, pull_request)
          case action
          when 'opened'
            {
              event: 'pull_request_opened',
              event_time: Time.parse(pull_request['created_at'])
            }
          when 'closed'
            if pull_request['merged']
              {
                event: 'pull_request_merged',
                event_time: Time.parse(pull_request['merge_at'])
              }
            else
              {
                event: 'pull_request_closed',
                event_time: Time.parse(pull_request['closed_at'])
              }
            end
          end
        end

        def event_attributes(team, pull_request, json, data_from_json)
          {
            team_id: team.id,
            event_name: data_from_json[:event],
            event_body: pull_request['title'],
            event_id: pull_request['id'],
            event_time: data_from_json[:event_time],
            event_data: event_custom_attributes(pull_request, json)
          }
        end

        def event_custom_attributes(pull_request, json)
          {
            pull_request_url: pull_request['html_url'],
            diff_url: pull_request['diff_url'],
            pull_head: pull_request['head']['label'],
            pull_base: pull_request['base']['label'],
            repo_url: json['repository']['html_url']
          }
        end

        def set_user!(pull_request, event)
          if (user = User.find_by(github_username: pull_request['user']['login']))
            event.user_id = user.id
          else
            event.user_name = pull_request['user']['username']
          end
        end
      end
    end
  end
end
