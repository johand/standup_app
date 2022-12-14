# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { 'MyString' }
    addr1 { 'MyString' }
    addr2 { 'MyString' }
    city { 'MyString' }
    state { 'MyString' }
    zip { 'MyString' }
    country { 'MyString' }
    settings { '' }
    association :subscription, factory: :subscription, strategy: :build
  end
end
