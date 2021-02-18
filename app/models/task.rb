# frozen_string_literal: true

class Task < ApplicationRecord
  after_commit { standups.find_each(&:touch) }

  validates_presence_of :title
  validates_presence_of :type

  has_many :task_memberships
  has_many :standups, through: :task_memberships
end
