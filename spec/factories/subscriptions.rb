FactoryBot.define do
  factory :subscription do
    account { nil }
    plan_id { "MyString" }
    stripe_customer_id { "MyString" }
    start { "2020-11-30 18:48:35" }
    status { "MyString" }
    stripe_subscription_id { "MyString" }
    stripe_token { "MyString" }
    card_last4 { "MyString" }
    card_expiration { "MyString" }
    card_type { "MyString" }
    stripe_status { "MyString" }
    idempotency_key { "MyString" }
  end
end
