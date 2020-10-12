# frozen_string_literal: true

class NewRegistrarionService
  Result = ImmutableStruct.new(:success?, :user, :account, :error)

  def initialize(params)
    @user = params[:user]
    @account = params[:account]
  end

  def process_registration
    account_create
    send_welcome_email
    notify_slack

    Result.new(success: true, user: user, account: account, error: nil)
  rescue ActiveRecord::RecordInvalid, Slack::Notifier => e
    Result.new(success: false, user: user, account: account, error: e.message)
  end

  private

  attr_reader :user, :account

  def account_create
    post_account_setup if account.save!
  end

  def post_account_setup
    user.account_id = account.id
    user.save!
    user.add_role :admin, account
  end

  def send_welcome_email
    # WelcomeEmailMailer.welcome_email(user).deliver_later
  end

  def notify_slack
    notifier = Slack::Notifier.new('http://hooks.slack.com/services/some_hashed_id')
    notifier.ping(
      "A new User has appeared! #{account.name} - #{user.name} || ENV: #{Rails.env}"
    )
  end
end
