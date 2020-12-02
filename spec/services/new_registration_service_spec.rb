# frozen_string_literal: true

require 'rails_helper'

describe NewRegistrationService do
  subject(:registration_service) { NewRegistrationService }

  describe 'create an accounts' do
    context 'from form input' do
      let(:account) { FactoryBot.build(:account) }
      let(:bad_account) { FactoryBot.build(:account, { name: nil }) }
      let(:user) { FactoryBot.build(:user) }

      before do
        allow(Slack::Notifier).to receive_message_chain(:new, :ping) { nil }
      end

      it 'creates an account' do
        expect do
          registration_service
            .new(account: account, user: user)
            .process_registration
        end.to change(Account, :count).by(1)
      end

      it 'does not create an account on invalid object' do
        expect do
          registration_service
            .new(account: bad_account, user: user)
            .process_registration
        end.to change(Account, :count).by(0)
      end

      it 'creates a user' do
        expect do
          registration_service
            .new(account: account, user: user)
            .process_registration
        end.to change(User, :count).by(1)
      end

      it 'sends a message to be passed to welcome email method' do
        expect_any_instance_of(
          NewRegistrationService
        ).to receive(:send_welcome_email).once

        registration_service
          .new(account: account, user: user)
          .process_registration
      end

      it 'sends a message to be passed to slack method' do
        expect_any_instance_of(
          NewRegistrationService
        ).to receive(:notify_slack).once

        registration_service
          .new(account: account, user: user)
          .process_registration
      end
    end
  end
end
