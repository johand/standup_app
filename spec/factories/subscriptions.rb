# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    account { build(:account, subscription: nil) }
    plan_id { 'free' }
    stripe_customer_id { 'MyString' }
    start { '2020-04-05 16:03:29' }
    status { 'active' }
    stripe_subscription_id { 'MyString' }
    stripe_token { nil }
    card_last4 { '4242' }
    card_expiration { 'MyString' }
    card_type { 'MyString' }
    stripe_status { 'MyString' }
    idempotency_key { 'MyString' }
  end
end
