# frozen_string_literal: true

class SlackNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    NotificationServices::SlackWebhooks::NewAccount.new(
      account: user.account,
      user: user
    ).send_message
  end
end
