# frozen_string_literal: true

require 'rails_helper'

describe NotificationServices::SlackWebhooks do
  describe 'the SlackWebhooks service object' do
    context 'from form input' do
      let(:account) { FactoryBot.build(:account) }
      let(:user) { FactoryBot.build(:user) }

      it 'responds to send_message' do
        expect_any_instance_of(
          NotificationServices::SlackWebhooks
        ).to receive(:send_message).once

        NotificationServices::SlackWebhooks::NewAccount.new(
          account: account,
          user: user
        ).send_message
      end
    end
  end
end
