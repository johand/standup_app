# frozen_string_literal: true

Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.stripe[:pkey],
  secret_key: Rails.application.credentials.stripe[:api_key]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.signing_secret = Rails.application.credentials.stripe[:signing_secret]

StripeMetadata = ImmutableStruct.new(:id, :type)

StripeEvent.event_filter = lambda do |event|
  return nil if StripeWebhook.exists?(stripe_event_id: event.id)

  StripeWebhook.create!(stripe_event_id: event.id)
  StripeMetadata.new(id: event.id, type: event.type)
end

Rails.application.config.to_prepare do
  StripeEvent.configure do |events|
    events.subscribe(
      'invoice.payment_succeeded',
      ::Events::Stripe::InvoicePaymentSucceeded.new
    )

    events.subscribe(
      'invoice.payment_failed',
      ::Events::Stripe::InvoicePaymentFailed.new
    )

    events.subscribe(
      'invoice.upcoming',
      ::Events::Stripe::InvoiceUpcoming.new
    )

    events.subscribe(
      'customer.subscription.trial_will_end',
      ::Events::Stripe::CustomerSubscriptionTrialWillEnd.new
    )

    events.subscribe(
      'customer.subscription.deleted',
      ::Events::Stripe::CustomerSubscriptionDeleted.new
    )
  end
end
