# frozen_string_literal: true

FactoryBot.define do
  factory :days_of_the_week_membership do
    team
    day { 1 }
  end
end
