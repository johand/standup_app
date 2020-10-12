# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { 'MyString' }
    account
    timezone { 'Arizona' }
    has_reminder { false }
    has_recap { false }
    reminder_time { '2020-09-20 20:05:33' }
    recap_time { '2020-09-20 20:05:33' }
  end
end
