# frozen_string_literal: true

module NotificationServices
  class SlackWebhooks
    class NewAccount < SlackWebhooks
      WEBHOOK_URL = 'https://hooks.slack.com/services/some_hashed_id'

      def initialize(params)
        @user = params[:user]
        @account = params[:account]
      end

      def send_message
        super(WEBHOOK_URL, message)
      end

      private

      attr_reader :user, :account

      def message
        "A New User has appeared! #{account.name} - #{user.name} || ENV: #{Rails.env}"
      end
    end
  end
end
