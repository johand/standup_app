# frozen_string_literal: true

class IntegrationsController < ApplicationController
  def index
    @github = Integrations::Github.find_by(account_id: current_account.id)
    return unless @github

    fetch_remote_repos
  end

  def destroy
    if delete_integration
      redirect("Removed #{params[:provider].capitalize} integration. Please be\
 sure to remove the application through your settings area in #{params[:provider].capitalize}")
    else
      redirect("Unable to removed #{params[:provider].capitalize} integration")
    end
  end

  private

  def integration
    case params[:provider]
    when 'github'
      Integrations::Github
    end
  end

  def fetch_remote_repos
    client = Github.new oauth_token: @github.settings['token']
    @grepos = client.repos.list.body.map(&:name)
  end

  def delete_integration
    integration&.find_by(account_id: current_account.id)&.delete
  end

  def redirect(flash_message)
    redirect_to(
      integrations_path,
      notice: flash_message
    )
  end
end
