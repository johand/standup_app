# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'MyString' }
    email { 'email.test@mail.com' }
    password { '123ewq' }
  end
end
