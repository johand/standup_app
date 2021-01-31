FactoryBot.define do
  factory :stripe_webhook do
    stripe_event_id { "MyString" }
  end
end
