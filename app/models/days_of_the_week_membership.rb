# frozen_string_literal: true

class DaysOfTheWeekMembership < ApplicationRecord
  belongs_to :team

  enum day: %i[sunday monday tuesday wednesday thursday friday saturday]
end
