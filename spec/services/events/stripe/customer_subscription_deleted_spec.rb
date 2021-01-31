# frozen_string_literal: true

require 'rails_helper'

describe Events::Stripe::CustomerSubscriptionDeleted do
  it 'queues the mailer based on the event' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      Events::Stripe::CustomerSubscriptionDeleted.new.call(
        StripeMetadata.new(id: 1, type: 'customer.subscription.deleted')
      )
    end.to have_enqueued_job.on_queue('default')
  end
end
