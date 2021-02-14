# frozen_string_literal: true

class Events::GithubController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  skip_before_action :subscription_check

  rescue_from ActionController::BadRequest do
    head :unauthorized
  end

  def create
    return unless verify_signature(request.body.read)

    handle_request
    head :ok
  end

  private

  def verify_signature(payload_body)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha1'),
      params[:team_id],
      payload_body
    )

    unless Rack::Utils.secure_compare(
      signature,
      request.env['HTTP_X_HUB_SIGNATURE']
    )

      raise ActionController::BadRequest
    end
  end

  def handle_request
    case request.env['HTTP_X_GITHUB_EVENT']
    when 'push'
      Webhooks::Github::PushEvent::Record.perform_later(
        JSON.parse(request.body.read),
        params[:team_id]
      )
    when 'pull_request'
      Webhooks::Github::PullRequestEvent::Record.perform_later(
        JSON.parse(request.body.read),
        params[:team_id]
      )
    end
  end
end
