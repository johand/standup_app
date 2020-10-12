# frozen_string_literal: true

FactoryBot.define do
  factory :standup do
    user
    standup_date { '2020-09-19' }
  end
end
