# frozen_string_literal: true

require 'rails_helper'

describe Events::Stripe::InvoiceUpcoming do
  it 'responds to send_message' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      Events::Stripe::InvoiceUpcoming.new.call(
        StripeMetadata.new(id: 1, type: 'invoice.upcoming')
      )
    end.to have_enqueued_job.on_queue('mailers')
  end
end
