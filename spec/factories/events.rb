# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    type { '' }
    team { nil }
    user_name { 'MyString' }
    user { nil }
    event_name { 'MyString' }
    event_body { 'MyText' }
    event_id { 'MyString' }
    event_data { '' }
    event_time { '2021-02-07 18:54:03' }
  end
end
