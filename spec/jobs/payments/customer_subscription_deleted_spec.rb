# frozen_string_literal: true

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Payments::CustomerSubscriptionDeleted do
  let(:user) { FactoryBot.create(:user, email: 'awesome@dabomb.com') }
  let(:event) do
    stripe_mock_webhook(
      'customer.subscription.deleted',
      user.account.subscription.stripe_subscription_id
    )
  end

  it 'matches with an enqueued job' do
    ActiveJob::Base.queue_adapter = :test
    Payments::CustomerSubscriptionDeleted.perform_later
    expect(Payments::CustomerSubscriptionDeleted).to have_been_enqueued
  end

  it 'enqueues a default based job' do
    ActiveJob::Base.queue_adapter = :test
    expect { Payments::CustomerSubscriptionDeleted.perform_later(event.id) }
      .to have_enqueued_job.on_queue('default')
  end

  it 'updates a subscription' do
    expect_any_instance_of(Subscription).to receive(:update!)
    Payments::CustomerSubscriptionDeleted.perform_now(event.id)
  end

  it 'doesn\'t update a subscription' do
    event = stripe_mock_webhook(
      'customer.subscription.deleted',
      'fake'
    )

    expect_any_instance_of(Subscription).to_not receive(:update!)
    Payments::CustomerSubscriptionDeleted.perform_now(event.id)
  end
end
