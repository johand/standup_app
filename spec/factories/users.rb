# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    association :account, factory: :account, strategy: :build

    name { 'MyString' }
    email { Faker::Internet.email }
    password { '123ewq' }
    password_confirmation { '123ewq' }
  end
end
