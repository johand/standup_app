# frozen_string_literal: true

require 'rails_helper'

describe Events::Stripe::CustomerSubscriptionTrialWillEnd do
  it 'queues the mailer based on the event' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      Events::Stripe::CustomerSubscriptionTrialWillEnd.new.call(
        StripeMetadata.new(id: 1, type: 'customer.subscription.trial_will_end')
      )
    end.to have_enqueued_job.on_queue('mailers')
  end
end
