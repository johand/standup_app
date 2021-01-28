# frozen_string_literal: true

require 'rails_helper'

describe Events::Stripe::InvoicePaymentFailed do
  it 'queues the mailer based on the event' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      Events::Stripe::InvoicePaymentFailed.new.call(
        StripeMetadata.new(id: 1, type: 'invoice.payment_failed')
      )
    end.to have_enqueued_job.on_queue('mailers')
  end
end
