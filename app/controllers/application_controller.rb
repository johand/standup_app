# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include StandupsHelper
  before_action :authenticate_user!
  layout :layout_by_resource

  helper_method :current_account
  helper_method :current_subscription
  helper_method :current_date
  helper_method :notification_standups

  def current_account
    @current_account ||= current_user.account
    @current_account
  end

  def current_subscription
    @current_subscription ||= current_user&.account&.subscription
    @current_subscription
  end

  def current_date
    session[:current_date] = session[:current_date] || Date.today.iso8601
    @current_date ||= session[:current_date]
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, error: exception.message
  end

  add_flash_types :error

  def visible_teams
    @visible_teams ||=
      if current_user.has_role? :admin, current_account
        current_account.teams.includes(:users)
      else
        current_user.teams.includes(:users)
      end

    @visible_teams
  end

  def set_teams_and_standups(date)
    @team = Team.includes(:users).find(params[:id])

    @standups = @team.users.flat_map do |u|
      u.standups.where(standup_date: date)
       .includes(:dids, :todos, :blockers)
       .references(:tasks)
    end
  end

  def handle_response(response:,
                      success_message:,
                      success_path: billing_index_path,
                      failure_message:,
                      failure_path: billing_index_path)

    if response.success?
      redirect_back(fallback_location: success_path, notice: success_message) &&
        true
    else
      logger.info "[STRIPE] Problem: #{response.error}"
      redirect_back(fallback_location: failure_path, notice: failure_message) &&
        true
    end
  end

  protected

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
end
