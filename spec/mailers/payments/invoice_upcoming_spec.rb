# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Payments::InvoiceUpcoming, type: :mailer do
  let(:user) do
    user = FactoryBot.create(:user, email: 'awesome@dabomb.com')
    user.account.subscription.update(stripe_subscription_id: 'uniq_string')
    user
  end

  let(:merge_data) { { amount_due: 0, next_payment_attempt: Time.now.to_i } }
  let(:event) do
    stripe_mock_webhook(
      'invoice.upcoming',
      user.account.subscription.stripe_subscription_id,
      nil,
      merge_data
    )
  end

  it 'job is created' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      Payments::InvoiceUpcoming.email(event.id).deliver_later
    end.to have_enqueued_job.on_queue('mailers')
  end

  it 'email is sent' do
    expect do
      perform_enqueued_jobs do
        Payments::InvoiceUpcoming.email(event.id).deliver_later
      end
    end.to change { ActionMailer::Base.deliveries.size }.by(1)
  end

  it 'email is not sent' do
    expect do
      @evt_id = stripe_mock_webhook(
        'invoice.upcoming',
        '32',
        nil,
        merge_data
      ).id

      perform_enqueued_jobs do
        Payments::InvoiceUpcoming.email(@evt_id).deliver_later
      end
    end.to change { ActionMailer::Base.deliveries.size }.by(0)
  end

  it 'email is sent to the right user' do
    perform_enqueued_jobs do
      Payments::InvoiceUpcoming.email(event.id).deliver_later
    end

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to[0]).to eq user.email
  end
end
