# frozen_string_literal: true

Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.stripe[:pkey],
  secret_key: Rails.application.credentials.stripe[:api_key]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
