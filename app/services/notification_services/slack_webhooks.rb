# frozen_string_literal: true

module NotificationServices
  class SlackWebhooks
    private

    def send_message(webhook, message)
      notifier = Slack::Notifier.new(webhook)
      notifier.ping(message)
    end
  end
end
