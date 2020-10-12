# frozen_string_literal: true

class TaskMembership < ApplicationRecord
  belongs_to :task
  belongs_to :standup
end
