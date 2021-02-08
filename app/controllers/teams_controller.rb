# frozen_string_literal: true

class TeamsController < ApplicationController
  include Limits
  include TeamEvents

  load_and_authorize_resource except: [:create]
  around_action :use_time_zone, only: %i[edit show]
  before_action :setup_integration_data, only: %i[new edit]

  RepoInfo = ImmutableStruct.new(:name, :owner)

  def index
    @teams = visible_teams
  end

  def show
    set_teams_and_standups(Date.today.iso8601)
    set_events
  end

  def new
    @team = Team.new
    set_users
  end

  def create
    check_resource_against_limits(:teams) do
      return redirect_back(
        fallback_location: root_path,
        notice: 'You do not have the resources to create this Team, please consider upgrading your plan.'
      )
    end

    @team = Team.new(team_params.except('days'))
    response = Teams::Create.new(
      @team,
      current_account,
      team_params, -> { authorize!(:create, @team) }
    ).create

    if response.success?
      redirect_to @team, notice: 'Team was successfully created.'
    else
      set_users
      render :new
    end
  end

  def edit
    @team = Team.find(params[:id])
    set_users
  end

  def update
    @team = Team.find(params[:id])
    response = Teams::Update.new(@team, team_params).update

    if response.success?
      redirect_to teams_url, notice: 'Team was successfully updated.'
    else
      set_users
      setup_integration_data
      render :edit
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.integration_settings['github_repos'] = nil
    Webhooks::Github::Manage.new(@team).manage
    @team.destroy
    redirect_to teams_url, notice: 'Team was successfully destroyed.'
  end

  private

  def team_params
    params.require(:team).permit(:name, :description, :timezone, :has_reminder,
                                 :has_recap, :reminder_time, :recap_time,
                                 days: [], user_ids: [], integration_settings: [])
  end

  def setup_integration_data
    setup_github
  end

  def setup_github
    @github = Integrations::Github.find_by(account_id: current_account.id)
    return unless @github

    client = Github.new oauth_token: @github.settings['token']
    @grepos = client.repost.list.body.map do |r|
      RepoInfo.new(name: r.name, owner: r.owner.login)
    end
  end

  def set_users
    @account_users ||=
      current_account.users.where.not(invitation_accepted_at: nil) +
      current_account.users.with_role(:admin, current_account).uniq
  end

  def days
    params[:team][:days]&.map do |day|
      DaysOfTheWeekMembership.new(
        team_id: @team.id,
        day: day
      )
    end || []
  end

  def convert_zone_times_to_utc
    convert_reminder
    convert_recap
  end

  def convert_reminder
    return nil unless @team.reminder_time && @team.has_reminder

    @team.reminder_time = ActiveSupport::TimeZone[@team.timezone]
                          .parse(@team.reminder_time.to_s[11..18]).utc
  end

  def convert_recap
    return nil unless @team.recap_time && @team.has_recap

    @team.recap_time = ActiveSupport::TimeZone[@team.timezone]
                       .parse(@team.recap_time.to_s[11..18]).utc
  end

  def use_time_zone(&block)
    Time.use_zone(@team.timezone, &block)
  end
end
